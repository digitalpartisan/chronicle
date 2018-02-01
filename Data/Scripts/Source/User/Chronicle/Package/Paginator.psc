Scriptname Chronicle:Package:Paginator extends DynamicTerminal:Paginator Conditional

Chronicle:Package:Handler Property PackageHandler Auto Const Mandatory

Function itemActivation(Int iItem, ObjectReference akTerminalRef)
	PackageHandler.setPackage(getItem(iItem) as Chronicle:Package)
	PackageHandler.draw(akTerminalRef)
EndFunction
