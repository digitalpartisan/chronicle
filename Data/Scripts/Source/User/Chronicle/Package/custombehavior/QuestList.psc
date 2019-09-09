Scriptname Chronicle:Package:CustomBehavior:QuestList extends Chronicle:Package:CustomBehavior Hidden
{This particular customization is hidden because it is a very generic way of starting and stopping a list of quest records at the expected times.}

Function handleQuestList(FormList quests, Bool bStart = true)
	if (!quests)
		return
	endif
	
	Int iSize = quests.GetSize() const
	if (0 == iSize)
		return
	endif
	
	Int iCounter = 0
	Quest targetQuest = None
	while (iCounter < iSize)
		targetQuest = quests.GetAt(iCounter) as Quest
		if (targetQuest)
			if (bStart)
				targetQuest.Start()
			else
				targetQuest.Stop()
			endif
		endif
		iCounter += 1
	endWhile
EndFunction

Function handle(Bool bStart = true)
{Override this to call handleQuestList() with the appropriate values for your use case.}
	Chronicle:Logger.logBehaviorUndefined(self, "handle")
EndFunction

Bool Function installBehavior()
	handle()
	return true
EndFunction

Bool Function postloadBehavior()
	handle()
	return true
EndFunction

Bool Function uninstallBehavior()
	handle(false)
	return true
EndFunction
