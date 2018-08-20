Scriptname Chronicle:Package:CustomBehavior:QuestHandler extends Chronicle:Package:CustomBehavior

Struct QuestData 
	Quest Target
	Bool StopOnInstall = false
	Bool StopOnUninstall = true
EndStruct

QuestData[] Property Quests Auto Const Mandatory

Function handleQuest(QuestData data, Bool bInstall = true)
	if (!data || !data.Target)
		return
	endif
	
	if (bInstall)
		if (data.StopOnInstall)
			data.Target.Stop()
		else
			data.Target.Start()
		endif
	else
		if (data.StopOnUninstall)
			data.Target.Stop()
		endif
	endif
EndFunction

Function handleQuests(Bool bInstall = true)
	Chronicle:Logger:Package:CustomBehavior.logQuest(self, bInstall)

	if (!Quests)
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
