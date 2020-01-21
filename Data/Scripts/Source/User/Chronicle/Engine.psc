Scriptname Chronicle:Engine extends Quest
{The central logic handler which controls all package management and collective installation / uninstallation behavior.
When attaching this to a Quest record, check the "Start Game Enabled" and the "Run Once" boxes.
The engine is the "go to" source of all information about the environment and environmental settings such as which package is the core,
the entire package set, the various components that do work on the package list, etc.  All requests to install or uninstall packages come through
the engine and the engine is responsible for handling game load events as well as communicating to individual components when they may and may not
execute or if a fatal error has occurred somewhere in some component's process.}

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
{Because every component needs this information, the engine is the object of record for the state of the overall system.}
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
{This function is called by event handlers to inform the engine that the installer component has concluded its behavior.  See its definition in various states for an understanding of what this might mean.}
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
{This is similar to installerIdled() except that it refers to the updater component rather than the installer.}
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
{This is similar to installerIdled() except that it refers to the uninstaller component rather than the installer.}
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
{This is similar to installerIdled() except that it refers to the postload component rather than the installer.}
EndFunction

Bool Function processComponent(Chronicle:Engine:Component componentRef)
{This seems trivially simple, except that if a particular component needs to be processed, the boolean result informs the calling function that no other component should be considered to run while componentRef is not idle.}
	if (componentRef.needsProcessing())
		componentRef.process()
		return true
	else
		return false
	endif
EndFunction

Function idleEventLogicLoop()
{This is half of the mutexing logic.  When a component goes idle during normal operation, this is the mechanism for determining whether or not something else needs to run.
Note the use of processComponent() and the order in which the components are examined.  There's a method to the madness.  See comments in the function itself for details.}
	if (!isIdle())
		return
	endif
	
	; Because the updates can contain bugfixes, they should run first.  Those bugfixes may be critical to operating every other component correctly.
	if (processComponent(getUpdater()))
		return
	endif
	
	; Really, the uninstaller and the installer are tied for priority in this process, so the preference was given to installing new packages and enabling their functionality first
	; since that may make everything else work a little bit better.
	if (processComponent(getInstaller()))
		return
	endif
	
	if (processComponent(getUninstaller()))
		return
	endif
	
	; The installed packages' post-load behaviors should only run once any packages to be uninstalled are removed so that there is less work to do at this phase of the logic loop.
	; Admittedly, the timing isn't critical, but it's practical to make sure as little work is done as possible because that means there are fewer opportunities for various failure events to occur.
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
{This is the "start it up" function that is called when the quest object housing the engine is started.
This should almost always happen automatically because the "Start Game Enabled" box should be checked unless there is a good reason not to do so.}
EndFunction

Bool Function canRunUninstaller()
	return false
EndFunction

Bool Function canUninstall()
	return IsRunning() && isIdle()
EndFunction

Function uninstall()
{This is the "shut it down" function called to remove all packages and cause the engine to stop functioning.}
EndFunction

Function triggerFatalError()
	GoToState(sStateFatalError)
EndFunction

Function gameLoaded()
{This is what happens when the game is loaded.  The most important thing done here is to force the updater component to require processing so that packages updates happen as soon as possible.
The postload component is also forced to run (when able) so that packges have an opportunity to examine what may or may not have changed in the game since the last time it was loaded.
Strictly speaking, this should have been defined as empty here and these contents would be applicable only to the Active state, but it is possible for a mod author to retrofit their mod
with Chronicle and a game load event might need to run on a quest object which has already been started and has no opportunity to move through the normal setup process.}
	Chronicle:Logger:Engine.interceptedGameLoad(self)
	
	; only show the generic messages once per load
	bShownTooOldMessage = false
	bShownTooNewMessage = false

	getUpdater().setNeedsProcessing()
	getPostload().setNeedsProcessing()
    idleEventLogicLoop()
EndFunction

Bool Function queueForInstallLogic(Chronicle:Package packageRef)
	return getInstaller().queuePackage(packageRef)
EndFunction

Bool Function installPackage(Chronicle:Package packageRef)
{The function called when an outside entity (such as a package shepherd) wants to install a package.}
	return queueForInstallLogic(packageRef)
EndFunction

Bool Function queueForUninstallLogic(Chronicle:Package packageRef)
	return getUninstaller().queuePackage(packageRef)
EndFunction

Bool Function uninstallPackage(Chronicle:Package packageRef)
{This serves the same purpose as installPackage() except for uninstallation of packages.}
	return queueForUninstallLogic(packageRef)
EndFunction

Bool Function isIdle()
{Certain things (such as shutting down the entire engine) can only happen when nothing else is going on for thread safety reasons.
For details, search for calls to this function.}
	return getInstaller().isIdle() && getUpdater().isIdle() && getPostload().isIdle() && getUninstaller().isIdle()
EndFunction

Event Chronicle:Engine:Component.Idled(Chronicle:Engine:Component componentRef, Var[] args)
{This is the other half of the mutex logic.  When a component goes idle, the corresponding function is called and depending on the state the engine is in, different action can be taken.
For details regarding why this is important, see the various definitions of the component idled functions in the various states of this script.}
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

Auto State Dormant
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
	EndEvent
	
	Event OnQuestInit()
		; an engine cannot start up if any of the components is already operating
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
	{This is an example of what the engine might use the various component idled notifications for.  When the installer is done running for the first time, setup is done.}
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
	{Also note the same logic herein as installPackage().  If the engine is otherwise idle, then fire up the uninstaller right away since that allows the most rapid fulfillment of the package uninstallation request.}
		Chronicle:Engine:Component:Uninstaller uninstallerRef = getUninstaller()
		Bool bResult = queueForUninstallLogic(packageRef)
		
		if (uninstallerRef.needsProcessing() && isIdle())
			uninstallerRef.process()
		endif
		
		return bResult
	EndFunction
	
	Function uninstall()
		if (canUninstall()) ; make sure that the engine isn't busy with anything prior to attempting to shut itself down
			GoToState(sStateTeardown)
		endif
	EndFunction
EndState

State Teardown
	Event OnBeginState(String asOldState)
		Chronicle:Logger.logStateChange(self, asOldState)
		; strictly speaking, the logic in the active state should only progress to this point if the engine truly is idle,
		; but timing issues and race conditions could mess things up.  It's best to check before decommissioning components that might be running.
		if (isIdle())
			decommissionInstaller()
			decommissionUpdater()
			decommissionPostload()
			getUninstaller().process()
		endif
	EndEvent
	
	Bool Function canRunUninstaller()
	{This is a fallback to the logic in the OnBeginState() event so that any running components have an opportunity to correctly finish before the uninstaller is make to run.
	The uninstaller component needs to run last because once it is finished, teardown is over and any jobs left undone or requests left unfulfilled may do bad things to the player's save game file.}
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
	{In a teardown scenario, the uninstaller finishing its job means the engine can cease operation.  This is why all the interested redefinitions of various function are what they are in this state.}
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
		
		FatalErrorMessage.Show()
		Stop()
	EndEvent
	
	Function triggerFatalError()
		; prevents junk log messages and state changes
	EndFunction
	
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
