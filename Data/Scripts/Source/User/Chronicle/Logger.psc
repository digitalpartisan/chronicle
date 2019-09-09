Scriptname Chronicle:Logger Hidden Const DebugOnly

String Function getName() Global
	return "Chronicle"
EndFunction

Bool Function log(String sMessage, String[] tags = None) Global
	return Jiffy:Loggout.log(getName(), sMessage, tags)
EndFunction

Bool Function warn(String sMessage, String[] tags = None) Global
	return Jiffy:Loggout.warn(getName(), sMessage, tags)
EndFunction

Bool Function error(String sMessage, String[] tags = None) Global
	return Jiffy:Loggout.error(getName(), sMessage, tags)
EndFunction

Bool Function logBehaviorUndefined(ScriptObject scriptRef, String sName) Global
	return error("Behavior " + sName + " undefined on " + scriptRef)
EndFunction

Bool Function logStateChange(ScriptObject objectRef, String sOldState) Global
	return log(objectRef + " changed state to " + objectRef.GetState() + " from " + sOldState)
EndFunction

Bool Function logInvalidStartupAttempt(ScriptObject objectRef) Global
	return log(objectRef + " observed an invalid startup attempt in state " + objectRef.GetState())
EndFunction

Bool Function logInvalidShutdownAttempt(ScriptObject objectRef) Global
	return log(objectRef + " observed an invalid shutdown attempt in state " + objectRef.GetState())
EndFunction
