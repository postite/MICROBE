package haxigniter.common.types;

import haxigniter.common.rtti.RttiUtil;

/**
 * Example of custom class that only accepts integers > 0. Useful for database ids.
 */
class DbID
{
	public function toInt() { return intValue; }
	private var intValue : Int;
	
	public function new(input : String)
	{
		var intValue : Int = Std.parseInt(input);
		
		if(intValue == null || intValue <= 0)
		{
			throw new TypeException(Type.getClassName(Type.getClass(this)), input);
		}

		this.intValue = intValue;
	}
}

class TypeFactory
{
	public static var arrayDelimiter : String = '-';

	/**
	 * Cast a list of strings to correct type based on a method in a class, throwing TypeException if typecast fails.
	 * If a parameter is optional and string is empty or null, null is returned.
	 * The class type must implement haxe.rtti.Infos.
	 * @param	classType   Class type.
	 * @param	classMethod Method in the class.
	 * @param	arguments   List of strings to typecast.
	 * @param	?offset = 0 Start position in list, output length will be arguments.length-offset.
	 * @return  An array of typecasted arguments.
	 */
	public static function typecastArguments(classType : Class<Dynamic>, classMethod : String, arguments : Array<String>, ?offset = 0) : Array<Dynamic>
	{
		var output : Array<Dynamic> = [];		
		var c = 0;
		
		for(method in RttiUtil.getMethod(classMethod, classType))
		{
			// The RestController only uses a range of the argument array, so an offset
			// can be specified to adjust the method arguments to start from.
			if(offset > 0)
			{
				--offset;
				continue;
			}
			
			// Test if value is optional, then push a null argument.
			if(method.opt && (arguments[c] == '' || arguments[c] == null))
			{
				++c;
				output.push(null);
			}
			else
			{
				// The methods come in the same order as the arguments, so match each argument with a method type.
				output.push(TypeFactory.createType(method.type, arguments[c++]));
			}
		}

		return output;		
	}
	
	public static function createType(typeString : String, value : String) : Class<Dynamic>
	{
		// If output is null at the end, an error will be thrown.
		var output : Dynamic = null;
		
		//trace('[WebTypeFactory] Creating type: ' + typeString + ' (' + value + ')');
		
		var typeParam = splitType(typeString);
		
		switch(typeParam[0])
		{
			///// Primitive types ///////////////////////////////////
			
			case 'Int':
				output = Std.parseInt(value);

			case 'Float':
				output = Std.parseFloat(value);
			
			case 'String', 'Dynamic':
				output = value;

			case 'Array', 'List':
				// NOTE: How to make the instance with a type parameter?
				// NOTE: Right now only one type parameter is supported!
				output = Type.createInstance(Type.resolveClass(typeParam[0]), []);
				
				var isArray = typeParam[0] == 'Array';

				for(val in value.split(arrayDelimiter))
				{
					var newType = TypeFactory.createType(typeParam[1], val);
					
					if(isArray)
						output.push(newType);
					else
						output.add(newType);
				}
			
			case 'Bool':
				output = (value == '' || value == '0' || value == 'false' || value == 'null') ? false : true;
			
			/////////////////////////////////////////////////////////
			
			default:
				// Other types will be created by reflection with the string value as argument.
				// It's up to those classes to determine if the value is legal or not.
				var classType = Type.resolveClass(typeString);
				if(classType == null)
					throw new haxigniter.common.exceptions.Exception('[WebTypeFactory] Type not found: ' + typeString);
				
				output = Type.createInstance(classType, [value]);
		}

		if(output == null)
			throw new TypeException(typeString, value);

		//trace('[WebTypeFactory] Adding output: ' + Type.typeof(output) + ' (' + output + ')');

		return output;
	}
	
	private static function splitType(typeString : String) : Array<String>
	{
		var typeParam = typeString.indexOf('<');
		
		if(typeParam == -1)
			return [typeString, null];
		
		var mainType = typeString.substr(0, typeParam);
		
		var typeParameter = typeString.substr(typeString.indexOf('<') + 1);
		typeParameter = typeParameter.substr(0, typeParameter.length - 1);		
		
		return [mainType, typeParameter];
	}
}

class TypeException extends haxigniter.common.exceptions.Exception
{
	public var className(getClassName, null) : String;
	private var my_className : String;
	private function getClassName() { return this.my_className; }

	public var value(getValue, null) : String;
	private var my_value : String;
	private function getValue() { return this.my_value; }
	
	public function new(className : String, value : String, ?stack : haxe.PosInfos)
	{
		this.my_className = className;
		this.my_value = value;
		
		var output = 'Invalid value for ' + className + ': ';
		output += value != null ? '"' + value + '"' : 'null';
		
		super(output, 0, stack);
	}
}
