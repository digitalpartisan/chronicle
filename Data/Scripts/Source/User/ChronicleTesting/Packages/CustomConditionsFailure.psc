Scriptname ChronicleTesting:Packages:CustomConditionsFailure extends Chronicle:Package:Local Conditional

GlobalVariable Property ConditionToggle Auto Const Mandatory

Bool Function meetsCustomInstallationConditions()
	return ConditionToggle.GetValueInt() as Bool
EndFunction
