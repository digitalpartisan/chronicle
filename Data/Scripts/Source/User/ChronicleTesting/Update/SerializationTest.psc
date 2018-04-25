Scriptname ChronicleTesting:Update:SerializationTest extends chronicle:package:update

GlobalVariable Property ChronicleTesting_SerializationSeconds Auto Const Mandatory

Function updateLogic()
	Utility.Wait(ChronicleTesting_SerializationSeconds.GetValue())
	sendSuccess()
EndFunction
