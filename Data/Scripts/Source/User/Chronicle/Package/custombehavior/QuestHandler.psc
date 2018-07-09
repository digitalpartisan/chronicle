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
			Chronicle:Logger:Package:CustomBehavior.logStoppingQuest(self, data.Target, bInstall)
			data.Target.Stop()
		else
			Chronicle:Logger:Package:CustomBehavior.logStartingQuest(self, data.Target, bInstall)
			data.Target.Start()
		endif
	else
		if (data.StopOnUninstall)
			Chronicle:Logger:Package:CustomBehavior.logStoppingQuest(self, data.Target, bInstall)
			data.Target.Stop()
		endif
	endif
EndFunction

Function handleQuests(Bool bInstall = true)
	if (!Quests)
		return
	endif
	
	Int iCounter = 0
	while (iCounter < Quests.Length)
		handleQuest(Quests[iCounter])
		iCounter += 1
	endWhile
EndFunction

Bool Function installBehavior()
	handleQuests()
	return parent.installBehavior()
EndFunction

Bool Function uninstallBehavior()
	handleQuests(false)
	return parent.uninstallBehavior()
EndFunction
