Scriptname Chronicle:Package extends Quest Hidden
{This is the main package logic.}

CustomEvent InstallComplete
CustomEvent InstallFailed

CustomEvent UpdateComplete
CustomEvent UpdateFailed

CustomEvent UninstallComplete
CustomEvent UninstallFailed

Group Version
	Chronicle:Version:Stored Property CurrentVersion Auto Const Mandatory
	{The current version of the package.}
	Chronicle:Version:Static Property VersionSetting Auto Const Mandatory
	{The version that this package should attempt to become.}
EndGroup

Group Messaging
	Message Property Description Auto Const Mandatory
	{Used to explain the functionality of this package to the user when it is needed.  Required because this information may matter to the user.}
	Message Property InstallationMessage Auto Const
	{Shown to the player when this package is installed, provided it is set.}
	Message Property UpdateMessage Auto Const
	{Shown to the player when this package is updated, provided it is set.}
	Message Property UninstallationMessage Auto Const
	{Shown to the player when this package is uninstalled, provided it is set.}
	Message Property FatalErrorMessage Auto Const
	{Used when something catastrophic happens so that the user knows the package has shut itself down, provided it is set.}
EndGroup

Chronicle:Version:Static nextVersion = None

String sStateDormant = "Dormant" Const
String sStateSetup = "Setup" Const
String sStateIdle = "Idle" Const
String sStateUpdating = "Updating" Const
String sStateTeardown = "Teardown" Const
String sStateDecommissioned = "Decommissioned" Const
String sStateFatalError = "FatalError" Const

Bool Function isEngineAccessible()
{Override this in child scripts to implement the correct behavior.}
	Chronicle:Logger.logBehaviorUndefined(self, "isEngineAccessible()")
	return false
EndFunction

Chronicle:Engine Function getEngine()
{Override this in child scripts to implement the correct behavior.}
	Chronicle:Logger.logBehaviorUndefined(self, "getEngine()")
	return None
EndFunction

Bool Function isInAIO()
{Override this in child scripts to implement the correct behavior.}
	Chronicle:Logger.logBehaviorUndefined(self, "isInAIO()")
	return false
EndFunction

Chronicle:Version:Stored Function getCurrentVersion()
	return CurrentVersion
EndFunction

Chronicle:Version:Static Function getVersionSetting()
	return VersionSetting
EndFunction

Chronicle:Version Function getCoreCompatibilityVersion()
{Override this in child scripts to implement the correct behavior.}
	Chronicle:Logger.logBehaviorUndefined(self, "getEngine()")
	return None
EndFunction

Bool Function hasValidVersionSetting()
	if (!getVersionSetting().validate())
		Chronicle:Logger:Package.logInvalidVersion(self)
		return false
	endif
	
	return true
EndFunction

Bool Function isInstalled()
	return getCurrentVersion().validate() && isEngineAccessible() && getEngine().getPackages().hasPackage(self)
EndFunction

Bool Function meetsCustomInstallationConditions()
{Override this function in child scripts to specify conditions under which this package should be installed.}
	return true
EndFunction

Bool Function customInstallationBehavior()
{Override this function in child scripts to specify unique installation tasks.}
	return true
EndFunction

Bool Function customPostloadBehavior()
{Override this function in child scripts to specify unique post-load tasks.}
	return true
EndFunction

Bool Function customUninstallationBehavior()
{Override this function in child scripts to specify unique uninstallation tasks.}
	return true
EndFunction

Bool Function canInstallLogic()
	return hasValidVersionSetting() && isEngineAccessible() && !isInstalled() && meetsCustomInstallationConditions()
EndFunction

Bool Function canInstall()
	return canInstallLogic()
EndFunction

Function sendInstallComplete()
	SendCustomEvent("InstallComplete")
	GoToState(sStateIdle)
EndFunction

Function sendInstallFailed()
	SendCustomEvent("InstallFailed")
	GoToState(sStateFatalError)
EndFunction

Bool Function canUninstall()
	return false
EndFunction

Bool Function isCurrent()
	return isInstalled() && getCurrentVersion().equals(getVersionSetting())
EndFunction

Bool Function requestInstallation()
	return false
EndFunction

Bool Function requestUninstallation()
	return false
EndFunction

Bool Function canUpdate()
	return false
EndFunction

Function update()

EndFunction

Function observeNextUpdate()
	Chronicle:Package:Update targetUpdate = nextVersion.getUpdate()
	
	RegisterForCustomEvent(targetUpdate, "Success")
	RegisterForCustomEvent(targetUpdate, "Failure")
	
	Chronicle:Logger:Package.logObservingUpdate(self, targetUpdate)
EndFunction

Function stopObservingNextUpdate()
	Chronicle:Package:Update targetUpdate = nextVersion.getUpdate()
	
	UnregisterForCustomEvent(targetUpdate, "Success")
	UnregisterForCustomEvent(targetUpdate, "Failure")
	
	Chronicle:Logger:Package.logStopObservingUpdate(self, targetUpdate)
EndFunction

Bool Function identifyNextVersion()
	return false
EndFunction

Function attemptNextUpdate()
	
EndFunction

Function sendUpdateComplete()
	SendCustomEvent("UpdateComplete")
	GoToState(sStateIdle)
EndFunction

Function sendUpdateFailed()
	SendCustomEvent("UpdateFailed")
	GoToState(sStateFatalError)
EndFunction

Bool Function isIdle()
	return false
EndFunction

Event Chronicle:Package:Update.Success(Chronicle:Package:Update updateRef, Var[] args)
	stopObservingNextUpdate()
	
	Chronicle:Package:Update nextUpdate = nextVersion.getUpdate()
	if (updateRef == nextUpdate)
		CurrentVersion.setTo(nextVersion) ; eevry time an update is complete, make sure the package's current version is correct so that calls to isCurrent() get correct results
		nextVersion = nextVersion.getNextVersion()
		
		attemptNextUpdate()
	else
		Chronicle:Logger:Package.logPhantomResponse(self, nextUpdate, updateRef)
		sendUpdateFailed()
	endif
EndEvent

Event Chronicle:Package:Update.Failure(Chronicle:Package:Update updateRef, Var[] args)
	stopObservingNextUpdate()
	
	Chronicle:Package:Update nextUpdate = nextVersion.getUpdate()
	if (updateRef != nextUpdate)
		Chronicle:Logger:Package.logPhantomResponse(self, nextUpdate, updateRef)
	endif
	
	sendUpdateFailed()
EndEvent

Event OnQuestInit()
	Chronicle:Logger.logInvalidStartupAttempt(self)
	GoToState(sStateFatalError)
EndEvent

Event OnQuestShutdown()
	Chronicle:Logger.logInvalidShutdownAttempt(self)
	GoToState(sStateFatalError)
EndEvent

Auto State Dormant
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
	
	Bool Function requestInstallation()
		if (getEngine().installPackage(self))
			return true
		else
			Chronicle:Logger:Package.logCannotInstall(self)
			return false
		endif
	EndFunction
	
	Event OnQuestInit()
		GoToState(sStateSetup)
	EndEvent
EndState

State Setup
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		
		if (!canInstall())
			Chronicle:Logger:Package.logSetupStateUnableToInstall(self)
			sendInstallFailed()
			return
		endif
		
		if (!customInstallationBehavior())
			Chronicle:Logger:Package.logCustomInstallBehaviorFailed(self)
			sendInstallFailed()
			return
		endif
		
		if (!getCurrentVersion().setTo(getVersionSetting()))
			Chronicle:Logger:Package.logCouldNotInitializeCurrentVersion(self)
			sendInstallFailed()
			return
		endif
		
		if (InstallationMessage)
			InstallationMessage.Show()
		endif
		sendInstallComplete()
	EndEvent
EndState

State Idle
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
	
	Bool Function canUpdate()
		return isInstalled() && !isCurrent()
	EndFunction
	
	Bool Function isIdle()
		return true
	EndFunction
	
	Function update()
		GoToState(sStateUpdating)
	EndFunction
	
	Bool Function canUninstall()
		return true
	EndFunction
	
	Event OnQuestShutdown()
		GoToState(sStateFatalError)
	EndEvent
	
	Bool Function requestUninstallation()
		if (getEngine().uninstallPackage(self))
			return true
		else
			Chronicle:Logger:Package.logCannotUninstall(self)
			return false
		endif
	EndFunction
EndState

State Updating
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		if (identifyNextVersion())
			attemptNextUpdate()
		else
			SendCustomEvent("UpdateFailed")
			GoToState(sStateFatalError)
		endif
	EndEvent
	
	Bool Function identifyNextVersion()
		nextVersion = None
		
		Chronicle:Version:Stored current = getCurrentVersion()
		Chronicle:Version:Static currentMatch = getVersionSetting()
		
		while (currentMatch && currentMatch.greaterThan(current))
			currentMatch = currentMatch.getPreviousVersion()
		endwhile
		
		if (!currentMatch || currentMatch.lessThan(current))
			Chronicle:Logger:Package.versionConfigurationError(self)
			return false
		endif
		
		nextVersion = currentMatch.getNextVersion() ; because we don't need to run the update that puts this package at the current version, but we do need to run the next one
		Chronicle:Logger:Package.identifiedNextVersion(self, nextVersion)
		
		return true
	EndFunction

	Function attemptNextUpdate()
		if (!nextVersion || nextVersion.greaterThan(getVersionSetting())) ; this makes sure any known version updates past the current setting for the package do not run yet
			Chronicle:Package:Update nextUpdate = None
			
			if (isCurrent()) ; the whole reason for running updates is that the package's version is not current with its setting.  If that hasn't been fixed, updating failed by definition
				if (UpdateMessage)
					UpdateMessage.Show()
				endif
				
				sendUpdateComplete()
			else
				sendUpdateFailed()
			endif
			
			return
		endif
		
		if (!nextVersion.getUpdate())
			Chronicle:Logger:Version.logNoUpdate(nextVersion)
			sendUpdateFailed()
		endif
		
		observeNextUpdate()
		nextVersion.getUpdate().Start()
		
	EndFunction
EndState

State Teardown
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		
		if (customUninstallationBehavior())
			getCurrentVersion().invalidate()
			SendCustomEvent("UninstallComplete")
			if (UninstallationMessage)
				UninstallationMessage.Show()
			endif
			Stop()
		else
			SendCustomEvent("UninstallFailed")
			GoToState(sStateFatalError)
		endif
	EndEvent
	
	Event OnQuestShutdown()
		GoToState(sStateDecommissioned)
	EndEvent
EndState

State Decommissioned
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
EndState

State FatalError
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		if (FatalErrorMessage)
			FatalErrorMessage.Show()
		endif
	EndEvent
	
	Event OnQuestInit()
	
	EndEvent
	
	Event OnQuestShutdown()
	
	EndEvent
EndState
