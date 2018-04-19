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

Bool Function logNeedsProcessing(Chronicle:Engine:Component componentRef, Bool bInput) Global
	return log(componentRef + " needs processing: " + componentRef.needsProcessing() + " with boolean input: " + bInput + " and queue size: " + componentRef.getQueueSize())
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

Bool Function logPhantomResponse(Chronicle:Engine:Component componentRef, Chronicle:Package expectedRef, Quest actualRef) Global
	return error(componentRef + " received response from phantom package, expected" + expectedRef + " , actual: " + actualRef)
EndFunction

Bool Function logQueued(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return log(componentRef + " has queued package " + packageRef)
EndFunction

Bool Function logCannotQueue(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return log(componentRef + " could not queue package " + packageRef)
EndFunction

Bool Function logNothingToProcess(Chronicle:Engine:Component componentRef) Global
	return log(componentRef + " has no further items in the queue")
EndFunction

Bool Function logProcessingPackage(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return log(componentRef + " is processing package " + packageRef)
EndFunction

Bool Function logPackageNotAddedToContainer(Chronicle:Engine:Component componentRef, Chronicle:Package packageRef) Global
	return error(componentRef + " could not add package " + packageRef + " to container")
EndFunction
