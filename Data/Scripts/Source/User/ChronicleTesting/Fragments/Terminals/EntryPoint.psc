;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname ChronicleTesting:Fragments:Terminals:EntryPoint Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
EnginePaginator.init(akTerminalRef, InstallData)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
EnginePaginator.init(akTerminalRef, UpgradeData)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
EnginePaginator.init(akTerminalRef, UninstallData)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
EnginePaginator.init(akTerminalRef, RemoteData)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
EnginePaginator.init(akTerminalRef, SerializationData)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
EnginePaginator.init(akTerminalRef, CustomizationData)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Chronicle:Engine:Paginator Property EnginePaginator Auto Const Mandatory

DynamicTerminal:ListWrapper Property InstallData Auto Const Mandatory

DynamicTerminal:ListWrapper Property UpgradeData Auto Const Mandatory

DynamicTerminal:ListWrapper Property UninstallData Auto Const Mandatory

DynamicTerminal:ListWrapper Property RemoteData Auto Const Mandatory

DynamicTerminal:ListWrapper Property SerializationData Auto Const Mandatory

DynamicTerminal:ListWrapper Property CustomizationData Auto Const Mandatory
