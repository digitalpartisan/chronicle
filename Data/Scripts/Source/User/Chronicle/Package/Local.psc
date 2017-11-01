Scriptname Chronicle:Package:Local extends Chronicle:Package Conditional

Chronicle:Engine Property MyEngine Auto Const Mandatory
{The engine reference this package should install itself into.}

Chronicle:Engine Function getEngine()
	return MyEngine
EndFunction
