Scriptname Chronicle:Package:Shepherd:LoadDetector extends ReferenceAlias
{This script attaches to an alias on the Shepherd's quest object which points to the player actor.  Used to handle game load events for the shepherd it points to.}

Chronicle:Package:Shepherd Property MyShepherd Auto Const Mandatory

Event OnPlayerLoadGame()
	MyShepherd.gameLoaded()
EndEvent
