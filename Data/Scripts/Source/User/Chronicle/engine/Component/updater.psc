Scriptname Chronicle:Engine:Component:Updater extends Chronicle:Engine:Component

String sStateCoreUpdate = "CoreUpdate" Const
String sStatePackageUpdates = "PackageUpdates" Const

Chronicle:Package Function getTargetPackage()
{This is here because the compiler kicks up an internal error otherwise.}
	return None
EndFunction

Function observePackageUpdate()
	Chronicle:Package targetRef = getTargetPackage()
	
	RegisterForCustomEvent(targetRef, "UpdateComplete")
	RegisterForCustomEvent(targetRef, "UpdateFailed")
	
	Chronicle:Logger:Engine:Component.logListening(self, targetRef)
EndFunction

Function stopObservingPackageUpdate()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "UpdateComplete")
	UnregisterForCustomEvent(targetRef, "UpdateFailed")
	
	Chronicle:Logger:Engine:Component.logStopListening(self, targetRef)
EndFunction

Function goToProcessingState()
	GoToState(sStateCoreUpdate)
EndFunction

Bool Function canActOnPackage(Chronicle:Package targetPackage)
	return targetPackage.canUpdate()
EndFunction

Event Chronicle:Package.UpdateComplete(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUpdate()
	
	Chronicle:Package targetRef = getTargetPackage()	
	if (targetRef == packageRef)
		postProcessingBehavior()
	else
		Chronicle:Logger:Engine:Component.logPhantomResponse(self, targetRef, packageRef)
		sendFatalError()
	endif
EndEvent

Event Chronicle:Package.UpdateFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUpdate()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Logger:Engine:Component.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	sendFatalError()
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

		getEngine().getPackages().rewind(true) ; set the pointer to the first package after the core package (since it's been taken care of)
		processNextPackage()
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return getEngine().getPackages().current()
	EndFunction
	
	Function processNextPackage()
		Chronicle:Package targetRef = getTargetPackage()
		Chronicle:Engine engineRef = getEngine()
		
		if (!targetRef)
			setToIdle()
		elseif (engineRef.isPackageCompatible(targetRef) && canActOnPackage(targetRef))
			observePackageUpdate()
			targetRef.update()
		else
			engineRef.getPackages().next()
			processNextPackage()
		endif
	EndFunction
	
	Function postProcessingBehavior()
		getEngine().getPackages().next()
		processNextPackage()
	EndFunction
EndState
