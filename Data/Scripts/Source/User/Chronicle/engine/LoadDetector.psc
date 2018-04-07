Scriptname Chronicle:Engine:LoadDetector extends ReferenceAlias

Chronicle:Engine Property MyEngine Auto Const Mandatory

Event OnPlayerLoadGame()
	MyEngine.gameLoaded()
EndEvent
