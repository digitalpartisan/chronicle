Scriptname Chronicle:EngineComponent:Installer extends Chronicle:EngineComponent

Chronicle:Package[] PackageQueue

String sStateCoreInstall = "CoreInstall" Const
String sStateProcessQueue = "ProcessQueue" Const

Function startupBehavior()
	GoToState(sStateCoreInstall)
EndFunction

Bool Function isQueuePopulated()
	return 0 < PackageQueue.Length
EndFunction

Bool Function queuePackage(Chronicle:Package packageRef)
	if (None == PackageQueue)
		PackageQueue = new Chronicle:Package[0] ; because array variables initialize to None
	endif

	;Chronicle:Logger:Engine.logPackageQueued(self, packageRef)
	if (packageRef.canInstall())
		PackageQueue.Add(packageRef)
		return true
	else
		return false
	endif
EndFunction

Chronicle:Package Function getTargetPackage()
	return None
EndFunction

Function process()
	GoToState(sStateProcessQueue)
EndFunction

Function observePackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	;Chronicle:Logger:Engine:Installer.logListeningForPackage(self, targetRef)
	RegisterForCustomEvent(targetRef, "InstallComplete")
	RegisterForCustomEvent(targetRef, "InstallFailed")
EndFunction

Function stopObservingPackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	;Chronicle:Logger:Engine.logStopListeningForPackageInstall(self, targetRef)
	UnregisterForCustomEvent(targetRef, "InstallComplete")
	UnregisterForCustomEvent(targetRef, "InstallFailed")
EndFunction

Bool Function addPackageToContainer(Chronicle:Package packageRef)
	return false
EndFunction

Function postProcessingBehavior()
	
EndFunction

Function processNextPackage()

EndFunction

Event Chronicle:Package.InstallComplete(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageInstall()
	
	Chronicle:Package expectedRef = getTargetPackage()
	if (expectedRef == packageRef)
		if (addPackageToContainer(expectedRef))
			postProcessingBehavior()
		else
			; message here
			triggerFatalError()
		endif
	else
		;Chronicle:Logger:Engine:Installer.logPhantomPackageResponse(self, expectedRef, packageRef)
		triggerFatalError()
	endif
EndEvent

Event Chronicle:Package.InstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageInstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		;Chronicle:Logger:Engine.logPhantomPackageInstallResponse(self, CorePackage, packageRef)
	endif
	
	;Chronicle:Logger:Engine.logPackageInstallFailed(self, targetRef)
	triggerFatalError()
EndEvent

Function performPackageInstallation(Chronicle:Package packageRef)
	if (packageRef.canInstall())
		observePackageInstall()
		packageRef.Start()
	else
		; todo - error log
		triggerFatalError()
	endif
EndFunction

State CoreInstall
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		Chronicle:Package targetRef = getTargetPackage()
		targetRef.GoToState("QueuedForInstallation") ; a hack, but this is what ends up needing to happen in order to match the normal package installation flow
		performPackageInstallation(targetRef)
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
		return PackageQueue[0]
	EndFunction
	
	Function processNextPackage()
		Chronicle:Package targetRef = getTargetPackage()
		if (targetRef)
			performPackageInstallation(targetRef)
		else
			setToIdle()
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
