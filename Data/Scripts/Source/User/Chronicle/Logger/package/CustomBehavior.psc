Scriptname Chronicle:Logger:Package:CustomBehavior Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[2]
	tags[0] = "Package"
	tags[1] = "CustomBehavior"
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

Bool Function logInjection(Chronicle:Package:CustomBehavior:Injections behavior, Quest injection) Global
	return log(behavior + " is injecting " + injection)
EndFunction

Bool Function logRevertion(Chronicle:Package:CustomBehavior:Injections behavior, Quest injection) Global
	return log(behavior + " is reverting " + injection)
EndFunction

Bool Function logAddPerk(Chronicle:Package:CustomBehavior:Perks behavior, Perk pPerk) Global
	return log(behavior + " adding perk " + pPerk)
EndFunction

Bool Function logRemovePerk(Chronicle:Package:CustomBehavior:Perks behavior, Perk pPerk) Global
	return log(behavior + " removing perk " + pPerk)
EndFunction

Bool Function logCheckPluginInstalled(Chronicle:Package:CustomBehavior:ThirdPartyPlugin behavior, InjectTec:Plugin plugin) Global
	return log(behavior + " is checking for plugin " + plugin)
EndFunction

Bool Function logStartingQuest(Chronicle:Package:CustomBehavior:QuestHandler behavior, Quest target, Bool bInstall) Global
	String sMessage = behavior + " is starting quest " + target + " on package "
	if (bInstall)
		sMessage += " installation"
	else
		sMessage += " uninstallation"
	endif
	
	return log(sMessage)
EndFunction

Bool Function logStoppingQuest(Chronicle:Package:CustomBehavior:QuestHandler behavior, Quest target, Bool bInstall) Global
	String sMessage = behavior + " is stopping quest " + target + " on package "
	if (bInstall)
		sMessage += "installation"
	else
		sMessage += "uninstallation"
	endif
	
	return log(sMessage)
EndFunction
