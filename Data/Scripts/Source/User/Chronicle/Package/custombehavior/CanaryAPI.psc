ScriptName Chronicle:Package:CustomBehavior:CanaryAPI extends Chronicle:Package:CustomBehavior Hidden
{Extend this script to have its own unique name for each package that needs to call the Canary API and set its FullScriptName property}

String Property FullScriptName Auto Const Mandatory
{The full script name of the ultimate child script that ends up calling the Canary API.}
Int Property iSaveFileMonitor Auto Hidden
{Do not mess with ever - this is used by Canary to track data loss}

String Function getScriptName()
	return FullScriptName
EndFunction

Function performCall()
	Chronicle:Package packageObject = getPackage()
	if (!packageObject || !packageObject.isCanaryEligible())
		return
	endif

	Jiffy:Canary.callAPI(self, getScriptName())
EndFunction

Bool Function installBehavior()
	performCall()
	return true
EndFunction

Bool Function postloadBehavior()
	performCall()
	return true
EndFunction
