Scriptname Chronicle:Engine:Handler:Static extends Chronicle:Engine:Handler Conditional

Chronicle:Engine Property MyEngine Auto Const Mandatory

Function refreshStatus()
	setEngine(MyEngine)
	parent.refreshStatus()
EndFunction
