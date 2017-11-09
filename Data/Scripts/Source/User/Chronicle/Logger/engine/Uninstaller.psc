Scriptname chronicle:logger:engine:Uninstaller Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[1]
	tags[0] = "Engine"
	tags[1] = "Uninstaller"
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

Bool Function logListening(Chronicle:EngineComponent:Uninstaller uninstallerRef, Chronicle:Package packageRef) Global
	return log(uninstallerRef + " is listening for package " + packageRef)
EndFunction

Bool Function logStopListening(Chronicle:EngineComponent:Uninstaller uninstallerRef, Chronicle:Package packageRef) Global
	return log(uninstallerRef + " is no longer listening for package " + packageRef)
EndFunction

Bool Function logQueued(Chronicle:EngineComponent:Uninstaller uninstallerRef, Chronicle:Package packageRef) Global
	return log(uninstallerRef + " has queued package " + packageRef)
EndFunction

Bool Function logNoRemove(Chronicle:EngineComponent:Uninstaller uninstallerRef, Chronicle:Package packageRef) Global
	return error(uninstallerRef + " could not remove package " + packageRef + " to package container")
EndFunction

Bool Function logFailure(Chronicle:EngineComponent:Uninstaller uninstallerRef, Chronicle:Package packageRef) Global
	return error(uninstallerRef + " observed failed uninstallation of package " + packageRef)
EndFunction

Bool Function logPhantomResponse(Chronicle:EngineComponent:Uninstaller uninstallerRef, Chronicle:Package expectedRef, Chronicle:Package actualRef) Global
	return error(uninstallerRef + " received response from phantom package, expected" + expectedRef + " , actual: " + actualRef)
EndFunction

Bool Function logCannotUninstall(Chronicle:EngineComponent:Uninstaller uninstallerRef, Chronicle:Package packageRef) Global
	return error(uninstallerRef + " cannot install package " + packageRef)
EndFunction

Bool Function logStatus(Chronicle:EngineComponent:Uninstaller uninstallerRef) Global
	return log(uninstallerRef + " in state: " + uninstallerRef.GetState() + ", needs processing: " + uninstallerRef.needsProcessing() + ",  with queue size " + uninstallerRef.GetQueueSize())
EndFunction
