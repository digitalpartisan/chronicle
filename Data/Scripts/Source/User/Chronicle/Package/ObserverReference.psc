Scriptname Chronicle:Package:ObserverReference extends ObjectReference

Chronicle:Package Property MyPackage Auto Const Mandatory

String sStateBlocked = "Blocked" Const
String sStateReady = "Ready" Const
String sStateDeleted = "Deleted" Const

Function goToBlocked()
	GoToState(sStateBlocked)
EndFunction

Function goToReady()
	GoToState(sStateReady)
EndFunction

Function goToDeleted()
	GoToState(sStateDeleted)
EndFunction

Function observePackage(Bool bObserve = true)
	if (bObserve)
		RegisterForCustomEvent(MyPackage, "InstallComplete")
		RegisterForCustomEvent(MyPackage, "InstallFailed")
		RegisterForCustomEvent(MyPackage, "UpdateComplete")
		RegisterForCustomEvent(MyPackage, "UpdateFailed")
		RegisterForCustomEvent(MyPackage, "UninstallComplete")
		RegisterForCustomEvent(MyPackage, "UninstallFailed")
	else
		UnregisterForCustomEvent(MyPackage, "InstallComplete")
		UnregisterForCustomEvent(MyPackage, "InstallFailed")
		UnregisterForCustomEvent(MyPackage, "UpdateComplete")
		UnregisterForCustomEvent(MyPackage, "UpdateFailed")
		UnregisterForCustomEvent(MyPackage, "UninstallComplete")
		UnregisterForCustomEvent(MyPackage, "UninstallFailed")
	endif
EndFunction

Function installCompleteBehavior(Var[] args)
	goToReady()
EndFunction

Event Chronicle:Package.InstallComplete(Chronicle:Package packageRef, Var[] args)
	if (MyPackage == packageRef)
		installCompleteBehavior(args)
	endif
EndEvent

Function installFailedBehavior(Var[] args)
	goToDeleted()
EndFunction

Event Chronicle:Package.InstallFailed(Chronicle:Package packageRef, Var[] args)
	if (MyPackage == packageRef)
		installFailedBehavior(args)
	endif
EndEvent

Function updateCompleteBehavior(Var[] args)
	
EndFunction

Event Chronicle:Package.UpdateComplete(Chronicle:Package packageRef, Var[] args)
	if (MyPackage == packageRef)
		updateCompleteBehavior(args)
	endif
EndEvent

Function updateFailedBehavior(Var[] args)
	
EndFunction

Event Chronicle:Package.UpdateFailed(Chronicle:Package packageRef, Var[] args)
	if (MyPackage == packageRef)
		updateFailedBehavior(args)
	endif
EndEvent

Function uninstallCompleteBehavior(Var[] args)
	goToDeleted()
EndFunction

Event Chronicle:Package.UninstallComplete(Chronicle:Package packageRef, Var[] args)
	if (MyPackage == packageRef)
		uninstallCompleteBehavior(args)
	endif
EndEvent

Function uninstallFailedBehavior(Var[] args)
	goToDeleted()
EndFunction

Event Chronicle:Package.UninstallFailed(Chronicle:Package packageRef, Var[] args)
	uninstallFailedBehavior(args)
EndEvent

Function activationBehavior(ObjectReference akActionRef)
	
EndFunction

Function deletionBehavior()
	
EndFunction

Function determineState()
	if (MyPackage.IsStarting() || MyPackage.IsRunning())
		goToReady()
	else
		goToBlocked()
	endif
EndFunction

Event OnLoad()
	observePackage()
	determineState()
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akReference)
	GoToState(sStateDeleted)
	observePackage(false)
EndEvent

Auto State Init
	Event OnBeginState(String asOldState)
		observePackage()
		determineState()
	EndEvent
EndState

State Blocked
	Event OnBeginState(String asOldState)
		BlockActivation(true, true)
		Disable()
	EndEvent
EndState

State Ready
	Event OnBeginState(String asOldState)
		BlockActivation(false)
		Enable() ; useful for non-workshop placed objects that start disabled so that they're not visible unless their package is running
	EndEvent
	
	Event OnActivate(ObjectReference akActionRef)
		activationBehavior(akActionRef)
	EndEvent
EndState

State Deleted
	Event OnBeginState(String asOldState)
		observePackage(false)
		deletionBehavior()
		Disable()
		Delete()
	EndEvent
EndState
