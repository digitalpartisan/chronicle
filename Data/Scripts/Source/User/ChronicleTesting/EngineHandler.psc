Scriptname ChronicleTesting:EngineHandler extends DynamicTerminal:Basic Conditional

Message Property ChronicleTestingEngineHandlerNoEngine Auto Const Mandatory

Chronicle:Engine myEngine = None ; the engine to act on

Bool bValid = false Conditional
Bool bRunning = false Conditional

Chronicle:Engine Function getEngine()
	return myEngine
EndFunction

Function setEngine(Chronicle:Engine engineRef)
	myEngine = engineRef
	bValid = None != engineRef
	if (bValid)
		bRunning = engineRef.IsRunning()
	else
		bRunning = false
	endif
EndFunction

Function startEngine()
	if (bValid)
		myEngine.Start()
	endif
EndFunction

Function stopEngine()
	if (bValid)
		myEngine.Stop()
	endif
EndFunction

Function tokenReplacementLogic()
	Chronicle:Engine engineRef = getEngine()
	if (engineRef)
		replace("SelectedEngine", engineRef)
	else
		replace("SelectedEngine", ChronicleTestingEngineHandlerNoEngine) ; The terminal shouldn't show a replacement field in this case, but caution never hurt
	endif
EndFunction
