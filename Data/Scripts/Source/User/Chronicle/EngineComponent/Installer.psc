Scriptname Chronicle:EngineComponent:Installer extends Chronicle:EngineComponent

Chronicle:Package[] PackageQueue

String sStateCoreInstall = "CoreInstall" Const
String sStateProcessQueue = "ProcessQueue" Const

Function startupBehavior()
	PackageQueue = new Chronicle:Package[0] ; because array variables initialize to None
	GoToState(sStateCoreInstall)
EndFunction

Int Function getQueueSize()
	if (None == PackageQueue)
		return 0
	endif
	
	return PackageQueue.Length
EndFunction

Bool Function isQueuePopulated()
	return 0 < getQueueSize()
EndFunction

Bool Function queuePackage(Chronicle:Package packageRef)
	if (!IsRunning()) ; because populating the queue (even after initializing it from None) and then starting the quest actually zeros out whatever is in the queue
		return false
	endif

	if (packageRef.canInstall())
		PackageQueue.Add(packageRef)
		Chronicle:Logger:Engine:Installer.logQueued(self, packageRef)
		setNeedsProcessing()
		logStatus()
		return true
	else
		Chronicle:Logger:Engine:Installer.logCannotInstall(self, packageRef)
		return false
	endif
EndFunction

Chronicle:Package Function getTargetPackage()
	return None
EndFunction

Bool Function needsProcessing()
	return parent.needsProcessing() || isQueuePopulated()
EndFunction

Function goToProcessingState()
	GoToState(sStateProcessQueue)
EndFunction

Function observePackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "InstallComplete")
	RegisterForCustomEvent(targetRef, "InstallFailed")
	
	Chronicle:Logger:Engine:Installer.logListening(self, targetRef)
EndFunction

Function stopObservingPackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "InstallComplete")
	UnregisterForCustomEvent(targetRef, "InstallFailed")
	
	Chronicle:Logger:Engine:Installer.logStopListening(self, targetRef)
EndFunction

Bool Function addPackageToContainer(Chronicle:Package packageRef)
	return false
EndFunction

Function postProcessingBehavior()
	
EndFunction

Function processNextPackage()

EndFunction

Function logStatus()
	;Chronicle:Logger:Engine:Installer.logStatus(self)
EndFunction

Event Chronicle:Package.InstallComplete(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageInstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef == packageRef)
		if (addPackageToContainer(targetRef))
			postProcessingBehavior()
		else
			Chronicle:Logger:Engine:Installer.logNoAdd(self, targetRef)
			triggerFatalError()
		endif
	else
		Chronicle:Logger:Engine:Installer.logPhantomResponse(self, targetRef, packageRef)
		triggerFatalError()
	endif
EndEvent

Event Chronicle:Package.InstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageInstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Logger:Engine:Installer.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	Chronicle:Logger:Engine:Installer.logFailure(self, targetRef)
	triggerFatalError()
EndEvent

Function performPackageInstallation(Chronicle:Package packageRef)
	if (packageRef.canInstall())
		observePackageInstall()
		packageRef.Start()
	else
		Chronicle:Logger:Engine:Installer.logCannotInstall(self, packageRef)
		triggerFatalError()
	endif
EndFunction

State CoreInstall
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
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
		logStatus()
		processNextPackage()
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		if (isQueuePopulated())
			return PackageQueue[0]
		else
			return None
		endif
	EndFunction
	
	Function processNextPackage()
		Chronicle:Package targetRef = getTargetPackage()
		if (None == targetRef)
			setToIdle()
		else
			performPackageInstallation(targetRef)
		endif
	EndFunction
	
	Bool Function addPackageToContainer(Chronicle:Package packageRef)
		return getEngine().getPackages().addPackage(packageRef)
	EndFunction
	
	Function postProcessingBehavior()
		PackageQueue.Remove(0)
		processNextPackage()
	EndFunction
EndState
