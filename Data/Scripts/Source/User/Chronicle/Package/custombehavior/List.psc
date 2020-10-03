Scriptname Chronicle:Package:CustomBehavior:List extends DynamicTerminal:ListWrapper:FormArray:Dynamic

Function setPackage(Chronicle:Package targetPackage)
	setData(None)
	targetPackage && setData(targetPackage.getCustomizations() as Form[])
EndFunction
