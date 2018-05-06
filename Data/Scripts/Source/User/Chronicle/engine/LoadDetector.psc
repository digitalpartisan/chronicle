Scriptname Chronicle:Engine:LoadDetector extends ReferenceAlias
{This script should be attached to an alias on the engine's quest record pointing to the player actor.  Used to detect game load events.}

Chronicle:Engine Property MyEngine Auto Const Mandatory
{The engine to inform of the game load event.}

Event OnPlayerLoadGame()
	MyEngine.gameLoaded()
EndEvent
