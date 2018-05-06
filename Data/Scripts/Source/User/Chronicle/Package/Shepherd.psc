Scriptname Chronicle:Package:Shepherd extends Quest
{A shepherd is responsible for "shepherding" a non-core package to its engine when the engine is ready to receive non-core packages to install.
For this reason, the quest object you attach this script to should have the "Start Game Enabled" and "Run Once" boxes checked.  The shepherd will
observe both game load events and (if the engine is accessible) installer initialization events until it is able to queue the package for installation
and then it will shut down.}

Chronicle:Package:NonCore Property MyPackage Auto Const Mandatory
{Note the script type.  Core packages do not need a shepherd}

Bool bListening = false ; to avoid reregistering for the installer initialization event upon game load

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
	if (!engineRef.isInstallerReady() && !bListening)
		Chronicle:Logger:Package:Shepherd.logListeningForInstallerReady(self)
		RegisterForCustomEvent(engineRef, "InstallerInitialized")
		bListening = true
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
		bListening = false
		attemptInstallation()
	endif
EndEvent
