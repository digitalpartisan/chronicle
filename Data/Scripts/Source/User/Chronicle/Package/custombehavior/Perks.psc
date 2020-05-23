Scriptname Chronicle:Package:CustomBehavior:Perks extends Chronicle:Package:CustomBehavior

Perk[] Property Perks Auto Const Mandatory

Function handlePerks(Bool bAdd = true)
	Chronicle:Package:CustomBehavior:Logger.logPerks(self, bAdd)
	
	if (!Perks)
		return
	endif
	
	Int iCounter = 0
	Actor aPlayer = Game.GetPlayer()
	Perk pPerk = None
	Bool bHas = false
	while (iCounter < Perks.Length)
		pPerk = Perks[iCounter]
		bHas = aPlayer.HasPerk(pPerk)
		
		if (bAdd && !bHas)
			aPlayer.AddPerk(pPerk)
		elseif (!bAdd && bHas)
			aPlayer.RemovePerk(pPerk)
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
