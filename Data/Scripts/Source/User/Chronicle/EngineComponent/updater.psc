Scriptname Chronicle:EngineComponent:updater extends Chronicle:EngineComponent

String sStateCoreUpdate = "CoreUpdate" Const
String sStatePackageUpdates = "PackageUpdates" Const

Chronicle:Package Function getTargetPackage()
	return None
EndFunction

Function observePackageUpdate()
	Chronicle:Package targetRef = getTargetPackage()
	; - todo message
	RegisterForCustomEvent(targetRef, "UpdateComplete")
	RegisterForCustomEvent(targetRef, "UpdateFailed")
EndFunction

Function stopObservingPackageUpdate()
	Chronicle:Package targetRef = getTargetPackage()
	; - message here
	UnregisterForCustomEvent(targetRef, "UpdateComplete")
	UnregisterForCustomEvent(targetRef, "UpdateFailed")
EndFunction

Function postProcessingBehavior()
	
EndFunction

Function processNextPackage()
	
EndFunction

Function process()
	GoToState(sStateCoreUpdate)
EndFunction

Event Chronicle:Package.UpdateComplete(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUpdate()
	
	Chronicle:Package targetRef = getTargetPackage()	
	if (targetRef == packageRef)
		; - message here
		postProcessingBehavior()
	else
		; TODO error message about wrong object updating
		triggerFatalError()
	endif
EndEvent

Event Chronicle:Package.UpdateFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUpdate()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		; TODO error message about wrong object updating
	endif
	
	triggerFatalError()
EndEvent

State CoreUpdate
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		
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
