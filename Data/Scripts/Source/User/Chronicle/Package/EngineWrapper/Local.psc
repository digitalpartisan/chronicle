Scriptname Chronicle:Package:EngineWrapper:Local extends Chronicle:Package:EngineWrapper
{This particular engine wrapper is trivially simple.  Contrast it with the Chronicle:Package:EngineWrapper:Remote script.
The purpose of a local engine wrapper is to provide an engine for a non-core package where the engine is either in the same plugin or in a master plugin
such that it can be assigned in the editor.}

Chronicle:Engine Property MyEngine Auto Const Mandatory

Chronicle:Engine Function getEngineObject()
	return MyEngine
EndFunction
