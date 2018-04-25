Scriptname Chronicle:Engine:Component:Installer extends Chronicle:Engine:Component
{When attaching this script to a quest record, do not check the "Start Game Enabled" box.}

String sStateCoreInstall = "CoreInstall" Const
String sStateProcessQueue = "ProcessQueue" Const

Chronicle:Package Function getTargetPackage()
{This is here because the compiler kicks up an internal error otherwise even though it's defined in the parent script.  Oh well.}
	return None
EndFunction

Function startupBehavior()
	GoToState(sStateCoreInstall)
EndFunction

Function goToProcessingState()
	GoToState(sStateProcessQueue)
EndFunction

Function observePackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "InstallComplete")
	RegisterForCustomEvent(targetRef, "InstallFailed")
	
	Chronicle:Logger:Engine:Component.logListening(self, targetRef)
EndFunction

Function stopObservingPackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "InstallComplete")
	UnregisterForCustomEvent(targetRef, "InstallFailed")
	
	Chronicle:Logger:Engine:Component.logStopListening(self, targetRef)
EndFunction

Bool Function canActOnPackage(Chronicle:Package targetPackage)
	return targetPackage.canInstall() && getEngine().isPackageCompatible(targetPackage)
EndFunction

Bool Function addPackageToContainer(Chronicle:Package packageRef)
	return false
EndFunction

Event Chronicle:Package.InstallComplete(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageInstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef == packageRef)
		if (addPackageToContainer(targetRef))
			postProcessingBehavior()
		else
			Chronicle:Logger:Engine:Component.logPackageNotAddedToContainer(self, targetRef)
			sendFatalError()
		endif
	else
		Chronicle:Logger:Engine:Component.logPhantomResponse(self, targetRef, packageRef)
		sendFatalError()
	endif
EndEvent

Event Chronicle:Package.InstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageInstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Logger:Engine:Component.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	sendFatalError()
EndEvent

Function performPackageInstallation(Chronicle:Package packageRef)
	if (packageRef.canInstall())
		observePackageInstall()
		packageRef.Start()
	else
		sendFatalError()
	endif
EndFunction

State CoreInstall
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		performPackageInstallation(getTargetPackage())
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return getEngine().getCorePackage()
	EndFunction

	Bool Function addPackageToContainer(Chronicle:Package packageRef)
		return getEngine().getPackages().setCorePackage(packageRef)
	EndFunction	
	
	Function postProcessingBehavior()
		GoToState(sStateProcessQueue)
	EndFunction
EndState

State ProcessQueue
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		processNextPackage()
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return getQueueItem(0)
	EndFunction
	
	Function processNextPackage()
		Chronicle:Package targetRef = getTargetPackage()
		
		if (targetRef)
			Chronicle:Logger:Engine:Component.logProcessingPackage(self, targetRef)
			performPackageInstallation(targetRef)
		else
			Chronicle:Logger:Engine:Component.logNothingToProcess(self)
			setNeedsProcessing(false)
			setToIdle()
		endif
	EndFunction
	
	Bool Function addPackageToContainer(Chronicle:Package packageRef)
		return getEngine().getPackages().addPackage(packageRef)
	EndFunction
	
	Function postProcessingBehavior()
		getPackageQueue().Remove(0)
		processNextPackage()
	EndFunction
EndState
