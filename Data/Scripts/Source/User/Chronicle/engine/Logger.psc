Scriptname Chronicle:Engine:Logger Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[0]
	tags.Add("Engine")
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

Bool Function interceptedGameLoad(Chronicle:Engine engineRef) Global
	return log(engineRef + " received game load event")
EndFunction

Bool Function logComponentsNotDormant(Chronicle:Engine engineRef) Global
	return error(engineRef + " was started with components which are not dormant")
EndFunction

Bool Function logObservingComponent(Chronicle:Engine engineRef, Chronicle:Engine:Component componentRef) Global
	return log(engineRef + " is observing engine component " + componentRef)
EndFunction

Bool Function logStopObservingComponent(Chronicle:Engine engineRef, Chronicle:Engine:Component componentRef) Global
	return log(engineRef + " has stopped observing engine component " + componentRef)
EndFunction

Bool Function logInstallerIdled(Chronicle:Engine engineRef) Global
	return log(engineRef + " recieved idle event from installer component")
EndFunction

Bool Function logIdledInstaller(Chronicle:Engine engineRef) Global
	return log(engineRef + " received idle event from installer component")
EndFunction

Bool Function logIdledUpdater(Chronicle:Engine engineRef) Global
	return log(engineRef + " received idle event from updater component")
EndFunction

Bool Function logIdledUninstaller(Chronicle:Engine engineRef) Global
	return log(engineRef + " received idle event from uninstaller component")
EndFunction

Bool Function logIdledPostload(Chronicle:Engine engineRef) Global
	return log(engineRef + " received idle event from postload component")
EndFunction

Bool Function logPhantomComponentIdled(Chronicle:Engine engineRef, Chronicle:Engine:Component componentRef) Global
	return error(engineRef + " received idle event from phantom component " + componentRef)
EndFunction

Bool Function logComponentFatalError(Chronicle:Engine engineRef, Chronicle:Engine:Component componentRef) Global
	return error(engineRef + " received fatal error event from component " + componentRef)
EndFunction

Bool Function logPhantomComponentFatalError(Chronicle:Engine engineRef, Chronicle:Engine:Component componentRef) Global
	return error(engineRef + " received fatal error event from phantom component " + componentRef)
EndFunction

Bool Function logProcessComponent(Chronicle:Engine:Component componentRef) Global
	return log(componentRef.getEngine() + " is processing component " + componentRef)
EndFunction

Bool Function logPackageTooOld(Chronicle:Engine engineRef, Chronicle:Package packageRef) Global
	return log(engineRef + " has determined " + packageRef + " is too old")
EndFunction

Bool Function logPackageToonew(Chronicle:Engine engineRef, Chronicle:Package packageRef) Global
	return log(engineRef + " has determined " + packageRef + " is too new")
EndFunction

Bool Function logMissingPackageRemoved(Chronicle:Engine engineRef, Chronicle:Package packageRef) Global
	return log(engineRef + " has removed missing package " + packageRef)
EndFunction

Bool Function detectedMissingPackages(Chronicle:Engine engineRef) Global
	return log(engineRef + " has detected missing packages")
EndFunction

Bool Function handlerReceivedEngine(Chronicle:Engine:Handler handlerRef, Chronicle:Engine engineRef) Global
	return log(handlerRef + " received engine: " + engineRef)
EndFunction

Bool Function handlerStatus(Chronicle:Engine:Handler handlerRef) Global
	return log(handlerRef + " status: is valid: " + handlerRef.isValid() + " can install: " + handlerRef.canInstall() + " can uninstall: " + handlerRef.canUninstall())
EndFunction
