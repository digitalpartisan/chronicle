Scriptname Chronicle:Logger:Package Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[1]
	tags[0] = "Package"
	return tags
EndFunction

Bool Function log(String sMessage) Global
	return Chronicle:Logger.log(sMessage, getTags())
EndFunction

Bool Function warn(String sMessage) Global
	return Chronicle:Logger.warn(sMessage, getTags())
EndFunction

Bool Function error(String sMessage) Global
	return Chronicle:Logger.error(sMessage, getTags())
EndFunction

Bool Function logInvalidVersion(Chronicle:Package packageRef) Global
	return log(packageRef + " has an invalid version setting")
EndFunction

Bool Function logAlreadyInstalled(Chronicle:Package packageRef) Global
	return log(packageRef + " is already installed")
EndFunction

Bool Function logShepherdGameLoad(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " has observed a game load event")
EndFunction

Bool Function logShepherdQueuePackage(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " has queued package " + shepherdRef.MyPackage)
EndFunction

Bool Function logShepherdAlreadyInstalled(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " detected package is already installed, shutting down")
EndFunction

Bool Function logCannotInstall(Chronicle:Package packageRef) Global
	return log(packageRef + " is unable to install at this time")
EndFunction

Bool Function logCannotUninstall(Chronicle:Package packageRef) Global
	return log(packageRef + " is unable to uninstall at this time")
EndFunction

Bool Function logSetupStateUnableToInstall(Chronicle:Package packageRef) Global
	return log(packageRef + " made it into the setup state but cannot install")
EndFunction

Bool Function logCustomInstallBehaviorFailed(Chronicle:Package packageRef) Global
	return error(packageRef + " could not complete its custom install behavior")
EndFunction

Bool Function logCouldNotInitializeCurrentVersion(Chronicle:Package packageRef) Global
	return error(packageRef + " could not initialize its version data during installation")
EndFunction

Bool Function handlerReceivedPackage(Chronicle:Package:Handler handlerRef, Chronicle:Package packageRef) Global
	return log(handlerRef + " received package: " + packageRef)
EndFunction

Bool Function handlerStatus(Chronicle:Package:Handler handlerRef) Global
	return log(handlerRef + " status: is valid: " + handlerRef.isValid() + " can install: " + handlerRef.canInstall() + " can uninstall: " + handlerRef.canUninstall())
EndFunction
