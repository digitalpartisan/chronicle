Scriptname Chronicle:Package:CustomBehavior:CustomQuestType:HolotapeRetainer extends Chronicle:Package:CustomBehavior:CustomQuestType

Jiffy:HolotapeRetainer Property RetainerQuest Auto Const
Bool Property StartOnInstall = false Auto Const
Bool Property StartOnPostload = false Auto Const
Bool Property StopOnUninstall = true Auto Const

Quest Function getDetachedQuestRecord()
	return RetainerQuest
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
