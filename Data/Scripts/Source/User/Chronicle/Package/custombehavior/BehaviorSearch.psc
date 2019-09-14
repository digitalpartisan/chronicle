Scriptname Chronicle:Package:CustomBehavior:BehaviorSearch extends Quest Hidden

Bool Function meetsCriteria(Chronicle:Package:CustomBehavior behavior)
{Override this to search for behavior records of particular types and/or any other criteria you can implement.}
	return false
EndFunction

Chronicle:Package:CustomBehavior[] Function search(Chronicle:Package targetPackage)
	Chronicle:Package:CustomBehavior[] results = new Chronicle:Package:CustomBehavior[0]
	if (!targetPackage)
		return results
	endif
	
	Chronicle:Package:CustomBehavior[] candidates = targetPackage.getCustomizations()
	if (!candidates || !candidates.Length)
		return results
	endif
	
	Int iCounter = 0
	while (iCounter < candidates.Length)
		if (candidates[iCounter] && meetsCriteria(candidates[iCounter]))
			results.Add(candidates[iCounter])
		endif
		
		iCounter += 1
	endWhile
	
	return results
EndFunction

Chronicle:Package:CustomBehavior Function searchOne(Chronicle:Package targetPackage)
	Chronicle:Package:CustomBehavior[] searchResults = search(targetPackage)
	if (!searchResults || !searchResults.Length)
		return None
	endif
	
	return searchResults[0]
EndFunction
