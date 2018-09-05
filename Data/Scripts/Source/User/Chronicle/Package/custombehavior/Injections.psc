Scriptname Chronicle:Package:CustomBehavior:Injections extends Chronicle:Package:CustomBehavior

InjectTec:Injector[] Property Injections Auto Const
InjectTec:Injector:Bulk[] Property BulkInjections Auto Const

Function handleInjection(Quest InjectionRecord, Bool bInject = true, Bool bForce = false)
	InjectTec:Injector injector = InjectionRecord as InjectTec:Injector
	InjectTec:Injector:Bulk bulkInjector = InjectionRecord as InjectTec:Injector:Bulk
	
	if (injector)
		if (bInject)
			injector.inject(bForce)
		else
			injector.revert(bForce)
		endif
	endif
	
	if (bulkInjector)
		if (bInject)
			bulkInjector.inject(bForce)
		else
			bulkInjector.revert(bForce)
		endif
	endif
EndFunction

Function handleInjectionRecords(Quest[] InjectionRecords, Bool bInject = true, Bool bForce = false)
	Int iCounter = 0
	while (iCounter < InjectionRecords.Length)
		handleInjection(InjectionRecords[iCounter], bInject, bForce)
		iCounter += 1
	endWhile
EndFunction

Function handleInjections(Bool bInject = true, Bool bForce = false)
	if (!Injections)
		return
	endif

	handleInjectionRecords(Injections as Quest[], bInject, bForce)
EndFunction

Function handleBulkInjections(Bool bInject = true, Bool bForce = false)
	if (!BulkInjections)
		return
	endif
	
	handleInjectionRecords(BulkInjections as Quest[], bInject, bForce)
EndFunction

Function handle(Bool bInject = true, Bool bForce = false)
	Chronicle:Logger:Package:CustomBehavior.logInjection(self, bInject, bForce)
	
	handleInjections(bInject, bForce)
	handleBulkInjections(bInject, bForce)
EndFunction

Function forceInject()
	handle(true, true)
EndFunction

Function forceRevert()
	handle(false, true)
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
