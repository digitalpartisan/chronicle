Scriptname Chronicle:Package extends Quest Hidden Conditional
{This is the main package logic.  When attaching this script to a quest object, do not check the }

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

Group Environment
	Bool Property InAIO = false Auto Const
	{Set this to true if this package will be included in some sort of All-in-One package so that it cannot be uninstalled.}
	Chronicle:Version:Static Property CoreCompatibilityVersion Auto Const
	{The minimum version of the Core package, if any, this package requires to function.  See the Chronicle:Engine script for details.}
EndGroup

Group Messaging
	Message Property InstallationMessage Auto Const
	{Shown to the player when this package is installed, provided it is set.}
	Message Property UpdateMessage Auto Const
	{Shown to the player when this package is updated, provided it is set.}
	Message Property UninstallationMessage Auto Const
	{Shown to the player when this package is uninstalled, provided it is set.}
	Message Property Description Auto Const Mandatory
	{Used to explain the functionality of this package to the user when it is needed.  Required because this option really should be available.}
	Message Property FatalErrorMessage Auto Const
	{Used when something catastrophic happens so that the user knows the package has shut itself down, provided it is set.}
	Message Property TooOldMessage Auto Const
	{The message displayed when this package's CoreCompatibilityVersion value is below the engine's required version.  I.e. what to tell the player when the mod providing this package isn't up to date.}
	Message Property TooNewMessage Auto Const
	{The message displayed when this package's CoreCompatibilityVersion value is higher than the Core Package's version setting.  I.e. what to tell the player when the mod providing the core package isn't up to date.}
EndGroup

Chronicle:Version:Static NextUpdate = None

String sStateDormant = "Dormant" Const
String sStateSetup = "Setup" Const
String sStateIdle = "Idle" Const
String sStateUpdating = "Updating" Const
String sStateTeardown = "Teardown" Const
String sStateDecommissioned = "Decommissioned" Const
String sStateFatalError = "FatalError" Const

Chronicle:Engine Function getEngine()
{Override this in child scripts to implement the correct behavior.}
	Chronicle:Logger.logBehaviorUndefined(self, "getEngine()")
	return None
EndFunction

Bool Function isInAIO()
	return InAIO
EndFunction

Chronicle:Version:Stored Function getCurrentVersion()
	return CurrentVersion
EndFunction

Chronicle:Version:Static Function getVersionSetting()
	return VersionSetting
EndFunction

Chronicle:Version Function getCoreCompatibilityVersion()
	return CoreCompatibilityVersion
EndFunction

Bool Function hasValidVersionSetting()
	if (!getVersionSetting().validate())
		Chronicle:Logger:Package.logInvalidVersion(self)
		return false
	endif
	
	return true
EndFunction

Bool Function isInstalled()
	return getCurrentVersion().validate() && getEngine().getPackages().hasPackage(self)
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
	return hasValidVersionSetting() && !isInstalled() && meetsCustomInstallationConditions() && getEngine().isPackageCompatible(self)
EndFunction

Bool Function canInstall()
	return canInstallLogic()
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

Function observeUpdate()
	RegisterForRemoteEvent(NextUpdate, "OnQuestShutdown")
EndFunction

Function stopObservingUpdate()
	UnregisterForRemoteEvent(NextUpdate, "OnQuestShutdown")
EndFunction

Bool Function identifyFirstUpdate()
	return false
EndFunction

Bool Function attemptUpdate()
	return false
EndFunction

Bool Function performUpdates()
	return false
EndFunction

Bool Function isIdle()
	return false
EndFunction

Event Quest.OnQuestShutdown(Quest questRef)
	
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
			SendCustomEvent("InstallFailed")
			GoToState(sStateFatalError)
			return
		endif
		
		if (!customInstallationBehavior())
			Chronicle:Logger:Package.logCustomInstallBehaviorFailed(self)
			SendCustomEvent("InstallFailed")
			GoToState(sStateFatalError)
			return
		endif
		
		if (!getCurrentVersion().setTo(getVersionSetting()))
			Chronicle:Logger:Package.logCouldNotInitializeCurrentVersion(self)
			SendCustomEvent("InstallFailed")
			GoToState(sStateFatalError)
			return
		endif
		
		if (InstallationMessage)
			InstallationMessage.Show()
		endif
		
		SendCustomEvent("InstallComplete")
		
		GoToState(sStateIdle)
	EndEvent
EndState

State Idle
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
	
	Bool Function canUpdate()
		return isInstalled() && !isCurrent() && getEngine().isPackageCompatible(self)
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
		if (identifyFirstUpdate())
			attemptUpdate()
		else
			GoToState(sStateFatalError)
		endif
	EndEvent
	
	Event Quest.OnQuestShutdown(Quest questRef)
		stopObservingUpdate()
		
		if (questRef == NextUpdate)
			CurrentVersion.setTo(NextUpdate)
			NextUpdate = NextUpdate.getNextVersion()
			attemptUpdate()
		else
			; error message to indicate unknown quest object reporting completion
			GoToState(sStateFatalError)
		endif
	EndEvent
	
	Bool Function identifyFirstUpdate()
		NextUpdate = None
		
		Chronicle:Version:Stored current = getCurrentVersion()
		Chronicle:Version:Static currentMatch = getVersionSetting()
		
		while (currentMatch && currentMatch.greaterThan(current))
			currentMatch = currentMatch.getPreviousVersion()
		endwhile
		
		if (!currentMatch || currentMatch.lessThan(current))
			; error log about configuration failure
			return false
		endif
		
		NextUpdate = currentMatch.getNextVersion() ; because we don't need to run the update that puts this package at the current version
		return true
	EndFunction

	Bool Function attemptUpdate()
		if (!NextUpdate || NextUpdate.greaterThan(getVersionSetting())) ;this makes sure any known version updates past the current setting for the package do not run yet
			NextUpdate = None
			
			if (isCurrent())
				SendCustomEvent("UpdateComplete")
				if (UpdateMessage)
					UpdateMessage.Show()
				endif
				GoToState(sStateIdle)
				return true
			else
				SendCustomEvent("UpdateFailed")
				return false
			endif
		endif
		
		NextUpdate = NextUpdate.getNextVersion()
		observeUpdate()
		NextUpdate.Start()
		
		return true
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
EndState
