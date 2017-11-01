Scriptname Chronicle:Package:Remote extends Chronicle:Package Conditional

InjectTec:Plugin Property MyPlugin Auto Const Mandatory
Int Property EngineID Auto Const Mandatory

Chronicle:Engine function getEngine()
	if (!MyPlugin)
		return None
	endif
	
	return MyPlugin.lookupForm(EngineID) as Chronicle:Engine
EndFunction
