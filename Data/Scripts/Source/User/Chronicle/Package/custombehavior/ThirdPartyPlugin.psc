Scriptname Chronicle:Package:CustomBehavior:ThirdPartyPlugin extends Chronicle:Package:CustomBehavior

InjectTec:Plugin Property ThirdPartyPlugin Auto Const Mandatory

Bool Function meetsInstallationConditions()
	return ThirdPartyPlugin.isInstalled()
EndFunction
