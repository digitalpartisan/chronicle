Scriptname chronicle:logger:engine:updater Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[1]
	tags[0] = "Engine"
	tags[1] = "Updater"
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
