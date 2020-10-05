Scriptname Chronicle:Package:Core extends Chronicle:Package
{For architectural reasons, Chronicle requires core packages to specifically be of this type.  Note the commentary on the specifics herein to understand the differences between core and noncore packages.}

Chronicle:Engine Property MyEngine Auto Const Mandatory
{A Core package, unlike a noncore package, doesn't need an engine wrapper to locate its engine, so it's always set specifically here.}

Bool Function isInAIO()
{A Core package is always part of any All-in-One release, so this is always true.}
	return true
EndFunction

Chronicle:Engine Function getEngine()
{Once again, this is easy.  See the same method on the Chronicle:Package:Noncore script for the real reason this function exists.}
	return MyEngine
EndFunction

Chronicle:Version Function getCoreCompatibilityVersion()
{This is a somewhat trivial case, but as a matter of semantics, the core package's compatability version is always whatever it is set to be.}
	return getVersionSetting()
EndFunction

Bool Function isEngineAccessible()
{Once again, trivial.  As with getEngine(), reference the Chronicle:Package:Noncore script to understand this function's real purpose.}
	return true
EndFunction

Bool Function isCanaryEligible()
{Also trivial. The Core package is always eligible for calling Canary.}
	return true
EndFunction
