Scriptname Chronicle:Package:Shepherd:LoadDetector extends ReferenceAlias

Chronicle:Package:Shepherd Property MyShepherd Auto Const Mandatory

Event OnPlayerLoadGame()
	MyShepherd.gameLoaded()
EndEvent
