;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname ChronicleTesting:Fragments:Terminals:InstallToggles Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
ChronicleTesting_0Install_4PackageConditions_Toggle.SetValue(1.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property ChronicleTesting_0Install_4PackageConditions_Toggle Auto Const
