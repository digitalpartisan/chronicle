Scriptname ChronicleTesting:PackageCustomication:SerializationTest extends Chronicle:Package:CustomBehavior

GlobalVariable Property ChronicleTesting_SerializationSeconds Auto Const Mandatory

Function forceWait()
	Utility.Wait(ChronicleTesting_SerializationSeconds.GetValue())
EndFunction

Bool Function meetsInstallationConditions()
	forceWait()
	return true
EndFunction

Bool Function installBehavior()
	forceWait()
	return true
EndFunction

Bool Function postloadBehavior()
	forceWait()
	return true
EndFunction

Bool Function uninstallBehavior()
	forceWait()
	return true
EndFunction
