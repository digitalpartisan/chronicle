Scriptname Chronicle:Logger:Engine:Component Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[2]
	tags[0] = "Engine"
	tags[1] = "Component"
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

Bool Function logStatus(Chronicle:Engine:Component componentRef) Global
	return log(componentRef + " in state: " + componentRef.GetState() + ", needs processing: " + componentRef.needsProcessing() + ",  with queue size " + componentRef.GetQueueSize())
EndFunction

Bool Function logListening(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return log(componentRef + " is listening for package " + packageRef)
EndFunction

Bool Function logStopListening(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return log(componentRef + " is no longer listening for package " + packageRef)
EndFunction

Bool Function logPackageFailure(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return error(componentRef + " observed fatal error from package " + packageRef)
EndFunction

Bool Function logPhantomResponse(Chronicle:Engine:Component componentRef, Chronicle:Package expectedRef, Chronicle:Package actualRef) Global
	return error(componentRef + " received response from phantom package, expected" + expectedRef + " , actual: " + actualRef)
EndFunction

Bool Function logQueued(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return log(componentRef + " has queued package " + packageRef)
EndFunction

Bool Function logCannotQueue(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return log(componentRef + " could not queue package " + packageRef)
EndFunction
