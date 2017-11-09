Scriptname ChronicleTesting:Packages:InstallFailure extends Chronicle:Package:Local Conditional

Bool Function customInstallationBehavior()
	return false ; force an installation failure for testing purposes
EndFunction
