Scriptname Chronicle:Package:CustomBehavior:Paginator extends DynamicTerminal:Paginator Conditional

Chronicle:Package:CustomBehavior:Handler Property Handler Auto Const Mandatory

Function itemActivation(Int iItem, ObjectReference akTerminalRef)
	Handler.setBehavior(getItem(iItem) as Chronicle:Package:CustomBehavior)
EndFunction
