Scriptname Chronicle:Package:Update extends Quest Hidden
{This is the base logic required to create an update to an existing version.  A child of this script is best used when attached to a version "quest" since that version will be started when it is upgraded to (but not upon a fresh installation.)
When started, this script will perform the associated update logic as defined in updateLogic() and then stop the quest outright.  The OnQuestInit and OnQuestShutdown events on this object could be observed in order to determine when the update is started and completed.}

CustomEvent Success
CustomEvent Failure

Function sendSuccess()
{Call this in your custom updateLogic() function to indicate the update is complete.}
	Stop()
	SendCustomEvent("Success")
EndFunction

Function sendFailure()
{Call this in your custom updateLogic() function to indicate the update cannot complete.}
	Stop()
	SendCustomEvent("Failure")
EndFunction

Function updateLogic()
{Override this in a child script to implement your update logic appropriate for the version to which this is associated.}
	Chronicle:Logger.logBehaviorUndefined(self, "updateLogic()")
EndFunction

Event OnQuestInit()
	Chronicle:Logger:Update.starting(self)
	updateLogic()
EndEvent

Event OnQuestShutdown()
	Chronicle:Logger:Update.stopping(self)
EndEvent
