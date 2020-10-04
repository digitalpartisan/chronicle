Scriptname Chronicle:Package:Handler extends DynamicTerminal:Basic Conditional
{Using this script requires the Dynamic Terminal library.  You do not need to use this functionality to make use of most of Chronicle's features.
This script is used to display information about a package in a terminal as well as provide options such as uninstalling it should that be possible.
For examples of how to apply this script, reference the Chronicle Testing plugin.}

Message Property InvalidPackageMessage Auto Const Mandatory
{The message to display in the terminal if an invalid package is specified.}
Chronicle:Package:CustomBehavior:Paginator Property CustomizationPaginator Auto Const
{Optional paginator object when the terminal displaying this handler must paginate the customization options of this package.}
Chronicle:Package:CustomBehavior:List Property CustomizationList Auto Const
{Optional list object to assist in paginating the custom behaviors on this package.}
InjectTec:Integrator:ChronicleBehavior:Search Property IntegratorSearcher Auto Const
{Optional integrator search object to assist with locating one and only one Third-Party integration set on this package.}
InjectTec:Integrator:Paginator Property IntegratorPaginator Auto Const
{Optional paginator object to assist with paginating third-party integrations.}
DynamicTerminal:ListWrapper:FormList:Dynamic Property IntegratorList Auto Const
{Optional list wrapper to assist with paginator third-party integration options.}

Bool bValid = false Conditional ; whether or not there's a valid Package to handle
Bool bCanInstall = false Conditional ; whether or not the package can be installed
Bool bCanUninstall = false Conditional ; whether or not the package can be uninstalled

Chronicle:Package packageRef = None

Bool Function isValid()
	return bValid
EndFunction

Bool Function canInstall()
	return bCanInstall
EndFunction

Bool Function canUninstall()
	return bCanUninstall
EndFunction

Chronicle:Package Function getPackage()
	return packageRef
EndFunction

Function setPackage(Chronicle:Package newPackageRef)
	Chronicle:Package:Logger.handlerReceivedPackage(self, newPackageRef)
	packageRef = newPackageRef
	refreshStatus()
EndFunction

Function refreshStatus()
	bValid = false 
	bCanInstall = false
	bCanUninstall = false
	
	Chronicle:Package myPackage = getPackage()
	bValid = (None != myPackage)
	if (!isValid())
		return
	endif
	
	; this seems janky, and it is, but the canInstall() and canUninstall() logic on the package script isn't quite the same as whether or not a component can do things to a package
	bCanInstall = myPackage.getEngine().getInstaller().canActOnPackage(myPackage)
	bCanUninstall = myPackage.getEngine().getUninstaller().canActOnPackage(myPackage)
	
	Chronicle:Package:Logger.handlerStatus(self)
EndFunction

Chronicle:Package:CustomBehavior:Paginator Function getCustomizationPaginator()
	return CustomizationPaginator
EndFunction

Chronicle:Package:CustomBehavior:List Function getCustomizationList()
	if (!isValid() || !CustomizationList)
		return None
	endif

	CustomizationList.setPackage(getPackage())
	return CustomizationList
EndFunction

InjectTec:Integrator:ChronicleBehavior:Search Function getIntegratorSearcher()
	return IntegratorSearcher
EndFunction

InjectTec:Integrator:Paginator Function getIntegratorPaginator()
	return IntegratorPaginator
EndFunction

DynamicTerminal:ListWrapper:FormList:Dynamic Function getIntegratorList()
	if (!isValid() || !IntegratorList)
		return None
	endif

	InjectTec:Integrator:ChronicleBehavior integratorBehavior = getIntegratorSearcher().searchOneIntegrator(getPackage())
	if (!integratorBehavior)
		IntegratorList.setData(None)
		return IntegratorList
	endif

	IntegratorList.setData(integratorBehavior.Integrators)
	return IntegratorList
EndFunction

Function install()
	if (!isValid() || !canInstall())
		return
	endif
	
	getPackage().requestInstallation()
EndFunction

Function uninstall()
	if (!isValid() || !canUninstall())
		return
	endif
	
	getPackage().requestUninstallation()
EndFunction

Function paginateCustomBehaviors(ObjectReference akTerminalRef)
	DynamicTerminal:Paginator paginator = getCustomizationPaginator()
	Dynamicterminal:ListWrapper list = getCustomizationList()

	if (!paginator || !list)
		return
	endif

	paginator.init(akTerminalRef, list)
EndFunction

Function paginateThirdPartyIntegrations(ObjectReference akTerminalRef)
	InjectTec:Integrator:Paginator paginator = getIntegratorPaginator()
	DynamicTerminal:ListWrapper list = getIntegratorList()

	if (!paginator || !list)
		return
	endif

	paginator.init(akTerminalRef, list)
EndFunction

Function tokenReplacementLogic()
	if (isValid())
		replace("SelectedPackage", getPackage())
		replace("InstalledVersion", getPackage().getVersionSetting())
		replace("PackageDescription", getPackage().Description)
	else
		replace("SelectedPackage", InvalidPackageMessage) ; The terminal shouldn't show a replacement field in this case, but caution never hurt
		replace("InstalledVersion", None)
		replace("PackageDescription", None)
	endif
EndFunction
