Scriptname Chronicle:Package:CustomBehavior:ThirdPartyPlugin extends Chronicle:Package:CustomBehavior
{Use of this script requires the Inject-Tec library.  It creates a package behavior customization that will only install if a particular plugin is installed in the load order.
This script is not required to use the Chronicle as such.}

InjectTec:Plugin[] Property ThirdPartyPlugins Auto Const Mandatory

Bool Function checkPlugins()
	if (ThirdPartyPlugins)
		Int iCounter = 0
		while (iCounter < ThirdPartyPlugins.Length)
			if (!ThirdPartyPlugins[iCounter].isInstalled())
				return false
			endif
			iCounter += 1
		endWhile
	endif
	
	return true
EndFunction

Bool Function meetsInstallationConditions()
	Bool bresult = checkPlugins()
	Chronicle:Logger:Package:CustomBehavior.logCheckPluginInstalled(self, bResult)
	
	return bResult
EndFunction
