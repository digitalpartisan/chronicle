Scriptname Chronicle:Package:CustomBehavior:Perks extends Chronicle:Package:CustomBehavior

Struct PerkData
	Perk thePerk = None
	Bool addOnInstall = true
	Bool removeOnUninstall = true
EndStruct

Perk[] Property Perks Auto Const
PerkData[] Property AdvancedSettings Auto Const

Function handlePerk(Perk thePerk, Bool bInstall = false)
	if (!thePerk)
		return
	endif
	
	Actor aPlayer = Game.GetPlayer()
	Bool bHas = aPlayer.HasPerk(thePerk)
	if (bInstall && !bHas)
		aPlayer.AddPerk(thePerk)
	elseif (!bInstall && bHas)
		aPlayer.RemovePerk(thePerk)
	endif
EndFunction

Function handlePerks(Bool bInstall = true)
	if (!Perks || !Perks.Length)
		return
	endif
	
	Int iCounter = 0
	while (iCounter < Perks.Length)
		handlePerk(Perks[iCounter])
		iCounter += 1
	endWhile
EndFunction

Function handlePerkData(PerkData data, Bool bInstall = true)
	if (!data || !data.thePerk)
		return
	endif
	
	if (bInstall && data.addOnInstall)
		handlePerk(data.thePerk)
	endif
	
	if (!bInstall && data.removeOnUninstall)
		handlePerk(data.thePerk, false)
	endif
EndFunction

Function handleAdvancedSettings(Bool bInstall = true)
	if (!AdvancedSettings || !AdvancedSettings.Length)
		return
	endif
	
	Int iCounter = 0
	while (iCounter < AdvancedSettings.Length)
		handlePerkData(AdvancedSettings[iCounter], bInstall)
		iCounter += 1
	endWhile
EndFunction

Function handle(Bool bInstall = true)
	Chronicle:Package:CustomBehavior:Logger.logPerks(self, bInstall)
	
	handlePerks(bInstall)
	handleAdvancedSettings(bInstall)
EndFunction

Bool Function installBehavior()
	handle()
	return true
EndFunction

Bool Function postloadBehavior()
	handle()
	return true
EndFunction

Bool Function uninstallBehavior()
	handle(false)
	return true
EndFunction
