Scriptname Chronicle:Engine:Component:Postload extends Chronicle:Engine:Component

String sStateProcessing = "Processing"

Function goToProcessingState()
	GoToState(sStateProcessing)
EndFunction

State Processing
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		logStatus()
		
		Chronicle:Package:Container packages = getEngine().getPackages()
		packages.rewind()
		
		while (packages.current())
			packages.current().customPostloadBehavior()
			packages.next()
		endWhile
		
		setToIdle()
	EndEvent
EndState
