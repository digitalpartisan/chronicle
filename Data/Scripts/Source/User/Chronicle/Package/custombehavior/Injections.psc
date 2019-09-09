Scriptname Chronicle:Package:CustomBehavior:Injections extends Chronicle:Package:CustomBehavior

InjectTec:Injector[] Property Injections Auto Const
FormList Property InjectionList Auto Const
InjectTec:Injector:Bulk[] Property BulkInjections Auto Const
FormList Property BulkInjectionList Auto Const

Function inject(Bool bForce = false)
	InjectTec:Injector.bulkInject(Injections, bForce)
	InjectTec:Injector.bulkInjectList(InjectionList, bForce)
	InjectTec:Injector:Bulk.bulkInject(BulkInjections, bForce)
	InjectTec:Injector:Bulk.bulkInjectList(BulkInjectionList, bForce)
EndFunction

Function forceInject()
	inject(true)
EndFunction

Function revert(Bool bForce = false)
	InjectTec:Injector.bulkRevert(Injections, bForce)
	InjectTec:Injector.bulkRevertList(InjectionList, bForce)
	InjectTec:Injector:Bulk.bulkRevert(BulkInjections, bForce)
	InjectTec:Injector:Bulk.bulkRevertList(BulkInjectionList, bForce)
EndFunction

Function forceRevert()
	revert(true)
EndFunction

Function verify(Bool bForceInjectOnFailure = false)
	InjectTec:Injector.bulkVerify(Injections, bForceInjectOnFailure)
	InjectTec:Injector.bulkVerifyList(InjectionList, bForceInjectOnFailure)
	InjectTec:Injector:Bulk.bulkVerify(BulkInjections, bForceInjectOnFailure)
	InjectTec:Injector:Bulk.bulkVerifyList(BulkInjectionList, bForceInjectOnFailure)
EndFunction

Function forceVerify()
	verify(true)
EndFunction

Bool Function installBehavior()
	inject()
	return true
EndFunction

Bool Function postloadBehavior()
	inject()
	return true
EndFunction

Bool Function uninstallBehavior()
	revert()
	return true
EndFunction
