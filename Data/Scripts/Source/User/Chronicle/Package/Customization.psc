Scriptname Chronicle:Package:Customization extends Quest Hidden

Chronicle:Package Property MyPackage Auto Const Mandatory
{This is here because the custom behavior of a package may need to access the package it acts on for some reason.}

Chronicle:Package Function getPackage()
	return MyPackage
EndFunction
