Scriptname Chronicle:Engine:Component:Installer extends Chronicle:Engine:Component
{This component type is responsible for queuing and installing package objects into the engine containing it.}

String sStateCoreInstall = "CoreInstall" Const
String sStateProcessQueue = "ProcessQueue" Const

Chronicle:Package Function getTargetPackage()
{This is here because the compiler kicks up an internal error otherwise even though it's defined in the parent script.  Oh well.}
	return None
EndFunction

Function startupBehavior()
{the very first thing the installer needs to do is install the core package because its success or failure dictates not only whether or not anything else can happen at all,
but also the environment into which other packages install.  See the required core version properties on both the Chronicle:Engine and Chronicle:Package:NonCore scripts for details.}
	GoToState(sStateCoreInstall)
EndFunction

Function goToProcessingState()
	GoToState(sStateProcessQueue)
EndFunction

Function observePackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "InstallComplete")
	RegisterForCustomEvent(targetRef, "InstallFailed")
	
	Chronicle:Engine:Component:Logger.logListening(self, targetRef)
EndFunction

Function stopObservingPackageInstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "InstallComplete")
	UnregisterForCustomEvent(targetRef, "InstallFailed")
	
	Chronicle:Engine:Component:Logger.logStopListening(self, targetRef)
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
			Chronicle:Engine:Component:Logger.logPackageNotAddedToContainer(self, targetRef)
			targetRef.triggerFatalError()
			sendFatalError()
		endif
	else
		Chronicle:Engine:Component:Logger.logPhantomResponse(self, targetRef, packageRef)
		sendFatalError()
	endif
EndEvent

Event Chronicle:Package.InstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageInstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Engine:Component:Logger.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	sendFatalError()
EndEvent

Function performPackageInstallation(Chronicle:Package packageRef)
	if (packageRef.canInstall())
		observePackageInstall()
		packageRef.Start()
	else
		sendFatalError() ; this seems like a poor reaction until one considers that a package which cannot install should not have made it in to the queue
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
			Chronicle:Engine:Component:Logger.logProcessingPackage(self, targetRef)
			performPackageInstallation(targetRef)
		else
			Chronicle:Engine:Component:Logger.logNothingToProcess(self)
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
