Scriptname chronicle:logger:engine:updater Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[1]
	tags[0] = "Engine"
	tags[1] = "Updater"
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

Bool Function logListening(Chronicle:EngineComponent:Updater updaterRef, Chronicle:Package packageRef) Global
	return log(updaterRef + " is listening for package " + packageRef)
EndFunction

Bool Function logStopListening(Chronicle:EngineComponent:Updater updaterRef, Chronicle:Package packageRef) Global
	return log(updaterRef + " is no longer listening for package " + packageRef)
EndFunction

Bool Function logFailure(Chronicle:EngineComponent:Updater updaterRef, Chronicle:Package packageRef) Global
	return error(updaterRef + " observed failed update of package " + packageRef)
EndFunction

Bool Function logPhantomResponse(Chronicle:EngineComponent:Updater updaterRef, Chronicle:Package expectedRef, Chronicle:Package actualRef) Global
	return error(updaterRef + " received response from phantom package, expected" + expectedRef + " , actual: " + actualRef)
EndFunction

Bool Function logStatus(Chronicle:EngineComponent:Updater updaterRef) Global
	return log(updaterRef + " in state: " + updaterRef.GetState() + ", needs processing: " + updaterRef.needsProcessing())
EndFunction
