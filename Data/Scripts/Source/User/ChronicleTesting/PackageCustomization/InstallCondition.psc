Scriptname ChronicleTesting:PackageCustomization:InstallCondition extends chronicle:package:CustomBehavior

GlobalVariable Property ConditionToggle Auto Const Mandatory

Bool Function meetsInstallationConditions()
	return ConditionToggle.GetValueInt() as Bool
EndFunction
