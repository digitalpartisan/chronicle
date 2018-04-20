Scriptname Chronicle:Package:PaginationData extends DynamicTerminal:ListWrapper

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
