Scriptname Chronicle:EngineComponent:Uninstaller extends Chronicle:EngineComponent

Chronicle:Package[] PackageQueue

String sStateProcessAll = "ProcessAll" Const
String sStateProcessQueue = "ProcessQueue" Const

Function startupBehavior()
	PackageQueue = new Chronicle:Package[0] ; because array variables initialize to None
	parent.startupBehavior()
EndFunction

Bool Function getQueueSize()
	if (None == PackageQueue)
		return 0
	else
		return PackageQueue.Length
	endif
EndFunction

Bool Function isQueuePopulated()
	return 0 < getQueueSize()
EndFunction

Bool Function queuePackage(Chronicle:Package packageRef)
	if (!IsRunning()) ; see note in Chronicle:EngineComponent:Installer.queuePackage()
		return false
	endif

	if (packageRef.canUninstall())
		PackageQueue.Add(packageRef)
		Chronicle:Logger:Engine:Uninstaller.logQueued(self, packageRef)
		setNeedsProcessing()
		logStatus()
		return true
	else
		Chronicle:Logger:Engine:Uninstaller.logCannotUninstall(self, packageRef)
		return false
	endif
EndFunction

Chronicle:Package Function getTargetPackage()
	return None
EndFunction

Function goToProcessingState()
	if (isQueuePopulated())
		GoToState(sStateProcessQueue)
	else
		GoToState(sStateProcessAll)
	endif
EndFunction

Bool Function needsProcessing()
	return parent.needsProcessing() || isQueuePopulated()
EndFunction

Function observePackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "UninstallComplete")
	RegisterForCustomEvent(targetRef, "UninstallFailed")
	
	Chronicle:Logger:Engine:Uninstaller.logListening(self, targetRef)
EndFunction

Function stopObservingPackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "UninstallComplete")
	UnregisterForCustomEvent(targetRef, "UninstallFailed")
	
	Chronicle:Logger:Engine:Uninstaller.logStopListening(self, targetRef)
EndFunction

Bool Function removePackageFromContainer(Chronicle:Package packageRef)
	return false
EndFunction

Function postProcessingBehavior()
	
EndFunction

Function processNextPackage()
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef)
		performPackageUninstallation(targetRef)
	else
		setToIdle()
	endif
EndFunction

Event Chronicle:Package.UninstallComplete(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUninstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef == packageRef)
		if (removePackageFromContainer(targetRef))
			postProcessingBehavior()
		else
			Chronicle:Logger:Engine:Uninstaller.logNoRemove(self, targetRef)
			triggerFatalError()
		endif
	else
		Chronicle:Logger:Engine:Uninstaller.logPhantomResponse(self, targetRef, packageRef)
		triggerFatalError()
	endif
EndEvent

Event Chronicle:Package.UninstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUninstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Logger:Engine:Uninstaller.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	Chronicle:Logger:Engine:Uninstaller.logFailure(self, targetRef)
	triggerFatalError()
EndEvent

Function performPackageUninstallation(Chronicle:Package packageRef)
	if (packageRef.canUninstall())
		observePackageUninstall()
		packageRef.Stop()
	else
		Chronicle:Logger:Engine:Uninstaller.logCannotUninstall(self, packageRef)
		triggerFatalError()
	endif
EndFunction

Function logStatus()
	Chronicle:Logger:Engine:Uninstaller.logStatus(self)
EndFunction

State ProcessAll
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
		getEngine().getPackages().fastForward()
		processNextPackage()
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return getEngine().getPackages().current()
	EndFunction

	Bool Function removePackageFromContainer(Chronicle:Package packageRef)
		return getEngine().getPackages().removeCurrent()
	EndFunction	
	
	Function postProcessingBehavior()
		processNextPackage()
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
	
	Bool Function removePackageFromContainer(Chronicle:Package packageRef)
		return getEngine().getPackages().removePackage(packageRef)
	EndFunction
	
	Function postProcessingBehavior()
		PackageQueue.Remove(0)
		processNextPackage()
	EndFunction
EndState
