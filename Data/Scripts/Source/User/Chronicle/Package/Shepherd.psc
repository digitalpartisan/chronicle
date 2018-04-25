Scriptname Chronicle:Package:Shepherd extends Quest
{This script shepherds a package to its engine based on whether or not the package can be installed either when this shepherd runs for the first time or when the game is loaded at some point in the future.}

Chronicle:Package:NonCore Property MyPackage Auto Const Mandatory

Function attemptInstallation()
	if (MyPackage.isInstalled())
		Chronicle:Logger:Package.logShepherdAlreadyInstalled(self)
		Stop()
		return
	endif
	
	if (!MyPackage.isEngineAccessible()) ; in case we're trying to install into a remote engine, make sure it actually exists where we can find it
		return
	endif
	
	Chronicle:Engine engineRef = MyPackage.getEngine()
	if (!engineRef.isInstallerReady())
		RegisterForCustomEvent(engineRef, "InstallerInitialized")
		return
	endif
	
	if (MyPackage.requestInstallation())
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
