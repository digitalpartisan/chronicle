Scriptname Chronicle:Engine extends Quest
{The central logic handler which controls all package management and collective installation / uninstallation behavior.}

CustomEvent InstallerInitialized
CustomEvent InstallerDecommissioned

CustomEvent UpdaterInitialized
CustomEvent UpdaterDecommissioned

CustomEvent UninstallerInitialized
CustomEvent UninstallerDecommissioned

Group Environment
	Chronicle:Package:Local Property CorePackage Auto Const Mandatory
	{This is the core package for your plugin.  The engine needs to identify the core package for other packages in case they require a specific version.  The package this value holds is also unable to be installed under any circumstance.}
	Bool Property AIOMode = false Auto Const
	{When set to true, packages which are marked as being in the AIO release cannot be uninstalled at any point.}
	Chronicle:Version:Static Property MinimumRequiredCoreVersion Auto Const
	{The minimum core version (i.e. the version of the core package}
	Chronicle:PackageContainer Property Packages Auto Const Mandatory
	{The list of packages for purposes of managing and displaying them.}
EndGroup

Group Components
	Chronicle:EngineComponent:Installer Property MyInstaller Auto Const Mandatory
	Chronicle:EngineComponent:Updater Property MyUpdater Auto Const Mandatory
	Chronicle:EngineComponent:Uninstaller Property MyUninstaller Auto Const Mandatory
EndGroup

Group Messaging
	Message Property OldPackagesMessage Auto Const Mandatory
	Message Property NewPackagesMessage Auto Const Mandatory
	Message Property FatalErrorMessage Auto Const Mandatory
	Message Property MissingPackagesMessage Auto Const Mandatory
EndGroup

String sStateDormant = "Dormant" Const
String sStateSetup = "Setup" Const
String sStateActive = "Active" Const
String sStateTeardown = "Teardown" Const
String sStateDecommissioned = "Decommissioned" Const
String sStateFatalError = "FatalError" Const

Bool Function isAIOModeActive()
	return AIOMode
EndFunction

Chronicle:Package:Local Function getCorePackage()
	return CorePackage
EndFunction

Bool Function isCorePackage(Chronicle:Package packageRef)
	return getCorePackage() == packageRef
EndFunction

Chronicle:PackageContainer Function getPackages()
	return Packages
EndFunction

Chronicle:EngineComponent:Installer Function getInstaller()
	return MyInstaller
EndFunction

Bool Function isInstallerReady()
	return getInstaller().IsRunning()
EndFunction

Function initializeInstaller()
	getInstaller().Start()
	SendCustomEvent("InstallerInitialized")
EndFunction

Function decommissionInstaller()
	SendCustomEvent("InstallerDecommissioned")
	getInstaller().Stop()
EndFunction

Function installerIdled()
	
EndFunction

Chronicle:EngineComponent:Updater Function getUpdater()
	return MyUpdater
EndFunction

Bool Function isUpdaterReady()
	return getUpdater().IsRunning()
EndFunction

Function initializeUpdater()
	getUpdater().Start()
	SendCustomEvent("UpdaterInitialized")
EndFunction

Function decommissionUpdater()
	SendCustomEvent("UpdaterDecommissioned")
	getUpdater().Stop()
EndFunction

Function updaterIdled()

EndFunction

Chronicle:EngineComponent:Uninstaller Function getUninstaller()
	return MyUninstaller
EndFunction

Bool Function isUninstallerReady()
	return getUninstaller().IsRunning()
EndFunction

Function initializeUninstaller()
	getUninstaller().Start()
	SendCustomEvent("UninstallerInitialized")
EndFunction

Function decommissionUninstaller()
	SendCustomEvent("UninstallerDecommissioned")
	getUninstaller().Stop()
EndFunction

Function uninstallerIdled()

EndFunction

Bool Function processComponent(Chronicle:EngineComponent componentRef)
	if (componentRef.needsProcessing())
		componentRef.process()
	else
		return false
	endif
EndFunction

Function idleEventLogicLoop()
	if (!isIdle())
		return
	endif
	
	if (processComponent(getUpdater()))
		return
	endif
	
	if (processComponent(getInstaller()))
		return
	endif
	
	if (processComponent(getUninstaller()))
		return
	endif
EndFunction

Bool Function canUninstall()
	return isIdle()
EndFunction

Function uninstall()
	
EndFunction

Function triggerFatalError()
	GoToState(sStateFatalError)
EndFunction

Function gameLoaded()
	Chronicle:Logger:Engine.interceptedGameLoad(self)
	
	if (!Packages.passesIntegrityCheck())
		; log message
		MissingPackagesMessage.Show()
		triggerFatalError()
	endif
	
	if (isIdle())
		getUpdater().process()
	else
		getUpdater().setNeedsProcessing()
	endif
EndFunction

Bool Function queueForInstallLogic(Chronicle:Package packageRef)
	return getInstaller().queuePackage(packageRef)
EndFunction

Bool Function installPackage(Chronicle:Package packageRef)
	return queueForInstallLogic(packageRef)
EndFunction

Bool Function queueForUninstallLogic(Chronicle:Package packageRef)
	return getUninstaller().queuePackage(packageRef)
EndFunction

Bool Function uninstallPackage(Chronicle:Package packageRef)
	return queueForUninstallLogic(packageRef)
EndFunction

Bool Function isIdle()
	return getInstaller().isIdle() && getUpdater().isIdle() && getUninstaller().isIdle()
EndFunction

Event Chronicle:EngineComponent.Idled(Chronicle:EngineComponent componentRef, Var[] args)
	if (getInstaller() == componentRef)
		Chronicle:Logger:Engine.logIdledInstaller(self)
		installerIdled()
	elseif (getUpdater() == componentRef)
		Chronicle:Logger:Engine.logIdledUpdater(self)
		updaterIdled()
	elseif (getUninstaller() == componentRef)
		Chronicle:Logger:Engine.logIdledUninstaller(self)
		uninstallerIdled()
	else
		Chronicle:Logger:Engine.logPhantomComponentIdled(self, componentRef)
		triggerFatalError()
	endif
EndEvent

Event Chronicle:EngineComponent.FatalError(Chronicle:EngineComponent componentRef, Var[] args)
	if (getInstaller() == componentRef || getUpdater() == componentRef || getUninstaller() == componentRef)
		Chronicle:Logger:Engine.logComponentFatalError(self, componentRef)
	else
		Chronicle:Logger:Engine.logPhantomComponentFatalError(self, componentRef)
	endif
	
	triggerFatalError()
EndEvent

Function observeComponent(Chronicle:EngineComponent componentRef)
	Chronicle:Logger:Engine.logObservingComponent(self, componentRef)
	RegisterForCustomEvent(componentRef, "Idled")
	RegisterForCustomEvent(componentRef, "FatalError")
EndFunction

Function stopObservingComponent(Chronicle:EngineComponent componentRef)
	Chronicle:Logger:Engine.logStopObservingComponent(self, componentRef)
	UnregisterForCustomEvent(componentRef, "Idled")
	UnregisterForCustomEvent(componentRef, "FatalError")
EndFunction

Function observeComponents()
	observeComponent(getInstaller())
	observeComponent(getUpdater())
	observeComponent(getUninstaller())
EndFunction

Function stopObservingComponents()
	stopObservingComponent(getInstaller())
	stopObservingComponent(getUpdater())
	stopObservingComponent(getUninstaller())
EndFunction

Event OnQuestInit()
	Chronicle:Logger.logInvalidStartupAttempt(self)
	triggerFatalError()
EndEvent

Event OnQuestShutdown()
	Chronicle:Logger.logInvalidShutdownAttempt(self)
	triggerFatalError()
EndEvent

Auto State Dormant
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent

	Event OnQuestInit()
		if (getInstaller().isDormant() && getUpdater().isDormant() && getUninstaller().isDormant())
			observeComponents()
			GoToState(sStateSetup)
		else
			Chronicle:Logger:Engine.logComponentsNotDormant(self)
			triggerFatalError()
		endif
	EndEvent
EndState

State Setup
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		initializeInstaller()
	EndEvent
	
	Function installerIdled()
		GoToState(sStateActive)
	EndFunction
EndState

State Active
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		initializeUpdater()
		initializeUninstaller()
	EndEvent
	
	Function installerIdled()
		idleEventLogicLoop()
	EndFunction
	
	Function updaterIdled()
		idleEventLogicLoop()
	EndFunction
	
	Function uninstallerIdled()
		idleEventLogicLoop()
	EndFunction
	
	Bool Function installPackage(Chronicle:Package packageRef)
		Chronicle:EngineComponent:Installer installerRef = getInstaller()
		Bool bResult = queueForInstallLogic(packageRef)
	
		if (installerRef.needsProcessing() && isIdle())
			installerRef.process()
		endif
		
		return bResult
	EndFunction
	
	Bool Function uninstallPackage(Chronicle:Package packageRef)
		Chronicle:EngineComponent:Uninstaller uninstallerRef = getUninstaller()
		Bool bResult = queueForUninstallLogic(packageRef)
	
		if (uninstallerRef.needsProcessing() && isIdle())
			uninstallerRef.process()
		endif
		
		return bResult
	EndFunction
	
	Function uninstall()
		GoToState(sStateTeardown)
	EndFunction
EndState

State Teardown
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		if (isIdle())
			decommissionInstaller()
			decommissionUpdater()
			getUninstaller().process()
		endif
	EndEvent
	
	Bool Function isIdle()
		return getInstaller().IsStopped() && getUpdater().IsStopped() && getUninstaller().isIdle()
	EndFunction
	
	Function installerIdled()
		decommissionInstaller()
		if (isIdle())
			getUninstaller().process()
		endif
	EndFunction
	
	Function updaterIdled()
		decommissionUpdater()
		if (isIdle())
			getUninstaller().process()
		endif
	EndFunction
	
	Function uninstallerIdled()
		decommissionUninstaller()
		Stop()
	EndFunction
	
	Bool Function installPackage(Chronicle:Package packageRef)
		return false
	EndFunction
	
	Bool Function uninstallPackage(Chronicle:Package packageRef)
		return false
	EndFunction
	
	Event OnQuestShutdown()
		GoToState(sStateDecommissioned)
	EndEvent
EndState

State Decommissioned
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		stopObservingComponents()
	EndEvent
	
	Bool Function installPackage(Chronicle:Package packageRef)
		return false
	EndFunction

	Bool Function uninstallPackage(Chronicle:Package packageRef)
		return false
	EndFunction
EndState

State FatalError
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		
		stopObservingComponents()
		
		getInstaller().triggerFatalError()
		getUpdater().triggerFatalError()
		getUninstaller().triggerFatalError()
		
		Stop()
		
		FatalErrorMessage.Show()
	EndEvent
	
	Function triggerFatalError()
		; prevents junk log messages and state changes
	EndFunction
	
	Event OnQuestShutdown()
		; prevents junk log messages and state changes
	EndEvent
	
	Bool Function installPackage(Chronicle:Package packageRef)
		return false
	EndFunction

	Bool Function uninstallPackage(Chronicle:Package packageRef)
		return false
	EndFunction
	
	Function gameLoaded()
		; no point in responding to this
	EndFunction
EndState
