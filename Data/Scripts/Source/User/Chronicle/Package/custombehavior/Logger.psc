Scriptname Chronicle:Package:CustomBehavior:Logger Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[0]
	tags.Add("Package")
	tags.Add("CustomBehavior")
	return tags
EndFunction

Bool Function log(String sMessage) Global
	return Chronicle:Logger.log(sMessage, getTags())
EndFunction

Bool Function warn(String sMessage) Global
	return Chronicle:Logger.warn(sMessage, getTags())
EndFunction

Bool Function error(String sMessage) Global
	return Chronicle:Logger.error(sMessage, getTags())
EndFunction

Bool Function logDefaultInstallationConditions(Chronicle:Package:CustomBehavior behavior) Global
	return warn(behavior + " is executing the default install conditions")
EndFunction

Bool Function logDefaultInstall(Chronicle:Package:CustomBehavior behavior) Global
	return warn(behavior + " is executing the default install behavior")
EndFunction

Bool Function logDefaultPostload(Chronicle:Package:CustomBehavior behavior) Global
	return warn(behavior + " is executing the default postload behavior")
EndFunction

Bool Function logDefaultUninstall(Chronicle:Package:CustomBehavior behavior) Global
	return warn(behavior + " is executing the default uninstall behavior")
EndFunction

Bool Function logPerks(Chronicle:Package:CustomBehavior:Perks behavior, Bool bAdding = true) Global
	return log(Jiffy:Loggout.buildMessage(behavior + " is ", bAdding, "adding", "removing"))
EndFunction

Bool Function logQuest(Chronicle:Package:CustomBehavior:QuestHandler behavior, Bool bInstalling = true) Global
	return log(Jiffy:Loggout.buildMessage(behavior + " is ", bInstalling, "setting up", "shutting down"))
EndFunction
