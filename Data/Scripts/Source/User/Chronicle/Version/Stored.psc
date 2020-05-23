Scriptname Chronicle:Version:Stored extends Chronicle:Version Conditional
{Stores values given to it programmatically and provides them as needed.  Useful for maintaining the current setting of something and wiping it out as needed.
It is strongly recommended that you not check the "Start Game Enabled" box as these objects have the potential to do useful things by hooking quest start and stop events when started and stopped by other objects as needed.
Optionally, you could check the "Run Once" button as you deem appropriate.

The variables on this script are set to be accessible by the Conditional system in the editor because you may which to enable or disable certain features of your plugin based on what version is currently active.}

Int iMajorVersion = 0 Conditional
Int iMinorVersion = 0 Conditional
Int iBugfixVersion = 0 Conditional

Int Function getMajor()
	return iMajorVersion
EndFunction

Function setMajor(Int iValue)
	iMajorVersion = iValue
EndFunction

Int Function getMinor()
	return iMinorVersion
EndFunction

Function setMinor(Int iValue)
	iMinorVersion = iValue
EndFunction

Int Function getBugfix()
	return iBugfixVersion
EndFunction

Function setBugfix(Int iValue)
	iBugfixVersion = iValue
EndFunction

Function invalidate()
{Useful for indicating that something was uninstalled.}
	setMajor(0)
	setMinor(0)
	setBugfix(0)
	
	Chronicle:Version:Logger.logInvalidation(self)
EndFunction
