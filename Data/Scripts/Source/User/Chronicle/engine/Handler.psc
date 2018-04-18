Scriptname Chronicle:Engine:Handler extends DynamicTerminal:Basic Conditional

Message Property InvalidEngineMessage Auto Const Mandatory
{The message to display in the terminal if an invalid engine is specified.}

Bool bValid = false Conditional ; whether or not there's a valid Engine to handle
Bool bCanInstall = false Conditional ; whether or not the engine can be started
Bool bCanUninstall = false Conditional ; whether or not the engine can be stopped

Chronicle:Engine EngineRef = None

Bool Function isValid()
	return bValid
EndFunction

Bool Function canInstall()
	return bCanInstall
EndFunction

Bool Function canUninstall()
	return bCanUninstall
EndFunction

Chronicle:Engine Function getEngine()
	return EngineRef
EndFunction

Function setEngine(Chronicle:Engine newEngineRef)
	Chronicle:Logger:Engine.handlerReceivedEngine(self, newEngineRef)
	EngineRef = newEngineRef
	refreshStatus()
EndFunction

Function refreshStatus()
	bValid = false
	bCanInstall = false
	bCanUninstall = false

	Chronicle:Engine myEngine = getEngine()
	bValid = (None != myEngine)
	if (!isValid())
		return
	endif
	
	bCanInstall = myEngine.canInstall()
	bCanUninstall = myEngine.canUninstall()
	
	Chronicle:Logger:Engine.handlerStatus(self)
EndFunction

Function install()
	if (!isValid() || !canInstall())
		return
	endif
	
	getEngine().install()
	
	refreshStatus()
EndFunction

Function uninstall()
	if (!isValid() || !canUninstall())
		return
	endif
	
	getEngine().uninstall()
	
	refreshStatus()
EndFunction

Function tokenReplacementLogic()
	if (isValid())
		replace("SelectedEngine", getEngine())
	else
		replace("SelectedEngine", InvalidEngineMessage) ; The terminal shouldn't show a replacement field in this case, but caution never hurt
	endif
EndFunction
