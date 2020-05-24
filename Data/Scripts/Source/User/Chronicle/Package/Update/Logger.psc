Scriptname Chronicle:Package:Update:Logger Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = Chronicle:Package:Logger.getTags()
	tags.Add("Update")
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

Bool Function starting(Chronicle:Package:Update updateRef) Global
	return log(updateRef + " is starting")
EndFunction

Bool Function stopping(Chronicle:Package:Update updateRef) Global
	return log(updateRef + " is stopping")
EndFunction

