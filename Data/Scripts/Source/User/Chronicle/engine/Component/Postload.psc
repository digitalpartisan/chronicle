Scriptname Chronicle:Engine:Component:Postload extends Chronicle:Engine:Component
{When attaching this script to a quest record, do not check the "Start Game Enabled" box.}

String sStateProcessing = "Processing"

Function goToProcessingState()
	GoToState(sStateProcessing)
EndFunction

State Processing
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		
		Chronicle:Package:Container packages = getEngine().getPackages()
		Chronicle:package targetPackage = None
		packages.rewind()
		
		while (packages.current())
			targetPackage = packages.current()
			Chronicle:Logger:Engine:Component.logProcessingPackage(self, targetPackage)
			targetPackage.customPostloadBehavior()
			packages.next()
		endWhile
		
		setToIdle()
	EndEvent
EndState
