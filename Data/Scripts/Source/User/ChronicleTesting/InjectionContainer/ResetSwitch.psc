Scriptname ChronicleTesting:InjectionContainer:ResetSwitch extends ObjectReference

ChronicleTesting:InjectionContainer Property TargetContainer Auto Const Mandatory

Event OnActivate(ObjectReference akActionRef)
	TargetContainer.setContents()
EndEvent
