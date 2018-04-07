Scriptname Chronicle:Engine:Component:Uninstaller extends Chronicle:Engine:Component

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
	return targetPackage.canUninstall()
EndFunction

Function observePackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "UninstallComplete")
	RegisterForCustomEvent(targetRef, "UninstallFailed")
	
	Chronicle:Logger:Engine:Component.logListening(self, targetRef)
EndFunction

Function stopObservingPackageUninstall()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "UninstallComplete")
	UnregisterForCustomEvent(targetRef, "UninstallFailed")
	
	Chronicle:Logger:Engine:Component.logStopListening(self, targetRef)
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
			;Chronicle:Logger:Engine:Component.logNoRemove(self, targetRef)
			sendFatalError()
		endif
	else
		Chronicle:Logger:Engine:Component.logPhantomResponse(self, targetRef, packageRef)
		sendFatalError()
	endif
EndEvent

Event Chronicle:Package.UninstallFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUninstall()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Logger:Engine:Component.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	;Chronicle:Logger:Engine:Component.logFailure(self, targetRef)
	sendFatalError()
EndEvent

Function performPackageUninstallation(Chronicle:Package packageRef)
	if (packageRef.canUninstall())
		observePackageUninstall()
		packageRef.Stop()
	else
		;;Chronicle:Logger:Engine:Component.logCannotUninstall(self, packageRef)
		sendFatalError()
	endif
EndFunction

State ProcessAll
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
		getEngine().getPackages().fastForward() ; start at the end of the package list
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
			return getPackageQueue()[0]
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
