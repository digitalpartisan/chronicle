Scriptname Chronicle:Package:Paginator extends DynamicTerminal:Paginator Conditional
{Using this script requires the Dynamic Terminal library.  Chronicle does not require the Dynamic Terminal library to utilize its core functionality.
The package paginator assigns the selected package in a paginated terminal to the package handler script so that the same terminal may display details about the package selected.
For an example application, reference the Chronicle Testing plugin.}

Chronicle:Package:Handler Property PackageHandler Auto Const Mandatory
{The package handler used to display package-specific information in the terminal using this paginator script.}

Function itemActivation(Int iItem, ObjectReference akTerminalRef)
	PackageHandler.setPackage(getItem(iItem) as Chronicle:Package)
	PackageHandler.draw(akTerminalRef)
EndFunction
