Scriptname Chronicle:Package:ListWrapper extends DynamicTerminal:ListWrapper
{Use of this script requires the latest version of the Dynamic Terminal library.  This script is not strictly required to make use of the basic behaviors of the Chronicle library.
The purpose of this script is to assit with in-terminal pagination of the packages installed in an engine (hence the engine property.)  This is helpful when a mod author wishes to 
use terminals to display information about what packages are installed as well as transition to another terminal displaying details about individual packages.
See the Chronicle Testing plugin for examples of its use.}

Chronicle:Engine Property MyEngine Auto Const Mandatory

Chronicle:Engine Function getEngine()
	return MyEngine
EndFunction

Int Function getRawDataSize()
{See DynamicTerminal:ListWrapper.}
	return getEngine().getPackages().getSize()
EndFunction

Form Function getRawDataItem(Int iNumber)
{See DynamicTerminal:ListWrapper.}
	return getEngine().getPackages().getAsPackage(iNumber)
EndFunction
