Scriptname Chronicle:Package:CustomBehavior:Injections extends Chronicle:Package:CustomBehavior

InjectTec:Injector[] Property Injections Auto Const
InjectTec:Injector:Bulk[] Property BulkInjections Auto Const

Function handleInjection(Quest InjectionRecord, Bool bInject = true)
	InjectTec:Injector injector = InjectionRecord as InjectTec:Injector
	InjectTec:Injector:Bulk bulkInjector = InjectionRecord as InjectTec:Injector:Bulk
	
	if (injector)
		if (bInject)
			Chronicle:Logger:Package:CustomBehavior.logInjection(self, injector)
			injector.inject()
		else
			Chronicle:Logger:Package:CustomBehavior.logRevertion(self, injector)
			injector.revert()
		endif
	endif
	
	if (bulkInjector)
		if (bInject)
			Chronicle:Logger:Package:CustomBehavior.logInjection(self, injector)
			bulkInjector.inject()
		else
			Chronicle:Logger:Package:CustomBehavior.logRevertion(self, injector)
			bulkInjector.revert()
		endif
	endif
EndFunction

Function handleInjectionRecords(Quest[] InjectionRecords, Bool bInject = true)
	Int iCounter = 0
	while (iCounter < InjectionRecords.Length)
		handleInjection(InjectionRecords[iCounter], bInject)
		iCounter += 1
	endWhile
EndFunction

Function handleInjections(Bool bInject = true)
	if (!Injections)
		return
	endif

	handleInjectionRecords(Injections as Quest[], bInject)
EndFunction

Function handleBulkInjections(Bool bInject = true)
	if (!BulkInjections)
		return
	endif
	
	handleInjectionRecords(BulkInjections as Quest[], bInject)
EndFunction

Bool Function installBehavior()
	handleInjections()
	handleBulkInjections()
	return parent.installBehavior()
EndFunction

Bool Function postloadBehavior()
	handleInjections()
	handleBulkInjections()
	return parent.postloadBehavior()
EndFunction

Bool Function uninstallBehavior()
	handleInjections(false)
	handleBulkInjections(false)
	return parent.uninstallBehavior()
EndFunction
