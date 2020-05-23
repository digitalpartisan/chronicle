Scriptname Chronicle:Engine:Handler extends DynamicTerminal:Basic Conditional
{Use of this script requires the latest version of the Dynamic Terminal library.  The handler is used to detect the state of an engine provided to setEngine() and to populate
some conditional variables so that a terminal concerned with said engine state can accurately display important information and options to the user.
This script and its behaviors are not sctrictly required to use Chronicle.
For examples of how to use this script in a terminal, reference the Chronicle Testing plugin provided with Chronicle.}

Message Property InvalidEngineMessage Auto Const Mandatory
{The message to display in the terminal if an invalid engine is specified.}

Bool bValid = false Conditional ; whether or not there's a valid Engine to handle
Bool bCanInstall = false Conditional ; whether or not the engine can be started
Bool bCanUninstall = false Conditional ; whether or not the engine can be stopped
Bool bActive = false Conditional ; whether or not the engine has completed setup but is not shutting down

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

Bool Function isActive()
	return bActive
EndFunction

Chronicle:Engine Function getEngine()
	return EngineRef
EndFunction

Function setEngine(Chronicle:Engine newEngineRef)
	Chronicle:Engine:Logger.handlerReceivedEngine(self, newEngineRef)
	EngineRef = newEngineRef
	refreshStatus()
EndFunction

Function clearStatus()
	bValid = false
	bCanInstall = false
	bCanUninstall = false
EndFunction

Function setStatus()
	Chronicle:Engine myEngine = getEngine()
	bCanInstall = myEngine.canInstall()
	bCanUninstall = myEngine.canUninstall()
	bActive = myEngine.isActive()
EndFunction

Function refreshStatus()
	clearStatus()

	Chronicle:Engine myEngine = getEngine()
	bValid = (None != myEngine)
	if (isValid())
		setStatus()
	endif
	
	Chronicle:Engine:Logger.handlerStatus(self)
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
