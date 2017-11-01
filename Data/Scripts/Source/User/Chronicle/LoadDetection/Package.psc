Scriptname Chronicle:LoadDetection:Package extends ReferenceAlias

Chronicle:Package:Shepherd Property MyShepherd Auto Const Mandatory

Event OnPlayerLoadGame()
	MyShepherd.gameLoaded()
EndEvent
