Scriptname ChronicleTesting:CustomizationQuest extends Quest

Message Property StartMessage Auto Const Mandatory
Message Property EndMessage Auto Const Mandatory

Event OnQuestInit()
	StartMessage.Show()
EndEvent

Event OnQuestShutdown()
	EndMessage.Show()
EndEvent
