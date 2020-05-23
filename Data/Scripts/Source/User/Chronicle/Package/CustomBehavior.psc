Scriptname Chronicle:Package:CustomBehavior extends Chronicle:Package:Customization Hidden
{Overriding the functions in this script and setting the CustomBehaviors property on your package is how Chronicle suggests customizing package behavior.
Aside from the issue of composition over inheritance, it's best not to override things like engine / component / package scripts unless you have a very good reason for doing so.}

Bool Function meetsInstallationConditions()
	Chronicle:Package:CustomBehavior:Logger.logDefaultInstallationConditions(self)
	return true
EndFunction

Bool Function installBehavior()
	Chronicle:Package:CustomBehavior:Logger.logDefaultInstall(self)
	return true
EndFunction

Bool Function postloadBehavior()
	Chronicle:Package:CustomBehavior:Logger.logDefaultPostload(self)
	return true
EndFunction

Bool Function uninstallBehavior()
	Chronicle:Package:CustomBehavior:Logger.logDefaultUninstall(self)
	return true
EndFunction
