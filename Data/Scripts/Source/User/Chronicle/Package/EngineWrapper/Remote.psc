Scriptname Chronicle:Package:EngineWrapper:Remote extends Chronicle:Package:EngineWrapper
{This script requires the Inject-Tec library.  Using this script is not strictly required by Chronicle.  This engine wrapper logic allows a package to install in an engine
which cannot be easily set in the editor.  This means that the engine is not in the same plugin as the non-core package using this wrapper and it is also not located in a master file
which said plugin could depend on.
In order to use this script successfully, you will need to understand how to set its properties.  See the Inject-Tec library for details.}

Import InjectTec:Utility:HexidecimalLogic

Group RemoteEngineSettings
	InjectTec:Plugin Property MyPlugin Auto Const Mandatory
	Int Property EngineID Auto Const
	DigitSet Property EngineDigits Auto Const Mandatory
EndGroup

Chronicle:Engine function loadEngine()
	return InjectTec:Plugin.fetchFromDigits(MyPlugin, EngineDigits) as Chronicle:Engine
EndFunction

Chronicle:Engine Function getEngineObject()
	return loadEngine()
EndFunction
