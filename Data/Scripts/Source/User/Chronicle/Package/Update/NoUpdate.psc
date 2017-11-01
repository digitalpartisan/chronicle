Scriptname Chronicle:Package:Update:NoUpdate extends Chronicle:Package:Update
{Attach this script to any version which does not have update logic to run.
This is important because individual version updates needs to start and stop their quest explicitly because the package doing the update will expect to watch for the associated events.
Some entity must be attached to the associated quest object in order to stop the update so that the rest of the update chain can continue.}

Event OnQuestInit()
	Stop() ; There's no update, so just immediately stop in order for future updates to be allowed to run.
EndEvent
