Scriptname Chronicle:Package:CustomBehavior:QuestHandler:Search extends Chronicle:Package:CustomBehavior:BehaviorSearch

Bool Function meetsCriteria(Chronicle:Package:CustomBehavior behavior)
	return (behavior as Chronicle:Package:CustomBehavior:QuestHandler)
EndFunction

Chronicle:Package:CustomBehavior:QuestHandler[] Function searchQuestHandlers(Chronicle:Package targetPackage)
	return search(targetPackage) as Chronicle:Package:CustomBehavior:QuestHandler[]
EndFunction

Chronicle:Package:CustomBehavior:QuestHandler Function searchOneQuestHandler(Chronicle:Package targetPackage)
	return searchOne(targetPackage) as Chronicle:Package:CustomBehavior:QuestHandler
EndFunction
