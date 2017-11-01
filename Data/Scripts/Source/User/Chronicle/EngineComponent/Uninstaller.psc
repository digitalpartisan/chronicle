Scriptname Chronicle:EngineComponent:Uninstaller extends Chronicle:EngineComponent

Chronicle:Package[] PackageQueue

String sStateProcessQueue = "ProcessQueue" Const
String sStateProcessAll = "ProcessAll" Const

Bool Function isQueuePopulated()
	return 0 < PackageQueue.Length
EndFunction

Bool Function queuePackage(Chronicle:Package packageRef)
	if (None == PackageQueue)
		PackageQueue = new Chronicle:Package[0] ; because array variables initialize to None
	endif

	;Chronicle:Logger:Engine.logPackageQueued(self, packageRef)
	if (packageRef.canUninstall())
		PackageQueue.Add(packageRef)
		return true
	else
		return false
	endif
EndFunction

Chronicle:Package Function getTargetPackage()
	return None
EndFunction

Function process(Bool bAll = false)
	if (bAll)
		GoToState(sStateProcessAll)
	else
		GoToState(sStateProcessQueue)
	endif
EndFunction

Function observePackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	;Chronicle:Logger:Engine:Installer.logListeningForPackage(self, targetRef)
	RegisterForCustomEvent(targetRef, "UninstallComplete")
	RegisterForCustomEvent(targetRef, "UninstallFailed")
EndFunction

Function stopObservingPackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	;Chronicle:Logger:Engine.logStopListeningForPackageInstall(self, targetRef)
	UnregisterForCustomEvent(targetRef, "UninstallComplete")
	UnregisterForCustomEvent(targetRef, "UninstallFailed")
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
	
	Chronicle:Package expectedRef = getTargetPackage()
	if (expectedRef == packageRef)
		if (removePackageFromContainer(expectedRef))
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

Event Chronicle:Package.UninstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUninstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		;Chronicle:Logger:Engine.logPhantomPackageInstallResponse(self, CorePackage, packageRef)
	endif
	
	;Chronicle:Logger:Engine.logPackageInstallFailed(self, targetRef)
	triggerFatalError()
EndEvent

Function performPackageUninstallation(Chronicle:Package packageRef)
	if (packageRef.canUninstall())
		observePackageUninstall()
		packageRef.Stop()
	else
		; todo - error log
		triggerFatalError()
	endif
EndFunction

State FullUninstall
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
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
		processNextPackage()
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return PackageQueue[0]
	EndFunction
	
	Bool Function removePackageFromContainer(Chronicle:Package packageRef)
		return getEngine().getPackages().removePackage(packageRef)
	EndFunction
	
	Function postProcessingBehavior()
		PackageQueue.Remove(0)
		processNextPackage()
	EndFunction
EndState
