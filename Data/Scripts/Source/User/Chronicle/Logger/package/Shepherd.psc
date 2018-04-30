Scriptname Chronicle:Logger:Package:Shepherd Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[2]
	tags[0] = "Package"
	tags[1] = "Shepherd"
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

Bool Function logGameLoaded(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " has observed a game load event")
EndFunction

Bool Function logListeningForInstallerReady(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " is listening for installer " + shepherdRef.getPackage().GetEngine())
EndFunction

Bool Function logNotListeningForInstallerReady(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " is no longer listening for installer " + shepherdRef.getPackage().GetEngine())
EndFunction

Bool Function logEngineNotAccessible(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " package's engine is not accessible " + shepherdRef.getPackage())
EndFunction

Bool Function logPackageAlreadyInstalled(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " package is already installed " + shepherdRef.getPackage())
EndFunction

Bool Function logInit(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " has initialized")
EndFunction

Bool Function logRequestAccepted(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " install request accepted for package " + shepherdRef.getPackage())
EndFunction

Bool Function logRequestDenied(Chronicle:Package:Shepherd shepherdRef) Global
	return log(shepherdRef + " install request denied for package " + shepherdRef.getPackage())
EndFunction	
