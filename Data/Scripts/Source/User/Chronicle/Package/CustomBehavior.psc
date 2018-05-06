Scriptname Chronicle:Package:CustomBehavior extends Quest Hidden
{Overriding the functions in this script and setting the CustomBehaviors property on your package is how Chronicle suggests customizing package behavior.
Aside from the issue of composition over inheritance, it's best not to override things like engine / component / package scripts unless you have a very good reason for doing so.}

Chronicle:Package Property MyPackage Auto Const Mandatory
{This is here because the custom behavior of a package may need to access the package it acts on for some reason.}

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
