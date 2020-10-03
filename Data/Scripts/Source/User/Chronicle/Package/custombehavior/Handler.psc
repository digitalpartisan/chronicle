Scriptname Chronicle:Package:CustomBehavior:Handler extends DynamicTerminal:Basic Conditional

Bool bValid = false Conditional ; whether or not there's a valid Package to handle

Chronicle:Package:CustomBehavior behaviorObject = None;

Chronicle:Package:CustomBehavior Function getBehavior()
	return behaviorObject
EndFunction

Bool Function isValid()
	return bValid
EndFunction

Function refreshStatus()
	bValid = (None != getBehavior())
EndFunction

Function setBehavior(Chronicle:Package:CustomBehavior newValue)
	behaviorObject = newValue
	refreshStatus()
EndFunction

Function tokenReplacementLogic()
	if (isValid())
		replace("SelectedBehavior", getBehavior())
	else
		replace("SelectedPackage", None)
	endif
EndFunction
