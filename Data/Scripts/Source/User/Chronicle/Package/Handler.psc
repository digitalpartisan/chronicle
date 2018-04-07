Scriptname Chronicle:Package:Handler extends DynamicTerminal:Basic Conditional

Message Property InvalidPackageMessage Auto Const Mandatory
{The message to display in the terminal if an invalid package is specified.}

Bool bValid = false Conditional ; whether or not there's a valid Package to handle
Bool bCanInstall = false Conditional ; whether or not the package can be installed
Bool bCanUninstall = false Conditional ; whether or not the package can be uninstalled

Chronicle:Package PackageRef = None

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
	return PackageRef
EndFunction

Function setPackage(Chronicle:Package newPackageRef)
	PackageRef = newPackageRef
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
	
	bCanInstall = myPackage.canInstall()
	bCanUninstall = myPackage.canUninstall()
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

Function tokenReplacementLogic()
	if (isValid())
		replace("SelectedPackage", getPackage())
		replace("InstalledVersion", getPackage().getVersionSetting())
	else
		replace("SelectedPackage", InvalidPackageMessage) ; The terminal shouldn't show a replacement field in this case, but caution never hurt
		replace("InstalledVersion", InvalidPackageMessage)
	endif
EndFunction