Scriptname Chronicle:Package:Shepherd extends Quest
{This script shepherds a package to its engine based on whether or not the package can be installed either when this shepherd runs for the first time or when the game is loaded at some point in the future.}

Chronicle:Package Property MyPackage Auto Const Mandatory

Function attemptInstallation()
	if (MyPackage.isInstalled())
		Chronicle:Logger:Package.logShepherdAlreadyInstalled(self)
		Stop()
		return
	endif
	
	Chronicle:Engine engineRef = MyPackage.getEngine()
	if (!engineRef.isInstallerReady())
		RegisterForCustomEvent(engineRef, "InstallerInitialized")
		return
	endif
	
	if (MyPackage.requestInstallation())
		Chronicle:Logger:Package.logShepherdQueuePackage(self)
		Stop()
		return
	endif
EndFunction

Function gameLoaded()
	Chronicle:Logger:Package.logShepherdGameLoad(self)
	attemptInstallation()
EndFunction

Event OnQuestInit()
	attemptInstallation()
EndEvent

Event Chronicle:Engine.InstallerInitialized(Chronicle:Engine akSender, Var[] args)
	if (MyPackage.getEngine() == akSender)
		UnregisterForCustomEvent(akSender, "InstallerInitialized")
		attemptInstallation()
	endif
EndEvent
