Scriptname Chronicle:Package:NonCore extends Chronicle:Package

Group EnvironmentProperties
	Chronicle:Package:EngineWrapper Property MyEngineWrapper Auto Const Mandatory
	Bool Property InAIO = false Auto Const
	{Set this to true if this package will be included in some sort of All-in-One package so that it cannot be uninstalled.}
EndGroup

Group CompatabilitySettings
	Chronicle:Version:Static Property CoreCompatibilityVersion Auto Const
	{The minimum version of the Core package, if any, this package requires to function.  See the Chronicle:Engine script for details.}
	Message Property TooOldMessage Auto Const
	{The message displayed when this package's CoreCompatibilityVersion value is below the engine's required version.  I.e. what to tell the player when the mod providing this package isn't up to date.}
	Message Property TooNewMessage Auto Const
	{The message displayed when this package's CoreCompatibilityVersion value is higher than the Core Package's version setting.  I.e. what to tell the player when the mod providing the core package isn't up to date.}
EndGroup

Chronicle:Engine myEngine = None

Bool Function isInAIO()
	return InAIO
EndFunction

Function runEngineWrapper()
	myEngine = MyEngineWrapper.getEngineObject()
EndFunction

Chronicle:Engine Function getEngine()
	if (None == myEngine)
		runEngineWrapper()
	endif
	
	return myEngine
EndFunction

Chronicle:Version Function getCoreCompatibilityVersion()
	return CoreCompatibilityVersion
EndFunction

Bool Function isEngineAccessible()
	if (None == myEngine)
		runEngineWrapper()
	endif
	
	return (None != myEngine)
EndFunction