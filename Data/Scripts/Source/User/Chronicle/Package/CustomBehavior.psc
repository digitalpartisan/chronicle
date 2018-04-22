Scriptname Chronicle:Package:CustomBehavior extends Quest Hidden

Chronicle:Package Property MyPackage Auto Const Mandatory

Chronicle:Package Function getPackage()
	return MyPackage
EndFunction

Bool Function meetsInstallationConditions()
	return true
EndFunction

Bool Function installBehavior()
	return true
EndFunction

Bool Function postloadBehavior()
	return true
EndFunction

Bool Function uninstallBehavior()
	return true
EndFunction
