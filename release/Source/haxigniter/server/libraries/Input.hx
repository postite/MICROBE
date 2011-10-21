package haxigniter.server.libraries;

import Type;

#if php
import php.Web;
import php.db.ResultSet;
#elseif neko
import neko.Web;
import neko.db.ResultSet;
#end

class Input 
{
	/**
	 * Returns the GET and POST parameters. Made so you don't have to switch between the Neko and PHP version.
	 * @return GET and POST parameters, POST having precedence.
	 */
	public static inline function getParams() : Hash<String>
	{
		return Web.getParams();
	}

	public static function escapeIterator(input : Iterator<Dynamic>, ?callBack : Dynamic -> Dynamic, ?escapeAll : Bool = false) : List<Dynamic>
	{
		return escapeIterable({ iterator: function() { return input; }}, callBack, escapeAll);
	}
	
	public static function escapeIterable(input : Iterable<Dynamic>, ?callBack : Dynamic -> Dynamic, ?escapeAll : Bool = false) : List<Dynamic>
	{
		var output = new List<Dynamic>();
		for(row in input)
		{
			output.add(escapeData(row, callBack, escapeAll));
		}
		
		return output;
	}
	
	public static function escapeHash(input : Hash<Dynamic>, ?callBack : String -> String, ?escapeAll : Bool = false) : Hash<Dynamic>
	{
		var output = new Hash<Dynamic>();
		for(field in input.keys())
		{
			var data = input.get(field);
			output.set(field, escapeData(data, callBack, escapeAll));
		}
		
		return output;
	}

	public static function escapeObject(input : Dynamic, ?callBack : String -> String, ?escapeAll : Bool = false) : Dynamic
	{
		var output = { };
		var field : String = null;

		// TODO: Need this until Reflect.fields is fixed for anonymous objects in PHP.
		#if php
		
		untyped __php__('foreach($input as $field => $data) { ');
		var data = Reflect.field(input, field);
		Reflect.setField(output, field, escapeData(data, callBack, escapeAll));
		untyped __php__(' } ');
		
		#elseif neko
		for(field in Reflect.fields(input))
		{
			var data = Reflect.field(input, field);
			Reflect.setField(output, field, escapeData(data, callBack, escapeAll));
		}
		#end
		
		return output;
	}

	/**
	 * Escapes all string values in common datatypes with a callback function. The following are supported:
	 * 
	 * - Iterable/Iterator: Returns a List<Dynamic> with all containing strings escaped.
	 * - Hash: Returns a Hash<Dynamic>.
	 * - Object: Returns an anonymous object.
	 * 
	 * Its usefulness is prominent in input from users (web, database, etc) to avoid attacks.
	 * 
	 * @param	input Any of the supported types.
	 * @param	?callBack A method used for filtering data. If null, Input.htmlSpecialChars will be used.
	 * @param	?escapeAll If true, all scalar values will be converted to string and escaped.
	 */
	public static function escapeData(input : Dynamic, ?callBack : String -> String, ?escapeAll : Bool = false) : Dynamic
	{
		if(Std.is(input, String))
		{
			//trace('String: "' + input + '"');
			if(callBack == null)
				callBack = Input.htmlEscape;

			return callBack(input);
		}
		else if(Std.is(input, Hash))
		{
			//trace('Hash');
			return escapeHash(input, callBack, escapeAll);
		}
		else if(Reflect.isObject(input))
		{
			if(isIterable(input))
			{
				//trace('Iterable');
				return escapeIterable(input, callBack, escapeAll);
			}
			else if(isIterator(input))
			{
				//trace('Iterator');
				return escapeIterator(input, callBack, escapeAll);
			}
			else
			{
				//trace('Object');
				return escapeObject(input, callBack, escapeAll);
			}
		}
		else
		{
			//trace('Other: ' + Type.typeof(input));'
			if(!escapeAll)
				return input;
			else
			{
				if(callBack == null)
					callBack = Input.htmlEscape;
				
				return callBack(Std.string(input));
			}
		}
	}
	
	/**
	 * Just like StringTools.htmlEscape(), but also escapes " and ' to their html representations.
	 * @param	s Input string
	 * @return String with <>?'" escaped to html.
	 */
	public static inline function htmlEscape(s : String) : String
	{
		return StringTools.htmlEscape(s).split('"').join("&quot;").split("'").join("&#039;");
	}

	/**
	 * Just like StringTools.htmlUnescape(), but also unescapes " and ' from their html representations.
	 * @param	s Input string
	 * @return String with <>?'" unescaped from html.
	 */
	public static inline function htmlUnescape(s : String) : String
	{
		return StringTools.htmlUnescape(s).split("&quot;").join('"').split("&#039;").join("'");
	}

	
	private static inline function isIterable(d : Dynamic) : Bool
	{
		// Thanks: http://www.scwn.net/2009/02/iterable-in-haxe/
		return (d != null && (Reflect.hasField(d, 'iterator') || Std.is(d, Array)));
	}

	private static inline function isIterator(d : Dynamic) : Bool
	{
		// The ResultSet seems to be an object that needs some extra care, especially for Neko.
		return (d != null && (Reflect.hasField(d, 'hasNext') && Reflect.hasField(d, 'next')) || Std.is(d, ResultSet));
	}
	
	#if php
	public static inline function post(parameter : String) : String
	{
		try
		{
			return untyped __var__('_POST', parameter);
		}
		catch(e : String)
		{
			return null;
		}		
	}

	public static inline function get(parameter : String) : String
	{
		try
		{
			return untyped __var__('_GET', parameter);
		}
		catch(e : String)
		{
			return null;
		}		
	}
	#end
}
