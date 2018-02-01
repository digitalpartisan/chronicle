Scriptname chronicle:engine:Terminal extends DynamicTerminal:Basic Conditional

Message Property InvalidEngineMessage Auto Const Mandatory
{The message to display in the terminal if an invalid engine is specified.}

Function tokenReplacementLogic()
	if (isValid())
		replace("SelectedEngine", getEngine())
	else
		replace("SelectedEngine", InvalidEngineMessage) ; The terminal shouldn't show a replacement field in this case, but caution never hurt
	endif
EndFunction
