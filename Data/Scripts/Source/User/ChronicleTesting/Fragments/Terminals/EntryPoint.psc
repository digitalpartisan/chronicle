;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname ChronicleTesting:Fragments:Terminals:EntryPoint Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
Proxy.init(akTerminalRef, EnginePaginator, InstallData)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

DynamicTerminal:PaginationProxy Property Proxy Auto Const Mandatory

ChronicleTesting:EnginePaginator Property EnginePaginator Auto Const Mandatory

DynamicTerminal:ListWrapper Property InstallData Auto Const Mandatory
