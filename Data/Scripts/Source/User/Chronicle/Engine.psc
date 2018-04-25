Scriptname Chronicle:Engine extends Quest
{The central logic handler which controls all package management and collective installation / uninstallation behavior.
When attaching this to a Quest record, check the "Start Game Enabled" and the "Run Once" boxes.}

CustomEvent InstallerInitialized
CustomEvent InstallerDecommissioned

CustomEvent UpdaterInitialized
CustomEvent UpdaterDecommissioned

CustomEvent UninstallerInitialized
CustomEvent UninstallerDecommissioned

CustomEvent PostloadInitialized
CustomEvent PostloadDecommissioned

Group Environment
	Chronicle:Package:Core Property CorePackage Auto Const Mandatory
	{This is the core package for your plugin.  The engine needs to identify the core package for other packages in case they require a specific version.  The package this value holds is also unable to be installed under any circumstance.}
	Bool Property AIOMode = false Auto Const
	{When set to true, packages which are marked as being in the AIO release cannot be uninstalled individually.}
	Chronicle:Version:Static Property RequiredCompatibilityVersion Auto Const
	{Setting this value will require all non-core packages to have a CoreCompatibilityVersion property setting of at least this value in order to install or update.}
	Chronicle:Package:Container Property Packages Auto Const Mandatory
	{The list of packages for purposes of managing and displaying them.}
EndGroup

Group Components
	Chronicle:Engine:Component:Installer Property MyInstaller Auto Const Mandatory
	Chronicle:Engine:Component:Updater Property MyUpdater Auto Const Mandatory
	Chronicle:Engine:Component:Uninstaller Property MyUninstaller Auto Const Mandatory
	Chronicle:Engine:Component:Postload Property MyPostload Auto Const Mandatory
EndGroup

Group Messaging
	Message Property OldPackagesMessage Auto Const Mandatory
	{The fallback message when a package is too old (see isPackageTooOld()) but has no corresponding message of its own.}
	Message Property NewPackagesMessage Auto Const Mandatory
	{The fallback message when a package is too new (see isPackageTooNew()) but has no corresponding message of its own.}
	Message Property FatalErrorMessage Auto Const Mandatory
	{The message shown when this engine encounters a fatal error and must stop operating.}
	Message Property MissingPackagesMessage Auto Const Mandatory
	{The message shown when installed packages go missing, usually as a result of the plugins containing them being removed w/o the packages themselves being uninstalled.}
EndGroup

String sStateDormant = "Dormant" Const
String sStateSetup = "Setup" Const
String sStateActive = "Active" Const
String sStateTeardown = "Teardown" Const
String sStateDecommissioned = "Decommissioned" Const
String sStateFatalError = "FatalError" Const

; safeguards against spamming the player with these messages more than once per game load
Bool bShownTooOldMessage = false
Bool bShownTooNewMessage = false

Bool Function isAIOModeActive()
{Returns true when packages with their "InAIO" property set to true cannot be individually uninstalled and false otherwise.}
	return AIOMode
EndFunction

Chronicle:Package:Core Function getCorePackage()
	return CorePackage
EndFunction

Bool Function isCorePackage(Chronicle:Package packageRef)
	return getCorePackage() == packageRef
EndFunction

Bool Function isPackageTooOld(Chronicle:Package packageRef)
{Returns true if the given package's core compatibility version doesn't meet the minimum value required by this engine and false otherwise.
TLDR: The given package needs to be updated in order to remain compatible with the plugin using this library.}
	if (isCorePackage(packageRef)) ; Core package is never too old
		return false
	endif
	
	if (None == RequiredCompatibilityVersion) ; no enforcable minimum, so no such thing as too old
		return false
	endif
	
	Chronicle:Version packageCompatibilityVersion = packageRef.getCoreCompatibilityVersion()
	if (None == packageCompatibilityVersion) ; too old by default because the required value isn't even set (let alone large enough)
		return true
	endif
	
	return RequiredCompatibilityVersion.greaterThan(packageCompatibilityVersion)
EndFunction

Bool Function isPackageTooNew(Chronicle:Package packageRef)
{Returns true if the given package's core compatibility version is newer than the core package's version and false otherwise.
TLDR: the given package is intended to run against a newer version of the core package.  Core needs updated even if it is never "too old."}
	if (isCorePackage(packageRef)) ; Core package is never too new
		return false
	endif
	
	Chronicle:Version packageCompatibilityVersion = packageRef.getCoreCompatibilityVersion()
	if (None == packageCompatibilityVersion) ; package has no requirement, so any core version is acceptable
		return false
	endif
	
	return packageCompatibilityVersion.greaterThan(getCorePackage().getVersionSetting()) ; use the version setting in case not all core upgrades have taken place yet
EndFunction

Function notifyTooOld(Chronicle:Package:NonCore packageRef)
{Uses the package's default "too old" message and falls back to the generic engine message if needed.}
	if (packageRef.TooOldMessage)
		packageRef.TooOldMessage.Show()
	elseif (!bShownTooOldMessage)
		bShownTooOldMessage = true
		OldPackagesMessage.Show()
	endif
EndFunction

Function notifyTooNew(Chronicle:Package:NonCore packageRef)
{Uses the package's default "too new" message and falls back to the generic engine message if needed.}
	if (packageRef.TooNewMessage)
		packageRef.TooNewMessage.Show()
	elseif (!bShownTooNewMessage)
		bShownTooNewMessage = true
		NewPackagesMessage.Show()
	endif
EndFunction

Bool Function isPackageCompatible(Chronicle:Package packageRef)
{Returns true when the given package is neither "too old" or "too new" and false otherwise.  See isPackageTooOld() and isPackageTooNew() for details.}
	Chronicle:Package:NonCore nonCorePackage = packageRef as Chronicle:Package:NonCore
	
	if (nonCorePackage) ; only non-core packages can be considered too old or too new
		if (isPackageTooOld(nonCorePackage))
			Chronicle:Logger:Engine.logPackageTooOld(self, nonCorePackage)
			notifyTooOld(nonCorePackage)
			return false
		endif
		
		if (isPackageTooNew(nonCorePackage))
			Chronicle:Logger:Engine.logPackageTooNew(self, nonCorePackage)
			notifyTooNew(nonCorePackage)
			return false
		endif
	endif
	
	return true
EndFunction

Chronicle:Package:Container Function getPackages()
	return Packages
EndFunction

Chronicle:Engine:Component:Installer Function getInstaller()
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

Chronicle:Engine:Component:Updater Function getUpdater()
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

Chronicle:Engine:Component:Uninstaller Function getUninstaller()
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

Chronicle:Engine:Component:Postload Function getPostload()
	return MyPostload
EndFunction

Bool Function isPostloadReady()
	return getPostload().IsRunning()
EndFunction

Function initializePostload()
	getPostload().Start()
	SendCustomEvent("PostloadInitialized")
EndFunction

Function decommissionPostload()
	SendCustomEvent("PostloadDecommissioned")
	getPostload().Stop()
EndFunction

Function postloadIdled()

EndFunction

Bool Function processComponent(Chronicle:Engine:Component componentRef)
	if (componentRef.needsProcessing())
		componentRef.process()
		return true
	else
		return false
	endif
EndFunction

Function idleEventLogicLoop()
{This is half of the mutexing logic.  When a component goes idle during normal operation, this is the mechanism for determining whether or not something else needs to run.}
	if (!isIdle())
		return
	endif
	
	; these component calls are listed in the order of preference once the engine is initialized and a game is loaded.
	; the updates should run first since it is possible that ongoing problems are corrected therein.
	; the postload behavior should run last because it is the least likely to affect critical functionality and it does not need to be thread safe
	
	if (processComponent(getUpdater()))
		return
	endif
	
	if (processComponent(getInstaller()))
		return
	endif
	
	if (processComponent(getUninstaller()))
		return
	endif
	
	if (processComponent(getPostload()))
		return
	endif
EndFunction

Bool Function isActive()
	return false
EndFunction

Bool Function canInstall()
	return !IsRunning()
EndFunction

Function install()

EndFunction

Bool Function canRunUninstaller()
	return false
EndFunction

Bool Function canUninstall()
	return IsRunning() && isIdle()
EndFunction

Function uninstall()

EndFunction

Function triggerFatalError()
	GoToState(sStateFatalError)
EndFunction

Function gameLoaded()
	Chronicle:Logger:Engine.interceptedGameLoad(self)
	
	; only show the generic messages once per load
	bShownTooOldMessage = false
	bShownTooNewMessage = false
	
	if (isIdle()) ; if no component is running when the game loads, run the updater immediately.  Otherwise, flag it as needing to run so that it runs the first chance it gets
		getUpdater().process()
	else
		getUpdater().setNeedsProcessing()
	endif
	
	getPostload().setNeedsProcessing() ; the postloader always needs to run in this case, so make sure it gets taken care of when possible
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

Event Chronicle:Engine:Component.Idled(Chronicle:Engine:Component componentRef, Var[] args)
{This is the other half of the mutex logic.  When a component goes idle, the corresponding function is called and depending on the state the engine is in, different action can be taken.}
	if (getInstaller() == componentRef)
		Chronicle:Logger:Engine.logIdledInstaller(self)
		installerIdled()
	elseif (getUpdater() == componentRef)
		Chronicle:Logger:Engine.logIdledUpdater(self)
		updaterIdled()
	elseif (getUninstaller() == componentRef)
		Chronicle:Logger:Engine.logIdledUninstaller(self)
		uninstallerIdled()
	elseif (getPostload() == componentRef)
		Chronicle:Logger:Engine.logIdledPostload(self)
		postloadIdled()
	else
		Chronicle:Logger:Engine.logPhantomComponentIdled(self, componentRef)
		triggerFatalError()
	endif
EndEvent

Event Chronicle:Engine:Component.FatalError(Chronicle:Engine:Component componentRef, Var[] args)
	if (getInstaller() == componentRef || getUpdater() == componentRef || getUninstaller() == componentRef || getPostload() == componentRef)
		Chronicle:Logger:Engine.logComponentFatalError(self, componentRef)
	else
		Chronicle:Logger:Engine.logPhantomComponentFatalError(self, componentRef)
	endif
	
	triggerFatalError()
EndEvent

Function observeComponent(Chronicle:Engine:Component componentRef)
	Chronicle:Logger:Engine.logObservingComponent(self, componentRef)
	RegisterForCustomEvent(componentRef, "Idled")
	RegisterForCustomEvent(componentRef, "FatalError")
EndFunction

Function stopObservingComponent(Chronicle:Engine:Component componentRef)
	Chronicle:Logger:Engine.logStopObservingComponent(self, componentRef)
	UnregisterForCustomEvent(componentRef, "Idled")
	UnregisterForCustomEvent(componentRef, "FatalError")
EndFunction

Function observeComponents()
	observeComponent(getInstaller())
	observeComponent(getUpdater())
	observeComponent(getUninstaller())
	observeComponent(getPostload())
EndFunction

Function stopObservingComponents()
	stopObservingComponent(getInstaller())
	stopObservingComponent(getUpdater())
	stopObservingComponent(getUninstaller())
	stopObservingComponent(getPostload())
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
		if (getInstaller().isDormant() && getUpdater().isDormant() && getUninstaller().isDormant() && getPostload().isDormant())
			observeComponents()
			GoToState(sStateSetup)
		else
			Chronicle:Logger:Engine.logComponentsNotDormant(self)
			triggerFatalError()
		endif
	EndEvent
	
	Function install()
		Start()
	EndFunction
EndState

State Setup
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		getPackages().initialize()
		initializeInstaller()
	EndEvent
	
	Function installerIdled()
	{This is an example of what the engine might use the various component idled notifications for.}
		GoToState(sStateActive)
	EndFunction
EndState

State Active
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		initializeUpdater()
		initializeUninstaller()
		initializePostload()
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
	
	Function postloadIdled()
		idleEventLogicLoop()
	EndFunction
	
	Bool Function isActive()
		return true
	EndFunction
	
	Bool Function installPackage(Chronicle:Package packageRef)
	{Note how this works.  If nothing else is happening and the installer needs to run, then it gets to run.}
		Chronicle:Engine:Component:Installer installerRef = getInstaller()
		Bool bResult = queueForInstallLogic(packageRef)
	
		if (installerRef.needsProcessing() && isIdle())
			installerRef.process()
		endif
		
		return bResult
	EndFunction
	
	Bool Function uninstallPackage(Chronicle:Package packageRef)
	{Also note the same logic herein as installPackage().  If the engine is otherwise idle, then fire up the uninstaller right away since that allows the most rapid service of the package uninstallation.}
		Chronicle:Engine:Component:Uninstaller uninstallerRef = getUninstaller()
		Bool bResult = queueForUninstallLogic(packageRef)
		
		if (uninstallerRef.needsProcessing() && isIdle())
			uninstallerRef.process()
		endif
		
		return bResult
	EndFunction
	
	Function uninstall()
		if (canUninstall()) ; make sure that the engine isn't busy with anything prior to attempting to uninstall itself
			GoToState(sStateTeardown)
		endif
	EndFunction
EndState

State Teardown
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		if (isIdle())
			decommissionInstaller()
			decommissionUpdater()
			decommissionPostload()
			getUninstaller().process()
		endif
	EndEvent
	
	Bool Function canRunUninstaller()
		return getInstaller().IsStopped() && getUpdater().IsStopped() && getPostload().IsStopped() && getUninstaller().isIdle()
	EndFunction
	
	Function installerIdled()
		decommissionInstaller()
		if (canRunUninstaller())
			getUninstaller().process()
		endif
	EndFunction
	
	Function updaterIdled()
		decommissionUpdater()
		if (canRunUninstaller())
			getUninstaller().process()
		endif
	EndFunction
	
	Function postloadIdled()
		decommissionPostload()
		if (canRunUninstaller())
			getUninstaller().process()
		endif
	EndFunction
	
	Function uninstallerIdled()
		if (canRunUninstaller()) ; just in case there is some unknown edge-condition where the uninstaller is already running from having queued items (as opposed to uninstalling everything.)
			decommissionUninstaller()
			Stop()
		endif
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
	
	Bool Function canInstall()
		return false
	EndFunction
	
	Bool Function canUninstall()
		return false
	EndFunction
	
	Function gameLoaded()
		; no point any more
	EndFunction
EndState

State FatalError
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		
		stopObservingComponents()
		
		getInstaller().sendFatalError()
		getUpdater().sendFatalError()
		getUninstaller().sendFatalError()
		getPostload().sendFatalError()
		
		FatalErrorMessage
		Stop()
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
	
	Bool Function canInstall()
		return false
	EndFunction
EndState
