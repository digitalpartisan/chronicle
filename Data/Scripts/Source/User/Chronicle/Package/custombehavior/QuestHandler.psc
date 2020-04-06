Scriptname Chronicle:Package:CustomBehavior:QuestHandler extends Chronicle:Package:CustomBehavior

Struct QuestData 
	Quest Target
	Bool StartOnInstall = true
	Bool StopOnInstall = false
	Bool StartOnUninstall = false
	Bool StopOnUninstall = true
	Bool CompleteOnUninstall = false
	Bool FailOnUninstall = false
EndStruct

QuestData[] Property Quests Auto Const Mandatory

Function handleQuest(QuestData data, Bool bInstall = true)
	if (!data || !data.Target)
		return
	endif
	
	Bool bStart = false
	Bool bStop = false
	Bool bComplete = false
	Bool bFail = false
	
	if (bInstall)
		bStart = data.StartOnInstall
		bStop = data.StopOnInstall
	else
		bStart = data.StartOnUninstall
		bStop = data.StopOnUninstall
		bComplete = data.CompleteOnUninstall
		bFail = data.FailOnUninstall
	endif
	
	if (bFail)
		data.Target.FailAllObjectives()
	endif
	
	if (bComplete)
		data.Target.CompleteAllObjectives()
		data.Target.CompleteQuest()
	endif
	
	if (bStart)
		data.Target.Start()
	endif
	
	if (bStop)
		data.Target.Stop()
	endif
EndFunction

Function handleQuests(Bool bInstall = true)
	Chronicle:Logger:Package:CustomBehavior.logQuest(self, bInstall)

	if (!Quests || !Quests.Length)
		return
	endif
	
	Int iCounter = 0
	while (iCounter < Quests.Length)
		handleQuest(Quests[iCounter], bInstall)
		iCounter += 1
	endWhile
EndFunction

Bool Function installBehavior()
	handleQuests()
	return true
EndFunction

Bool Function uninstallBehavior()
	handleQuests(false)
	return true
EndFunction
