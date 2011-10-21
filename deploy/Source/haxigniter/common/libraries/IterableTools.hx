package haxigniter.common.libraries;

class IterableTools
{
	public static function isSubsetOf<T>(subSet : Iterable<T>, bigSet : Iterable<T>) : Bool
	{
		for(v in subSet)
		{
			if(!Lambda.has(bigSet, v))
				return false;
		}
		
		return true;
	}

	public static function difference<T>(compare : Iterable<T>, against : Iterable<T>) : List<T>
	{
		var output = new List<T>();
		for(v in compare)
		{
			if(!Lambda.has(against, v))
				output.push(v);
		}
		
		return output;
	}

	public static function intersection<T>(compare : Iterable<T>, against : Iterable<T>) : List<T>
	{
		var output = new List<T>();
		for(v in compare)
		{
			if(Lambda.has(against, v))
				output.push(v);
		}
		
		return output;
	}

	public static function arraySearch<T>(array : Array<T>, searchFor : T) : Null<Int>
	{
		for(i in 0 ... array.length)
		{
			if(array[i] == searchFor)
				return i;
		}
		
		return null;
	}
}
