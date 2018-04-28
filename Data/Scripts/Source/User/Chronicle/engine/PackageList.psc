Scriptname Chronicle:Engine:PackageList extends DynamicTerminal:ListWrapper

Chronicle:Engine Property MyEngine Auto Const Mandatory

int Function getRawDataSize()
{See DynamicTerminal:ListWrapper.}
	return MyEngine.getPackages().getSize()
EndFunction

Form Function getRawDataItem(Int iNumber)
{See DynamicTerminal:ListWrapper.}
	return MyEngine.getPackages().getAsPackage(iNumber)
EndFunction
