Scriptname Chronicle:Engine:Handler:Static extends Chronicle:Engine:Handler Conditional

Chronicle:Engine Property MyEngine Auto Const Mandatory

Chronicle:Engine Function getEngine()
	return MyEngine
EndFunction

Function setEngine(Chronicle:Engine newEngine)
	; do nothing - the engine is already set
EndFunction
