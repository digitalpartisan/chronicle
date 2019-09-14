Scriptname Chronicle:Engine:Handler:Static extends Chronicle:Engine:Handler Conditional

Chronicle:Engine Property MyEngine Auto Const Mandatory

Chronicle:Engine Function getEngine()
	return MyEngine
EndFunction

Function refreshStatus()
	setEngine(getEngine())
	parent.refreshStatus()
EndFunction
