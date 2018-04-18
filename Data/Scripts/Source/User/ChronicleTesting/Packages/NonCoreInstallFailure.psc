Scriptname ChronicleTesting:Packages:NonCoreInstallFailure extends chronicle:package:NonCore

Bool Function customInstallationBehavior()
	return false ; force an installation failure for testing purposes
EndFunction
