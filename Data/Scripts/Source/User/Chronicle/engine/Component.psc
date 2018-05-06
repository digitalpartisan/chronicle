Scriptname Chronicle:Engine:Component extends Quest Hidden
{This is the base logic set for all components.  Note the presence of a package queue.  Not every component will use one, but the functionality isn't unique to a single component type, so it lives here.
When attaching a component script to a quest record, do not check the "Start Game Enabled" box because the components are not self-initializing entities and should not start on their own.}

Chronicle:Engine Property MyEngine Auto Const Mandatory
{The engine to which this component belongs.}

CustomEvent Idled ; what happens when a component returns to its idle state
CustomEvent FatalError ; what happens when this package encounters a fatal error either as a result of its own problems or a package reports a similar fatal error while being worked on

String sStateDormant = "Dormant" Const
String sStateIdle = "Idle" Const
String sStateDecommissioned = "Decommissioned" Const
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
{Not only can this change definitions based on what state the script is in, but individual components can have very different criteria for this logic.  See child scripts for examples.}
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
{Determining what package to work on next can change radically from one state to another and even more so from one component type to another.
This is especially important because the core package frequently gets special treatment in states unique to its needs in some component types.
See children of this script for examples.}
	return None
EndFunction

Function goToProcessingState()
{This is left undefined here because what constitutes processing is different for each component type but the overal behavior still needs to be known by this script as a specific function to call when appropriate.}
EndFunction

Function postProcessingBehavior()
{This particular behavior is what a component does after it has finished working on an individual package.  Once again, see child scripts and their various states for a better understanding.}
EndFunction

Function processNextPackage()
{This is another function very similar to getTargetPackage() in that its implementations can vary wildly depending on context.}
EndFunction

Function process()
{This is the function an engine calls to cause a component to operate.  In effect, it is the entry point for all other behaviors a component will perform.}
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
{For most component types, starting up means going directly to an idle state, but this needs to be overridable yet remain a unique behavior.  See the installer component type for details.}
	GoToState(sStateIdle)
EndFunction

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
	
	Event OnQuestShutdown()
		GoToState(sStateDecommissioned)
	EndEvent
EndState

State Decommissioned
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
	
	Bool Function canActOnPackage(Chronicle:Package packageRef)
		return false
	EndFunction
	
	Bool Function queuePackage(Chronicle:Package packageRef)
		return false
	EndFunction
EndState

State FatalError
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		Stop()
	EndEvent
	
	Bool Function canActOnPackage(Chronicle:Package packageRef)
		return false
	EndFunction
	
	Bool Function queuePackage(Chronicle:Package packageRef)
		return false
	EndFunction
EndState
