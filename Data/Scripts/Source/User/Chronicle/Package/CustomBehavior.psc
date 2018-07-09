Scriptname Chronicle:Package:CustomBehavior extends Chronicle:Package:Customization Hidden
{Overriding the functions in this script and setting the CustomBehaviors property on your package is how Chronicle suggests customizing package behavior.
Aside from the issue of composition over inheritance, it's best not to override things like engine / component / package scripts unless you have a very good reason for doing so.}

Bool Function meetsInstallationConditions()
	Chronicle:Logger:Package:CustomBehavior.logDefaultInstallationConditions(self)
	return true
EndFunction

Bool Function installBehavior()
	Chronicle:Logger:Package:CustomBehavior.logDefaultInstall(self)
	return true
EndFunction

Bool Function postloadBehavior()
	Chronicle:Logger:Package:CustomBehavior.logDefaultPostload(self)
	return true
EndFunction

Bool Function uninstallBehavior()
	Chronicle:Logger:Package:CustomBehavior.logDefaultUninstall(self)
	return true
EndFunction
