Scriptname Chronicle:Package:Shepherd extends Quest
{This script shepherds a package to its engine based on whether or not the package can be installed either when this shepherd runs for the first time or when the game is loaded at some point in the future.}

Chronicle:Package:NonCore Property MyPackage Auto Const Mandatory

Chronicle:Package:NonCore Function getPackage()
	return MyPackage
EndFunction

Function attemptInstallation()
	Chronicle:Package:NonCore packageRef = getPackage()

	if (packageRef.isInstalled())
		Chronicle:Logger:Package:Shepherd.logPackageAlreadyInstalled(self)
		Stop()
		return
	endif
	
	if (!packageRef.isEngineAccessible()) ; in case we're trying to install into a remote engine, make sure it actually exists where we can find it
		Chronicle:Logger:Package:Shepherd.logEngineNotAccessible(self)
		return
	endif
	
	Chronicle:Engine engineRef = packageRef.getEngine()
	if (!engineRef.isInstallerReady())
		Chronicle:Logger:Package:Shepherd.logListeningForInstallerReady(self)
		RegisterForCustomEvent(engineRef, "InstallerInitialized")
		return
	endif
	
	if (packageRef.requestInstallation())
		Chronicle:Logger:Package:Shepherd.logRequestAccepted(self)
		Stop()
	else
		Chronicle:Logger:Package:Shepherd.logRequestDenied(self)
	endif
EndFunction

Function gameLoaded()
	Chronicle:Logger:Package:Shepherd.logGameLoaded(self)
	attemptInstallation()
EndFunction

Event OnQuestInit()
	Chronicle:Logger:Package:Shepherd.logInit(self)
	attemptInstallation()
EndEvent

Event Chronicle:Engine.InstallerInitialized(Chronicle:Engine akSender, Var[] args)
	if (getPackage().getEngine() == akSender)
		Chronicle:Logger:Package:Shepherd.logNotListeningForInstallerReady(self)
		UnregisterForCustomEvent(akSender, "InstallerInitialized")
		attemptInstallation()
	endif
EndEvent
