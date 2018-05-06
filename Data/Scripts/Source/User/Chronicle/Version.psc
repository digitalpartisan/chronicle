Scriptname Chronicle:Version extends Quest Hidden Conditional
{Core version logic.  Getter/setter interface definitions and comparison logic. Extensions of this script are expected to implement getter/setter logic as is appropriate for their functionality.
No child of this script should be marked "Start Game Enabled" since that stands a good chance of running updates for no reason whatsoever.}

Int Function getMajor()
{Returns the value of the major segment of the version number.}
	Chronicle:Logger.logBehaviorUndefined(self, "getMajor()")
	return 0
EndFunction

Function setMajor(Int iValue)
{Sets the value of the major segment of the version number.}
	Chronicle:Logger.logBehaviorUndefined(self, "setMajor()")
EndFunction

Int Function getMinor()
{Returns the value of the minor segment of the version number.}
	Chronicle:Logger.logBehaviorUndefined(self, "getMinor()")
	return 0
EndFunction

Function setMinor(Int iValue)
{Sets the value of the minor segment of the version number.}
	Chronicle:Logger.logBehaviorUndefined(self, "setMinor()")
EndFunction

Int Function getBugfix()
{Returns the bugfix segment of the version number.}
	Chronicle:Logger.logBehaviorUndefined(self, "getBugfix()")
	return 0
EndFunction

Function setBugfix(Int iValue)
{Sets the value of the bugfix segment of the version number.}
	Chronicle:Logger.logBehaviorUndefined(self, "setBugfix()")
EndFunction

Bool Function validate()
{Returns true if the value settings are something other than 0.0.0 and false otherwise.}
	Bool bResult = getMajor() > 0 || getMinor() > 0 || getBugfix() > 0 ; allows for versions that could be 0.0.*, 0.*.0, and *.0.0 - bascially, something needs to not be zero
	if (!bResult)
		Chronicle:Logger:Version.logInvalid(self)
	endif
	
	return bResult
EndFunction

Int Function compareInt(Int iLeft, Int iRight)
{This is your typical algorithm-style compare two values and indicate which, if either, was larger, or if they're equal.
iLeft < iRight returns -1.
iLeft == iRight returns 0
iLeft > iRight returns 1.}
	if (iLeft < iRight)
		return -1
	elseif (iLeft > iRight)
		return 1
	else
		return 0
	endif
EndFunction

Int Function compareMajor(Int iValue)
{Compares the value of this version's major segment with the given integer value.  See compareInt() for details.}
	return compareInt(getMajor(), iValue)
EndFunction

Int Function compareMinor(Int iValue)
{Compares the value of this version's minor segment with the given integer value.  See compareInt() for details.}
	return compareInt(getMinor(), iValue)
EndFunction

Int Function compareBugfix(Int iValue)
{Compares the value of this version's bugfix segment with the given integer value.  See compareInt() for details.}
	return compareInt(getBugfix(), iValue)
EndFunction

Int Function compare(Chronicle:Version otherVersion)
{Performs a segment to segment comparison with this version's segment values in the left-hand position and the otherVersion's segment values in the right hand position.
Returns values are identical to compareInt() except the logic true for the entire version instead of a single integer value.}
	if (None == otherVersion)
		return 1 ; assume this version is greater than None
	endif
	
	Int iResult = 0
	
	iResult = compareMajor(otherVersion.getMajor())
	if (0 != iResult)
		return iResult
	endif
	iResult = compareMinor(otherVersion.getMinor())
	if (0 != iResult)
		return iResult
	endif
	iResult = compareBugfix(otherVersion.getBugfix())
	
	Chronicle:Logger:Version.logComparison(self, otherVersion, iResult)
	
	return iResult
EndFunction

Bool Function equals(Chronicle:Version otherVersion)
{Return true if this version is equal to otherVersion and false otherwise.  See compare() for details.}
	return compare(otherVersion) == 0
EndFunction

Bool Function notEquals(Chronicle:Version otherVersion)
{Syntactical sugar for !equals()}
	return !equals(otherVersion)
EndFunction

Bool Function lessThan(Chronicle:Version otherVersion)
{Returns true if this version is less than otherVersion and false otherwise.  See compare() for details.}
	return compare(otherVersion) == -1
EndFunction

Bool Function notLessThan(Chronicle:Version otherVersion)
{Synactical sugar for !lessThan()}
	return !lessThan(otherVersion)
EndFunction

Bool Function greaterThan(Chronicle:Version otherVersion)
{Returns true if this version is greater than otherVersion and false otherwise.  See compare() for details.}
	return compare(otherVersion) == 1
EndFunction

Bool Function notGreaterThan(Chronicle:Version otherVersion)
{Syntactical sugar for !greaterThan()}
	return !greaterThan(otherVersion)
EndFunction

Bool Function setTo(Chronicle:Version otherVersion)
{Sets this version's segments to hold the value of otherVersion's segments.}
	if (!otherVersion.validate())
		return false
	endif
	
	setMajor(otherVersion.getMajor())
	setMinor(otherVersion.getMinor())
	setBugfix(otherVersion.getBugfix())
	
	return true
EndFunction

String Function toString()
{A useful string builder which helps immensely with debug logging.}
	return "v" + getMajor() + "." + getMinor() + "." + getBugfix()
EndFunction
