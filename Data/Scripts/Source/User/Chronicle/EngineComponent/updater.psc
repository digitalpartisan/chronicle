Scriptname Chronicle:EngineComponent:Updater extends Chronicle:EngineComponent

String sStateCoreUpdate = "CoreUpdate" Const
String sStatePackageUpdates = "PackageUpdates" Const

Chronicle:Package Function getTargetPackage()
	return None
EndFunction

Function observePackageUpdate()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "UpdateComplete")
	RegisterForCustomEvent(targetRef, "UpdateFailed")
	
	Chronicle:Logger:Engine:Updater.logListening(self, targetRef)
EndFunction

Function stopObservingPackageUpdate()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "UpdateComplete")
	UnregisterForCustomEvent(targetRef, "UpdateFailed")
	
	Chronicle:Logger:Engine:Updater.logStopListening(self, targetRef)
EndFunction

Function postProcessingBehavior()
	
EndFunction

Function processNextPackage()
	
EndFunction

Function goToProcessingState()
	GoToState(sStateCoreUpdate)
EndFunction

Event Chronicle:Package.UpdateComplete(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUpdate()
	
	Chronicle:Package targetRef = getTargetPackage()	
	if (targetRef == packageRef)
		postProcessingBehavior()
	else
		Chronicle:Logger:Engine:Updater.logPhantomResponse(self, targetRef, packageRef)
		triggerFatalError()
	endif
EndEvent

Event Chronicle:Package.UpdateFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUpdate()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Logger:Engine:Updater.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	Chronicle:Logger:Engine:Updater.logFailure(self, targetRef)
	triggerFatalError()
EndEvent

Function logStatus()
	;Chronicle:Logger:Engine:Updater.logStatus(self)
EndFunction

State CoreUpdate
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
		
		Chronicle:Package targetRef = getTargetPackage()
		if (targetRef.canUpdate())
			observePackageUpdate()
			targetRef.update()
		else
			GoToState(sStatePackageUpdates)
		endif
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return getEngine().getPackages().getCorePackage()
	EndFunction
	
	Function postProcessingBehavior()
		GoToState(sStatePackageUpdates)
	EndFunction
EndState

State PackageUpdates
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
		getEngine().getPackages().rewind(true)
		processNextPackage()
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return getEngine().getPackages().current()
	EndFunction
	
	Function processNextPackage()
		Chronicle:Package targetRef = getTargetPackage()
		
		if (!targetRef)
			setToIdle()
		elseif (targetRef.canUpdate())
			observePackageUpdate()
			targetRef.update()
		else
			getEngine().getPackages().next()
			processNextPackage()
		endif
	EndFunction
	
	Function postProcessingBehavior()
		getEngine().getPackages().next()
		processNextPackage()
	EndFunction
EndState
