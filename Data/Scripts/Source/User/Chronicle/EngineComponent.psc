Scriptname Chronicle:EngineComponent extends Quest Hidden

CustomEvent Idled
CustomEvent FatalError

Chronicle:Engine Property MyEngine Auto Const Mandatory

String sStateDormant = "Dormant" Const
String sStateIdle = "Idle" Const
String sStateFatalError = "FatalError" Const

Bool bNeedsProcessing = false

Bool Function needsProcessing()
	return bNeedsProcessing
EndFunction

Function setNeedsProcessing(Bool bValue = true)
	bNeedsProcessing = bValue
EndFunction

Function goToProcessingState()
	Chronicle:Logger.logBehaviorUndefined(self, "goToProcessingState()")
	triggerFatalError()
EndFunction

Function process()
	Chronicle:Logger:Engine.logProcessComponent(self)
	setNeedsProcessing(false)
	goToProcessingState()
EndFunction

Function setToIdle()
	GoToState(sStateIdle)
EndFunction

Function triggerFatalError()
	GoToState(sStateFatalError)
EndFunction

Chronicle:Engine Function getEngine()
	return MyEngine
EndFunction

Function logStatus()
	Chronicle:Logger.logBehaviorUndefined(self, "logStatus()")
	triggerFatalError()
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
	Chronicle:Logger.logInvalidStartupAttempt(self)
	triggerFatalError()
EndEvent

Event OnQuestShutdown()
	Chronicle:Logger.logInvalidShutdownAttempt(self)
	triggerFatalError()
EndEvent

Auto State Dormant
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
	EndEvent
	
	Event OnQuestInit()
		logStatus()
		startupBehavior()
		logStatus()
	EndEvent
	
	Bool Function isDormant()
		return true
	EndFunction
EndState

State Idle
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
		SendCustomEvent("Idled")
	EndEvent
	
	Bool Function isIdle()
		return true
	EndFunction
EndState

State Decommissioned
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
	EndEvent
EndState

State FatalError
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
		SendCustomEvent("FatalError")
		Stop()
	EndEvent
	
	Function triggerFatalError()
		; prevents a useless log message and redundant state transition
	EndFunction
	
	Event OnQuestShutdown()
		; prevents a useless log message and redundant state transition
	EndEvent
EndState
