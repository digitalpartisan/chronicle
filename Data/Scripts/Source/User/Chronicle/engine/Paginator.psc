Scriptname Chronicle:Engine:Paginator extends DynamicTerminal:Paginator Conditional

Chronicle:Engine:Handler Property EngineHandler Auto Const Mandatory

Function itemActivation(Int iItem, ObjectReference akTerminalRef)
	EngineHandler.setEngine(getItem(iItem) as Chronicle:Engine)
	EngineHandler.draw(akTerminalRef)
EndFunction
