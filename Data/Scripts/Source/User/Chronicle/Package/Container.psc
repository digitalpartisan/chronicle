Scriptname Chronicle:Package:Container extends Quest

Chronicle:Package[] MyPackages

Int iInternalPointer = 0 ; supports iterator functionality

Int iCorePackageIndex = 0 Const ; For readability purposes
Int iFirstPackageIndex = 1 Const ; Mostly for code readability reasons

Function initialize()
	MyPackages = new Chronicle:Package[0]
EndFunction

Chronicle:Package[] Function getPackages()
	return MyPackages
EndFunction

Int Function getSize()
	return MyPackages.Length
EndFunction

Bool Function passesIntegrityCheck()
	Int iCounter = 0
	Int iSize = getSize()
	
	while (iCounter < iSize)
		if (!MyPackages[iCounter])
			return false
		endif
		iCounter += 1
	endwhile
	
	return true
EndFunction

Bool Function isIndexValid(Int iIndex)
	return 0 <= iIndex && iIndex < getSize()
EndFunction

Bool Function isPointerValid()
	return isIndexValid(iInternalPointer)
EndFunction

Function setPointer(Int iNewValue, Bool bForceValid = false)
{Running the pointer far past the valid bounds of the list doesn't do anything in service of whether or not current() returns a non-None result.
A reasonable program would have stopped once current() no longer returned a valid result following a call to previous() or next().}
	Int iLowerBound = -1 ; if the pointer is at the beginning of the list and previous() is called
	Int iUpperBound = getSize() ; if the pointer is at the end of the list and next() is called
	if (bForceValid)
		iLowerBound = 0
		iUpperBound -= 1
	endif
	
	if (iNewValue > iUpperBound)
		iNewValue = iUpperBound
	endif
	if (iNewValue < iLowerBound)
		iNewValue = iLowerBound
	endif
	
	iInternalPointer = iNewValue
EndFunction

Function forceValidPointer()
	setPointer(iInternalPointer, true)
EndFunction

Function adjustPointer(Int iOffset)
	setPointer(iInternalPointer + iOffset)
EndFunction

Bool Function hasPackage(Chronicle:Package packageRef)
	return 0 <= MyPackages.Find(packageRef)
EndFunction

Int Function locatePackage(Chronicle:Package packageRef)
	return MyPackages.Find(packageRef)
EndFunction

Chronicle:Package Function getAsPackage(Int iIndex)
	if (isIndexValid(iIndex))
		return MyPackages[iIndex] as Chronicle:Package
	else
		return None
	endif
EndFunction

Bool Function addPackage(Chronicle:Package packageRef)
	if (!packageRef)
		return false
	endif

	if (hasPackage(packageRef))
		return false
	else
		MyPackages.Add(packageRef)
		return true
	endif
EndFunction

Chronicle:Package Function getCorePackage()
	return getAsPackage(iCorePackageIndex)
EndFunction

Bool Function setCorePackage(Chronicle:Package packageRef)
	if (!packageRef)
		return false
	endif

	if (0 < getSize())
		return false ; packageRef can't be the core package because there's already a package registered
	else
		return addPackage(packageRef)
	endif
EndFunction

Function rewind(Bool bSkipCore = false)
	if (bSkipCore)
		setPointer(iFirstPackageIndex, true)
	else
		setPointer(iCorePackageIndex, true)
	endif
EndFunction

Function fastForward()
	Int iSize = getSize()
	
	if (0 == iSize)
		setPointer(0)
	else
		setPointer(iSize - 1)
	endif
EndFunction

Chronicle:Package Function current()
	return getAsPackage(iInternalPointer)
EndFunction

Function previous()
	adjustPointer(-1)
EndFunction

Function next()
	adjustPointer(1)
EndFunction

Bool Function removeCurrent()
	if (isPointerValid())
		removePackage(current())
		forceValidPointer()
		return true
	else
		return false
	endif
EndFunction

Bool Function removePackage(Chronicle:Package packageRef)
	Int iIndex = locatePackage(packageRef)
	if (0 <= iIndex)
		MyPackages.Remove(iIndex)
		return true
	else
		return false
	endif
EndFunction
