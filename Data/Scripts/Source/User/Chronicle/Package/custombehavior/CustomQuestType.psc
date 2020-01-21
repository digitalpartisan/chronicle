Scriptname Chronicle:Package:CustomBehavior:CustomQuestType extends Chronicle:Package:CustomBehavior Hidden
{This type of customization is a better handler for a commonly used quest script type than the Chronicle:Package:CustomBehavior:QuestHandler customization.}

Bool Property IsAttached = false Auto Const
{If true, the quest record to which this script is attached started and stopped in lieu of another record which may be set on child scripts of Chronicle:Package:CustomBehavior:CustomQuestType.}

Quest Function getDetachedQuestRecord()
{Override this method to return the real quest record to act on.}
	Chronicle:Logger.logBehaviorUndefined(self, "getDetachedQuestRecord")
	return None
EndFunction

Bool Function getStartOnInstall()
	return false
EndFunction

Bool Function getStartOnUpdate()
	return false
EndFunction

Bool Function getStartOnPostload()
	return false
EndFunction

Bool Function getStopOnUninstall()
	return false
EndFunction

Quest Function getQuestRecord()
{Implements the logic required to juggle the values of the IsAttached and ExitDetector property settings.}
	if (IsAttached)
		return self
	else
		return getDetachedQuestRecord()
	endif
EndFunction

Function attemptBehavior(Bool bAttempt = true, Bool bStart = true)
	if (!bAttempt)
		return
	endif
	
	Quest questRecord = getQuestRecord()
	if (!questRecord)
		return
	endif
	
	if (bStart)
		questRecord.Start()
	else
		questRecord.Stop()
	endif
EndFunction

Function attemptStart(Bool bAttempt = true)
	attemptBehavior(bAttempt, true)
EndFunction

Function attemptStop(Bool bAttempt = true)
	attemptBehavior(bAttempt, false)
EndFunction

Bool Function installBehavior()
	attemptStart(getStartOnInstall())
	return true
EndFunction

Bool Function updateBehavior()
	attemptStart(getStartOnUpdate())
	return true
EndFunction

Bool Function postloadBehavior()
	attemptStart(getStartOnPostload())
	return true
EndFunction

Bool Function uninstallBehavior()
	attemptStop(getStopOnUninstall())
	return true
EndFunction
