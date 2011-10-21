package haxigniter.common.validation;
import haxigniter.common.libraries.IterableTools;

enum ValidationResult
{
	success;
	tooMany(extraFields : List<String>);
	tooFew(missingFields : List<String>);
	failure(fields : List<String>);
}

enum ValidationType
{
	exactMatch;
	allowTooFew;
}

typedef ValidationCallback = Dynamic -> Dynamic;

class Field
{
	// {0,0} is the limit macro.
	
	public static function alphaNumeric(?min = 1, ?max : Int)
	{
		return create('^\\w{0,0}$', min, max);
	}

	public static function alphaNumericDash(?min = 1, ?max : Int)
	{
		return create('^[\\w-]{0,0}$', min, max);
	}

	public static function anythingOneline(?min = 0, ?max : Int)
	{
		return create('^.{0,0}$', min, max);
	}

	public static function anything() {	return ~/.*/; }

	public static function databaseId() { return ~/^[1-9]\d*$/; }
	
	public static function email() { return ~/^[\w-\.]{2,}@[ÅÄÖåäö\w-\.]{2,}\.[a-z]{2,6}$/i; }
	
	public static function boolInt() { return ~/^[01]$/; }
	
	/////////////////////////////////////////////////////////////////
	
	private static function create(base : String, min : Int, max : Int, ?opt = '') : EReg
	{
		return new EReg(StringTools.replace(base, '{0,0}', limit(min, max)), opt);
	}
	
	private static function limit(min : Int, max : Int) : String
	{
		if(min == 0 && max == 1) return '?';
		if(min == 1 && max == null) return '+';
		if(min == 0 && max == null) return '*';
		if(min == null && max != null) return '{,' + max + '}';
		if(min != null && max == null) return '{' + min + ',}';
		return '{' + min + ',' + max + '}';
	}
}

class FieldValidator 
{
	private var fields : Hash<EReg>;
	private var callbacks : Hash<ValidationCallback>;
	private var validationType : ValidationType;
	
	private var allFields : Hash<Bool>;
	
	/**
	 * Creates a new instance of the FieldValidator.
	 * @param	fields An anonymous object of EReg objects.
	 * @param	callbacks For more advanced behaviour, a Hash of callbacks that takes a string and returns whether the validation succeeded or not.
	 */
	public function new(fields : Dynamic, ?callbacks : Dynamic, ?validationType : ValidationType)
	{
		this.allFields = new Hash<Bool>();
		
		this.fields = objectToHash(fields);
		
		// TODO: Make callbacks Dynamic<ValidationCallback> when quick notation is implemented.
		this.callbacks = objectToHash(callbacks);
		this.validationType = validationType == null ? ValidationType.exactMatch : validationType;
	}
	
	public function validateField(field : String, value : Dynamic) : Dynamic
	{
		var test : EReg = null;
		var method : ValidationCallback = null;
		var testValue : String;
		
		if(fields.exists(field))
			test = fields.get(field);
		
		if(callbacks.exists(field))
			method = callbacks.get(field);
		
		if(test == null && method == null)
			throw 'Field "' + field + '" not found in FieldValidator.';

		if(!Std.is(value, String))
		{
			if(Reflect.isObject(value) || Reflect.isFunction(value))
				throw 'Field "' + field + '" is not a scalar value.';
			else
				testValue = Std.string(value);
		}
		else
			testValue = cast value;

		if(test != null && !test.match(testValue))
			return null;
		else if(method != null)
			return method(value);
		else
			return value;
	}
	
	public function validate(input : Dynamic, ?failOnFirst = false) : ValidationResult
	{
		var inputFields = Reflect.fields(input);
		var validFields = { iterator: allFields.keys };

		var extraFields = IterableTools.difference(inputFields, validFields);
		if(extraFields.length > 0)
			return ValidationResult.tooMany(extraFields);

		if(validationType != ValidationType.allowTooFew)
		{
			var fewFields = IterableTools.difference(validFields, inputFields);
			if(fewFields.length > 0)
				return ValidationResult.tooFew(fewFields);
		}
		
		var failures = new List<String>();
			
		for(field in inputFields)
		{
			var value = Reflect.field(input, field);
			var newValue = validateField(field, value);
			
			if(newValue == null)
				failures.push(field);
			else if(value != newValue)
				Reflect.setField(input, field, newValue);
		}
		
		return failures.length == 0 ? ValidationResult.success : ValidationResult.failure(failures);
	}

	private function objectToHash<T>(object : Dynamic) : Hash<T>
	{
		var output = new Hash<T>();
		
		for(field in Reflect.fields(object))
		{
			if(!allFields.exists(field))
				allFields.set(field, true);
			
			output.set(field, Reflect.field(object, field));
		}
		
		return output;
	}
	
	/*
	private function hashToObject(hash : Hash<Dynamic>) : Dynamic
	{
		var output = {};
		for(field in hash.keys())
			Reflect.setField(output, field, hash.get(field));
		
		return output;
	}
	*/
}