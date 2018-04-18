Scriptname Chronicle:Package:Core extends Chronicle:Package

Chronicle:Engine Property MyEngine Auto Const Mandatory

Bool Function isInAIO()
	return true ; by default, not relevant in this case
EndFunction

Chronicle:Engine Function getEngine()
	return MyEngine
EndFunction

Chronicle:Version Function getCoreCompatibilityVersion()
	return getVersionSetting() ; again, by default, not really an issue in the case of core packages
EndFunction

Bool Function isEngineAccessible()
	return true
EndFunction
