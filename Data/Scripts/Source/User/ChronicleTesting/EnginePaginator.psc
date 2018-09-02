Scriptname ChronicleTesting:EnginePaginator extends dynamicterminal:paginator Conditional

ChronicleTesting:EngineHandler Property EngineHandler Auto Const Mandatory

Function itemActivation(Int iItem, ObjectReference akTerminalRef)
	EngineHandler.setEngine(getItem(iItem) as Chronicle:Engine)
	EngineHandler.draw(akTerminalRef)
EndFunction
