Scriptname Chronicle:Package:custombehavior:Perks:Search extends Chronicle:Package:CustomBehavior:BehaviorSearch

Bool Function meetsCriteria(Chronicle:Package:CustomBehavior behavior)
	return (behavior as Chronicle:Package:CustomBehavior:Perks)
EndFunction

Chronicle:Package:CustomBehavior:Perks[] Function searchPerks(Chronicle:Package targetPackage)
	return search(targetPackage) as Chronicle:Package:CustomBehavior:Perks[]
EndFunction

Chronicle:Package:CustomBehavior:Perks Function searchOnePerk(Chronicle:Package targetPackage)
	return searchOne(targetPackage) as Chronicle:Package:CustomBehavior:Perks
EndFunction
