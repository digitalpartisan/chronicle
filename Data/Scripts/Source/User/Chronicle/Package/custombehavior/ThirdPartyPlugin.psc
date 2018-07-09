Scriptname Chronicle:Package:CustomBehavior:ThirdPartyPlugin extends Chronicle:Package:CustomBehavior
{Use of this script requires the Inject-Tec library.  It creates a package behavior customization that will only install if a particular plugin is installed in the load order.
This script is not required to use the Chronicle as such.}

InjectTec:Plugin Property ThirdPartyPlugin Auto Const Mandatory

Bool Function meetsInstallationConditions()
	if (ThirdPartyPlugin)
		Chronicle:Logger:Package:CustomBehavior.logCheckPluginInstalled(self, ThirdPartyPlugin)
		return ThirdPartyPlugin.isInstalled()
	endif
	
	return false
EndFunction
