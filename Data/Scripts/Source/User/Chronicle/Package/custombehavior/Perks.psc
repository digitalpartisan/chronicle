Scriptname Chronicle:Package:CustomBehavior:Perks extends Chronicle:Package:CustomBehavior

Perk[] Property Perks Auto Const Mandatory

Function handlePerks(Bool bAdd = true)
	if (!Perks)
		return
	endif
	
	Int iCounter = 0
	Actor aPlayer = Game.GetPlayer()
	Perk pPerk = None
	while (iCounter < Perks.Length)
		pPerk = Perks[iCounter]
		
		if (bAdd)
			if (!aPlayer.HasPerk(pPerk))
				Chronicle:Logger:Package:CustomBehavior.logAddPerk(self, pPerk)
				aPlayer.AddPerk(pPerk)
			endif
		else
			if (aPlayer.HasPerk(pPerk))
				Chronicle:Logger:Package:CustomBehavior.logRemovePerk(self, pPerk)
				aPlayer.RemovePerk(pPerk)
			endif
		endif
		
		iCounter += 1
	endWhile
EndFunction

Bool Function installBehavior()
	handlePerks()
	return true
EndFunction

Bool Function postloadBehavior()
	handlePerks()
	return true
EndFunction

Bool Function uninstallBehavior()
	handlePerks(false)
	return true
EndFunction
