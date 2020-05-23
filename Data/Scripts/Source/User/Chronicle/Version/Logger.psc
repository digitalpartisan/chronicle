Scriptname Chronicle:Version:Logger Hidden Const DebugOnly

String[] Function getTags() Global
	String[] tags = new String[0]
	tags.Add("Version")
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

Bool Function logInvalid(Chronicle:Version versionRef) Global
	return log(versionRef + " is invalid")
EndFunction

Bool Function logComparison(Chronicle:Version leftHandValue, Chronicle:Version rightHandValue, Int iResult) Global
	String sMessage = leftHandValue.toString() + " is "
	if (-1 == iResult)
		sMessage += "less than "
	elseif (1 == iResult)
		sMessage += "greater than "
	else
		sMessage += "equal to "
	endif
	sMessage += rightHandValue.toString()
	
	return log(sMessage)
EndFunction

Bool Function logInvalidation(Chronicle:Version:Stored versionRef) Global
	return log(versionRef + " has been invalidated")
EndFunction

Bool Function logNoUpdate(Chronicle:Version:Static versionRef) Global
	return error(versionRef + " has no associated update to run")
EndFunction

