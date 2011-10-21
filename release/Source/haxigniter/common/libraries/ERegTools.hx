package haxigniter.common.libraries;

class ERegTools
{
	private static var quoteMetaChars : String = '.\\+*?[^]($)';
	
	/**
	* Taken from the php function quotemeta().
	* Escapes all regexp meta characters in a string with a backslash.
	* Note that front slash is not escaped!
	*/
	public static function quoteMeta(str : String) : String
	{
		for(i in 0 ... ERegTools.quoteMetaChars.length)
		{
			var char = ERegTools.quoteMetaChars.charAt(i);
			str = StringTools.replace(str, char, '\\' + char);
		}
		
		return str;
	}
}
