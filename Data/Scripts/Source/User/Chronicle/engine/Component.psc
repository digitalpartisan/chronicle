Scriptname Chronicle:Engine:Component extends Quest Hidden

Chronicle:Engine Property MyEngine Auto Const Mandatory

CustomEvent Idled
CustomEvent FatalError

String sStateDormant = "Dormant" Const
String sStateIdle = "Idle" Const
String sStateFatalError = "FatalError" Const

Bool bNeedsProcessing = false

Chronicle:Package[] PackageQueue

Function sendIdled()
	SendCustomEvent("Idled")
EndFunction

Function setToIdle()
	GoToState(sStateIdle)
EndFunction

Function sendFatalError()
	SendCustomEvent("FatalError")
	GoToState(sStateFatalError)
EndFunction

Bool Function needsProcessing()
	return bNeedsProcessing || isQueuePopulated()
EndFunction

Function setNeedsProcessing(Bool bValue = true)
	bNeedsProcessing = bValue
	Chronicle:Logger:Engine:Component.logNeedsProcessing(self, bValue)
EndFunction

Int Function getQueueSize()
	if (None == PackageQueue)
		return 0
	endif
	
	return PackageQueue.Length
EndFunction

Bool Function isQueuePopulated()
	return 0 < getQueueSize()
EndFunction

Chronicle:Package Function getQueueItem(Int iIndex)
	if (0 <= iIndex && iIndex < getQueueSize())
		return PackageQueue[iIndex]
	else
		return None
	endif
EndFunction

Chronicle:Package[] Function getPackageQueue()
{This exists because variables are private.}
	return PackageQueue
EndFunction

Bool Function canActOnPackage(Chronicle:Package targetPackage)
	; no fatal error here since this is a simple "yes/no" logic section
	return false
EndFunction

Bool Function queuePackage(Chronicle:Package packageRef)
	if (!IsRunning()) ; because populating the queue (even after initializing it from None) and then starting the quest actually zeros out whatever is in the queue
		return false
	endif

	if (canActOnPackage(packageRef))
		PackageQueue.Add(packageRef)
		Chronicle:Logger:Engine:Component.logQueued(self, packageRef)
		setNeedsProcessing()
		
		return true
	else
		Chronicle:Logger:Engine:Component.logCannotQueue(self, packageRef)
		return false
	endif
EndFunction

Chronicle:Package Function getTargetPackage()
	return None
EndFunction

Function goToProcessingState()
	; fatal error
EndFunction

Function postProcessingBehavior()
	; no fatal error since sometimes there is no post behavior to execute
EndFunction

Function processNextPackage()
	; fatal error
EndFunction

Function process()
	Chronicle:Logger:Engine.logProcessComponent(self)
	setNeedsProcessing(false)
	goToProcessingState()
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
	Chronicle:Logger.logInvalidStartupAttempt(self)
	sendFatalError()
EndEvent

Event OnQuestShutdown()
	Chronicle:Logger.logInvalidShutdownAttempt(self)
	sendFatalError()
EndEvent

Auto State Dormant
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
	
	Event OnQuestInit()
		PackageQueue = new Chronicle:Package[0] ; because array variables initialize to None
		startupBehavior()
	EndEvent
	
	Bool Function isDormant()
		return true
	EndFunction
EndState

State Idle
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		sendIdled()
	EndEvent
	
	Bool Function isIdle()
		return true
	EndFunction
EndState

State FatalError
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		Stop()
	EndEvent
	
	Event OnQuestShutdown()
		; do not trigger another error
	EndEvent
EndState
