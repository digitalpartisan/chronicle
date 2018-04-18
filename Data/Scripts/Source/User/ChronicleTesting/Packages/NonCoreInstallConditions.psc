Scriptname ChronicleTesting:Packages:NonCoreInstallConditions extends Chronicle:Package:NonCore

GlobalVariable Property ConditionToggle Auto Const Mandatory

Bool Function meetsCustomInstallationConditions()
	return ConditionToggle.GetValueInt() as Bool
EndFunction
