Scriptname Chronicle:Version:Static extends Chronicle:Version Conditional
{Accepts segment values from the editor and provides them as needed.  Useful for creating an object that identifies a specific version value for later reference and display.
It is strongly recommended that quest objects with this script attached be named for the value string they contain.
It is strongly recommended that you not check the "Start Game Enabled" but do check the "Run Once" box as you deem appropriate.
The quest startup and shutdown behavior can be used to perform updates when a particular version is upgraded to which should not be repeated at any point.}

Group ValueSettings
	Int Property Major = 0 Auto Const Mandatory
	{The value of the Major version (i.e. x.0.0)}
	Int Property Minor = 0 Auto Const Mandatory
	{The value of the Minor version (i.e. 0.x.0)}
	Int Property Bugfix = 0 Auto Const Mandatory
	{The value of the bugfix version (i.e. 0.0.x)}
EndGroup

Group UpdateSettings
	Chronicle:Version:Static Property PreviousVersion Auto Const
	{Which version precedes this one in an upgrade cycle.  This information matters because an upgrade process might need to look into the past to determine which updates need to be applied.  Left empty for the first version.}
	Chronicle:Package:Update Property MyUpdate Auto Const
	{Required in order to process this udpate and move a package from one version to another.}
	Chronicle:Version:Static Property NextVersion Auto Const
	{Which version follows this one in an upgrade cycle.  This matters because an upgrade process will need to proceed to the next update should the package call for it.  Left empty for the most recent version.}
EndGroup

Chronicle:Version:Static Function getPreviousVersion()
	return PreviousVersion
EndFunction

Chronicle:Version:Static Function getNextVersion()
	return NextVersion
EndFunction

Chronicle:Package:Update Function getUpdate()
	return MyUpdate
EndFunction

Int Function getMajor()
	return Major
EndFunction

Int Function getMinor()
	return Minor
EndFunction

Int Function getBugfix()
	return Bugfix
EndFunction
