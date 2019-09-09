Scriptname Chronicle:Package:CustomBehavior:CustomQuestType:Vault111ExitDetector extends Chronicle:Package:CustomBehavior:CustomQuestType

Jiffy:Vault111ExitDetector Property DetectorQuest Auto Const
Bool Property StartOnInstall = true Auto Const
Bool Property StartOnPostload = false Auto Const
Bool Property StopOnUninstall = true Auto Const

Quest Function getDetachedQuestRecord()
	return DetectorQuest
EndFunction

Bool Function getStartOnInstall()
	return StartOnInstall
EndFunction

Bool Function getStartOnPostload()
	return StartOnPostload
EndFunction

Bool Function getStopOnUninstall()
	return StopOnUninstall
EndFunction
