Scriptname Chronicle:Engine:Paginator extends DynamicTerminal:Paginator Conditional
{Used to display a list of engines in a terminal.  Not generally useful unless there are multiple engines in a plugin, such as with the Chronicle Testing plugin.}

Chronicle:Engine:Handler Property EngineHandler Auto Const Mandatory

Function itemActivation(Int iItem, ObjectReference akTerminalRef)
	EngineHandler.setEngine(getItem(iItem) as Chronicle:Engine)
	EngineHandler.draw(akTerminalRef)
EndFunction
