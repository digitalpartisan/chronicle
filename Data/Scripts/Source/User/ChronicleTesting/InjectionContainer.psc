Scriptname ChronicleTesting:InjectionContainer extends ObjectReference

FormList Property ChronicleTestingInjectionContainerContents Auto Const Mandatory
Int Property AmountToAdd = 1 Auto Const

Function setContents()
	Reset()
	Int iCounter = 0
	while (iCounter < ChronicleTestingInjectionContainerContents.GetSize())
		AddItem(ChronicleTestingInjectionContainerContents.GetAt(iCounter), AmountToAdd)
		iCounter += 1
	endWhile
EndFunction
