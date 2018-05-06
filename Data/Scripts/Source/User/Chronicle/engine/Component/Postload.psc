Scriptname Chronicle:Engine:Component:Postload extends Chronicle:Engine:Component
{This component is perhaps the most simple in that it does no event observation because it only iterates over the installed packages and calls their postload behavior.}

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
