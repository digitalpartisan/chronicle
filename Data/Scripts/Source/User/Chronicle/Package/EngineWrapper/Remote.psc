Scriptname Chronicle:Package:EngineWrapper:Remote extends Chronicle:Package:EngineWrapper

Group RemoteEngineSettings
	InjectTec:Plugin Property MyPlugin Auto Const Mandatory
	Int Property EngineID Auto Const Mandatory
EndGroup

Chronicle:Engine function loadEngine()
	if (!MyPlugin)
		return None
	endif
	
	return MyPlugin.lookupForm(EngineID) as Chronicle:Engine
EndFunction

Chronicle:Engine Function getEngineObject()
	return loadEngine()
EndFunction
