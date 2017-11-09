Scriptname Chronicle:Logger:Engine:Installer Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[2]
	tags[0] = "Engine"
	tags[1] = "Installer"
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

Bool Function logListening(Chronicle:EngineComponent:Installer installerRef, Chronicle:Package packageRef) Global
	return log(installerRef + " is listening for package " + packageRef)
EndFunction

Bool Function logStopListening(Chronicle:EngineComponent:Installer installerRef, Chronicle:Package packageRef) Global
	return log(installerRef + " is no longer listening for package " + packageRef)
EndFunction

Bool Function logQueued(Chronicle:EngineComponent:Installer installerRef, Chronicle:Package packageRef) Global
	return log(installerRef + " has queued package " + packageRef)
EndFunction

Bool Function logNoAdd(Chronicle:EngineComponent:Installer installerRef, Chronicle:Package packageRef) Global
	return error(installerRef + " could not add package " + packageRef + " to package container")
EndFunction

Bool Function logFailure(Chronicle:EngineComponent:Installer installerRef, Chronicle:Package packageRef) Global
	return error(installerRef + " observed failed installation of package " + packageRef)
EndFunction

Bool Function logPhantomResponse(Chronicle:EngineComponent:Installer installerRef, Chronicle:Package expectedRef, Chronicle:Package actualRef) Global
	return error(installerRef + " received response from phantom package, expected" + expectedRef + " , actual: " + actualRef)
EndFunction

Bool Function logCannotInstall(Chronicle:EngineComponent:Installer installerRef, Chronicle:Package packageRef) Global
	return error(installerRef + " cannot install package " + packageRef)
EndFunction

Bool Function logQueueSize(Chronicle:EngineComponent:Installer installerRef) Global
	return log(installerRef + " has queue size " + installerRef.getQueueSize())
EndFunction

Bool Function logStatus(Chronicle:EngineComponent:Installer installerRef) Global
	return log(installerRef + " in state: " + installerRef.GetState() + ", needs processing: " + installerRef.needsProcessing() + ",  with queue size " + installerRef.GetQueueSize())
EndFunction
