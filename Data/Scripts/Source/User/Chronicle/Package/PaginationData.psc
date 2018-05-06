Scriptname Chronicle:Package:PaginationData extends DynamicTerminal:ListWrapper
{Use of this script requires the Dynamic Terminal library.  Chronicle does not force you to use this functionality to access the bulk of its features.
This script uses the Chronicle:Engine:Handler script to identify the engine object being handled and paginate its packages in a terminal.}

Chronicle:Engine:Handler Property EngineHandler Auto Const Mandatory
{The engine handler used in the dynamic terminal process of managing a particular engine.  Used to access the engine and its data (particularly the installed packages.)}

int Function getRawDataSize()
{See DynamicTerminal:ListWrapper.}
	if (EngineHandler.isValid())
		return EngineHandler.getEngine().getPackages().getSize()
	else
		return 0
	endif
EndFunction

Form Function getRawDataItem(Int iNumber)
{See DynamicTerminal:ListWrapper.}
	if (EngineHandler.isValid())
		return EngineHandler.getEngine().getPackages().getAsPackage(iNumber)
	else
		return None
	endif
EndFunction
