Scriptname Chronicle:Engine:Component:Uninstaller extends Chronicle:Engine:Component
{This is the package uninstaller.  Note the lack of a core-specific state.  Either a queue is being processed, or every single installed package is being uninstalled in opposite order of installation.
A core package cannot be uninstalled except in the case of a full engine uninstallation.}

String sStateProcessAll = "ProcessAll" Const
String sStateProcessQueue = "ProcessQueue" Const

Chronicle:Package Function getTargetPackage()
{This is here because the compiler kicks up an internal error otherwise.}
	return None
EndFunction

Function goToProcessingState()
	if (isQueuePopulated())
		GoToState(sStateProcessQueue)
	else
		GoToState(sStateProcessAll)
	endif
EndFunction

Bool Function canActOnPackage(Chronicle:Package targetPackage)
	Chronicle:Engine engineRef = getEngine()
	; the ProcessAll state doesn't care about these conditions like the queuing logic does.  The Core package cannot be queued and neither can a package in the All-in-One release if the engine is in All-in-One mode.
	return targetPackage.canUninstall() && !engineRef.isCorePackage(targetPackage) && ( !engineRef.isAIOModeActive() || !targetPackage.IsInAIO() )
EndFunction

Function observePackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "UninstallComplete")
	RegisterForCustomEvent(targetRef, "UninstallFailed")
	
	Chronicle:Engine:Component:Logger.logListening(self, targetRef)
EndFunction

Function stopObservingPackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "UninstallComplete")
	UnregisterForCustomEvent(targetRef, "UninstallFailed")
	
	Chronicle:Engine:Component:Logger.logStopListening(self, targetRef)
EndFunction

Bool Function removePackageFromContainer(Chronicle:Package packageRef)
	return false
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
			Chronicle:Engine:Component:Logger.logPackageNotRemovedFromContainer(self, targetRef)
			sendFatalError()
		endif
	else
		Chronicle:Engine:Component:Logger.logPhantomResponse(self, targetRef, packageRef)
		sendFatalError()
	endif
EndEvent

Event Chronicle:Package.UninstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUninstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Engine:Component:Logger.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	Chronicle:Engine:Component:Logger.logPackageFailure(self, targetRef)
	sendFatalError()
EndEvent

Function performPackageUninstallation(Chronicle:Package packageRef)
	if (packageRef.canUninstall())
		observePackageUninstall()
		packageRef.uninstall()
	else
		sendFatalError()
	endif
EndFunction

State ProcessAll
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		getEngine().getPackages().fastForward() ; start at the end of the package list since this is an "undo" process
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
		if (isQueuePopulated())
			return getQueueItem(0)
		else
			return None
		endif
	EndFunction
	
	Bool Function removePackageFromContainer(Chronicle:Package packageRef)
		return getEngine().getPackages().removePackage(packageRef)
	EndFunction
	
	Function postProcessingBehavior()
		getPackageQueue().Remove(0)
		processNextPackage()
	EndFunction
EndState
