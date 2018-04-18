Scriptname Chronicle:Package:EngineWrapper extends Quest Hidden

Chronicle:Engine Function getEngineObject()
{Override this in a child script to provide specific behavior.}
	Chronicle:Logger.logBehaviorUndefined(self, "getEngineRef()")
	return None
EndFunction
