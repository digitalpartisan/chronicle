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

Chronicle:Package Function getPackage()
	return MyPackage
EndFunction

Bool Function comparePackage(Chronicle:Package targetPackage)
	return targetPackage && getPackage() == targetPackage
EndFunction

Function observePackage(Bool bObserve = true)
	Chronicle:Package targetPackage = getPackage()
	if (bObserve)
		RegisterForCustomEvent(targetPackage, "InstallComplete")
		RegisterForCustomEvent(targetPackage, "InstallFailed")
		RegisterForCustomEvent(targetPackage, "UpdateComplete")
		RegisterForCustomEvent(targetPackage, "UpdateFailed")
		RegisterForCustomEvent(targetPackage, "UninstallComplete")
		RegisterForCustomEvent(targetPackage, "UninstallFailed")
	else
		UnregisterForCustomEvent(targetPackage, "InstallComplete")
		UnregisterForCustomEvent(targetPackage, "InstallFailed")
		UnregisterForCustomEvent(targetPackage, "UpdateComplete")
		UnregisterForCustomEvent(targetPackage, "UpdateFailed")
		UnregisterForCustomEvent(targetPackage, "UninstallComplete")
		UnregisterForCustomEvent(targetPackage, "UninstallFailed")
	endif
EndFunction

Function installCompleteBehavior(Var[] args)
	goToReady()
EndFunction

Event Chronicle:Package.InstallComplete(Chronicle:Package packageRef, Var[] args)
	comparePackage(packageRef) && installCompleteBehavior(args)
EndEvent

Function installFailedBehavior(Var[] args)
	goToDeleted()
EndFunction

Event Chronicle:Package.InstallFailed(Chronicle:Package packageRef, Var[] args)
	comparePackage(packageRef) && installFailedBehavior(args)
EndEvent

Function updateCompleteBehavior(Var[] args)
	
EndFunction

Event Chronicle:Package.UpdateComplete(Chronicle:Package packageRef, Var[] args)
	comparePackage(packageRef) && updateCompleteBehavior(args)
EndEvent

Function updateFailedBehavior(Var[] args)
	
EndFunction

Event Chronicle:Package.UpdateFailed(Chronicle:Package packageRef, Var[] args)
	comparePackage(packageRef) && updateFailedBehavior(args)
EndEvent

Function uninstallCompleteBehavior(Var[] args)
	goToDeleted()
EndFunction

Event Chronicle:Package.UninstallComplete(Chronicle:Package packageRef, Var[] args)
	comparePackage(packageRef) && uninstallCompleteBehavior(args)
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
	Chronicle:Package targetPackage = getPackage()
	if (targetPackage && (targetPackage.IsStarting() || targetPackage.IsRunning()))
		goToReady()
	else
		goToBlocked()
	endif
EndFunction

Event OnInit()
	observePackage()
	determineState()
EndEvent

Event OnLoad()
	observePackage()
	determineState()
EndEvent

Function Enable(Bool abFadeIn = false)
	parent.Enable(abFadeIn)
	determineState()
EndFunction

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
		BlockActivation(false, false)
		!IsEnabled() && Enable() ; useful for non-workshop placed objects that start disabled so that they're not visible unless their package is running
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
