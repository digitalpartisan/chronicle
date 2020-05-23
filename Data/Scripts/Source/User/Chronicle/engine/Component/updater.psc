Scriptname Chronicle:Engine:Component:Updater extends Chronicle:Engine:Component
{The Updater does not process a queue so much as it inspects existing packages for unprocessed version increases as well as performing ongoing compatability checks.
The updater also performs integrity checks on the packages in the package container before attempting to update any of them.  The the state IntegrityCheck for details.}

String sStateIntegrityCheck = "IntegrityCheck" Const
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
	
	Chronicle:Engine:Component:Logger.logListening(self, targetRef)
EndFunction

Function stopObservingPackageUpdate()
	Chronicle:Package targetRef = getTargetPackage()
	
	UnregisterForCustomEvent(targetRef, "UpdateComplete")
	UnregisterForCustomEvent(targetRef, "UpdateFailed")
	
	Chronicle:Engine:Component:Logger.logStopListening(self, targetRef)
EndFunction

Function goToProcessingState()
{This particular component type first checks the integrity of packages already installed to make sure that packages which have mysteriously gone missing
due to things like plugins being wrongly removed from the load order are not acted on by the updater or any other component.  That would be double plus ungood.}
	GoToState(sStateIntegrityCheck)
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
		Chronicle:Engine:Component:Logger.logPhantomResponse(self, targetRef, packageRef)
		sendFatalError()
	endif
EndEvent

Event Chronicle:Package.UpdateFailed(Chronicle:Package packageRef, Var[] args)
	stopObservingPackageUpdate()
	
	Chronicle:Package targetRef = getTargetPackage()
	if (targetRef != packageRef)
		Chronicle:Engine:Component:Logger.logPhantomResponse(self, targetRef, packageRef)
	endif
	
	sendFatalError()
EndEvent

; this exists here because it manipulates the contents of the engine's package container, so it must occur in a mutexed component (as it is not thread safe)
; and the updater is the most likely component to run immediately after a save is loaded since the odds of another component running at the time of a game save is near zero.
State IntegrityCheck
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		
		Chronicle:Engine engineRef = getEngine()
		Chronicle:Package:Container packages = engineRef.GetPackages()
		
		if (packages.maintainIntegrity())
			Chronicle:Engine:Logger.detectedMissingPackages(engineRef)
			engineRef.MissingPackagesMessage.Show()
		endif
		
		GoToState(sStateCoreUpdate)
	EndEvent
EndState

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

		getEngine().getPackages().rewind(true) ; set the pointer to the first package after the core package (since it's been taken care of already)
		processNextPackage()
	EndEvent
	
	Chronicle:Package Function getTargetPackage()
		return getEngine().getPackages().current()
	EndFunction
	
	Function processNextPackage()
		Chronicle:Package targetRef = getTargetPackage()
		Chronicle:Engine engineRef = getEngine()
		
		if (!targetRef) ; because this is a recursive process (see the final else case below,) it needs a way to stop itself.  Running out of packages is that way.
			setToIdle()
		elseif (engineRef.isPackageCompatible(targetRef) && canActOnPackage(targetRef)) ; this check runs the compatability logic even if no update is detected because of the order of the boolean conditions
			observePackageUpdate()
			targetRef.update()
		else ; either the updater can't run on the current package or no update is required, so move on
			engineRef.getPackages().next()
			processNextPackage()
		endif
	EndFunction
	
	Function postProcessingBehavior()
		getEngine().getPackages().next()
		processNextPackage()
	EndFunction
EndState
