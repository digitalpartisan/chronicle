Scriptname Chronicle:Engine:Terminal extends DynamicTerminal:Basic Conditional

Chronicle:Engine:Handler Property MyHandler Auto Const Mandatory
{The wrapper for the engine being displayed on the terminal.}
Message Property InvalidEngineMessage Auto Const Mandatory
{The message to display in the terminal if an invalid engine is specified.}

Function tokenReplacementLogic()
	if (MyHandler.isValid())
		replace("SelectedEngine", MyHandler.getEngine())
	else
		replace("SelectedEngine", InvalidEngineMessage) ; The terminal shouldn't show a replacement field in this case, but caution never hurt
	endif
EndFunction
