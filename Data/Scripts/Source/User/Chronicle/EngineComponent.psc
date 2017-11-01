Scriptname Chronicle:EngineComponent extends Quest

CustomEvent Idled
CustomEvent FatalError

Chronicle:Engine Property MyEngine Auto Const Mandatory

String sStateDormant = "Dormant" Const
String sStateIdle = "Idle" Const
String sStateFatalError = "FatalError" Const

Function setToIdle()
	GoToState(sStateIdle)
EndFunction

Function triggerFatalError()
	GoToState(sStateFatalError)
EndFunction

Chronicle:Engine Function getEngine()
	return MyEngine
EndFunction

Bool Function isDormant()
	return false
EndFunction

Bool Function isIdle()
	return false
EndFunction

Function startupBehavior()
	GoToState(sStateIdle)
EndFunction

Event OnQuestInit()
	; message
	triggerFatalError()
EndEvent

Event OnQuestShutdown()
	; message
	triggerFatalError()
EndEvent

Auto State Dormant
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
	
	Event OnQuestInit()
		startupBehavior()
	EndEvent
EndState

State Idle
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		SendCustomEvent("Idled")
	EndEvent
	
	Bool Function isIdle()
		return true
	EndFunction
EndState

State Decommissioned
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
EndState

State FatalError
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		SendCustomEvent("FatalError")
		Stop()
	EndEvent
	
	Event OnQuestShutdown()
		; prevents a useless log message and redundant state transition
	EndEvent
EndState
