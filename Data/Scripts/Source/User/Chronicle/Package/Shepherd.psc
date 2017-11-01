Scriptname Chronicle:Package:Shepherd extends Quest
{This script shepherds a package to its engine based on whether or not the package can be installed either when this shepherd runs for the first time or when the game is loaded at some point in the future.}

Chronicle:Package Property MyPackage Auto Const Mandatory

Function attemptInstallation()
	if (MyPackage.isInstalled())
		Chronicle:Logger:Package.logShepherdAlreadyInstalled(self)
		Stop()
	endif

	if (MyPackage.requestInstallation())
		Chronicle:Logger:Package.logShepherdQueuePackage(self)
		Stop()
	endif
EndFunction

Function gameLoaded()
	Chronicle:Logger:Package.logShepherdGameLoad(self)
	attemptInstallation()
EndFunction

Event OnQuestInit()
	attemptInstallation()
EndEvent
