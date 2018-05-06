Scriptname Chronicle:Package:EngineWrapper extends Quest Hidden
{This is the base logic for the concept of an Engine Wrapper.  See the Chronicle:Package:Noncore to understand how this is used and why it matters.}

Chronicle:Engine Function getEngineObject()
{Override this in a child script to provide specific behavior.}
	Chronicle:Logger.logBehaviorUndefined(self, "getEngineRef()")
	return None
EndFunction
