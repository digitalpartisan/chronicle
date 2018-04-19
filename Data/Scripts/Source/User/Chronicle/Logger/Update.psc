Scriptname Chronicle:Logger:Update Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[2]
	tags[0] = "Package"
	tags[1] = "Update"
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
