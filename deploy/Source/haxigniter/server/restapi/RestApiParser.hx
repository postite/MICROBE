package haxigniter.server.restapi;

import haxigniter.server.restapi.RestApiRequest;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.exceptions.RestApiException;

/* 
   Css-selector parser written and kindly donated by John A. De Goes.
*/

enum Modifier {
    pseudo    (value:String);
    pseudoFunc(name:String, args:Array<String>);
    className (value:String);
    hash      (value:String);
    attribute (name:String, operator:String, value:String);
	orOperator;
}

/**
 * A segment of a selector.
 */
class SelectorSegment
{
    private static var NAME_P:EReg = ~/^([\-\w]+)/i;
    
    private static var PSEUDO_FUNC_P = ~/^:([\w\-]+)\(/i;
    private static var PSEUDO_P      = ~/^:([\w\-]+)/i;
    private static var ATTR_P        = ~/^\[(.*?(?<!\\))\]/;
	//private static var ATTR_P        = ~/^\[([^\]]+)\]/;
    
    private static var ATTR_S_P      = ~/^([\w\-]+)\s*(?:([=!~*\^$<>]+)\s*['"]?(.*?)["']?)?$/i;
    
    public var name       (default, null):String;
    public var modifiers  (default, null):Array<Modifier>;
    
    public function new(name:String, modifiers:Array<Modifier>) {
        this.name       = name;
        this.modifiers  = modifiers;
    }
    
    /**
     * Parses a single segment.
     */
    public static function parse(input:String):SelectorSegment {
        input = StringTools.trim(input);
        
        var name       = '*';
        var modifiers  = new Array<Modifier>();
        
        if (NAME_P.match(input)) {
            name = NAME_P.matched(1);
            
            input = input.substr(NAME_P.matched(0).length);			
        }
        
        var i = 0;
        
        while (i < input.length) {
            var remainder = input.substr(i);
			
			// PSEUDO_FUNC_P must be above PSEUDO_P since the latter is a subset of the first.
			if (PSEUDO_FUNC_P.match(remainder)) {
				var parsed = { length : null };
                var pseudoFunc = parsePseudoFunc(remainder.substr(1), // Sub one for the colon
				                                 PSEUDO_FUNC_P.matched(1).length, // Function name
												 parsed); // Parsed string length
												 
                modifiers.push(pseudoFunc);
                
                i += parsed.length + 1; // Add 1 for the colon
            }
            else if (PSEUDO_P.match(remainder)) {
                var pseudo = PSEUDO_P.matched(1);
                
                modifiers.push(Modifier.pseudo(pseudo));
                
                i += PSEUDO_P.matched(0).length;
            }
            else if (ATTR_P.match(remainder)) {
                var attr = ATTR_P.matched(1);
				
				modifiers = modifiers.concat(createAttributes(attr));
				    
                i += ATTR_P.matched(0).length;
            }
            else {
                throw "Unrecognized selector segment: " + remainder;
            }
        }
        
        return new SelectorSegment(name, modifiers);
    }
    
	private static function createAttributes(attributeContent : String) : Array<Modifier>
	{
		var output = new Array<Modifier>();
		
		// Split attribute in OR expressions, if they exist
		while(attributeContent.length > 0)
		{
			var nextExpr = searchUnquoted(attributeContent, '|');
			var attr = attributeContent.substr(0, (nextExpr == -1) ? null : nextExpr);
			
			if (ATTR_S_P.match(attr))
			{
				var name  = ATTR_S_P.matched(1);
				var op    = ATTR_S_P.matched(2);
				var value = ATTR_S_P.matched(3);

				// Need to rewrite escaping of the brackets manually
				if(value != null)
				{
					value = StringTools.replace(value, '\\[', '[');
					value = StringTools.replace(value, '\\]', ']');
				}
				
				// If more than one attribute in the expression, push an OR modifier.
				if(output.length > 0)
				{
					output.push(Modifier.orOperator);
				}
				
				output.push(Modifier.attribute(name, op, value));
			}
			else
				throw "Unrecognized attribute selector format: " + attr;
			
			attributeContent = (nextExpr == -1) ? '' : attributeContent.substr(nextExpr+1);
		}
		
		return output;
	}
	
    public function toString():String {
        return "SelectorSegment(" + name + ", modifiers=" + modifiers + ")";
    }
	
    /**
     * Parse the arguments in a function string.
     * @param    args Input string, starting with a function name and following parenthesis with arguments.
     * @param   str  Length of the parsed string is contained in str.length.
     * @return  A Modifier.pseudoFunc()
     */
    private static function parsePseudoFunc(func : String, funcNameLength : Int, parsed : { length: Int } ) : Modifier {
        var funcName = func.substr(0, funcNameLength);
        var funcParams = [];
        
        var insideSQuote = false;
        var insideDQuote = false;

        var i = funcNameLength; // +1 in the first loop for the initial parenthesis.
        var param = new StringBuf();
        
        while (++i < func.length) {
            var char = func.charAt(i);

			if (!insideDQuote && !insideSQuote)
            {
                if (char == '"')
                    insideDQuote = true;
                else if (char == "'")
                    insideSQuote = true;
                else if (char == "," || char == ")") {
                    funcParams.push(param.toString());
                    
                    if(char == ")")
                    {
                        // Add the last char to the index counter and exit.
                        ++i; 
                        break;
                    }
                    else
                        param = new StringBuf();
                }
                else
                    param.add(char);
            }
			else {
				if (char == '"' && insideDQuote)
					insideDQuote = false;
				else if (char == "'" && insideSQuote)
					insideSQuote = false;
				else if (char == '\\') {
					// Escaping char, add the next char instead.
					param.add(func.charAt(++i));
				}
				else
					param.add(char);
			}
		}

        // Set parsed length so it can be used in the main parser
        parsed.length = i;
        return Modifier.pseudoFunc(funcName, funcParams);
    }
	
	private static function searchUnquoted(input : String, searchFor : String) : Int
	{
        var insideSQuote = false;
        var insideDQuote = false;
		
		var i = -1;
		var searchLen = searchFor.length;
		var escaped = false;

        while (++i < input.length)
		{
			if(!insideDQuote && !insideSQuote && input.substr(i, searchLen) == searchFor)
				return i;
				
            var char = input.charAt(i);

			if(char == '"')
			{
				if(insideDQuote && !escaped)
					insideDQuote = false;
				else
					insideDQuote = true;
			}
			else if(char == "'")
			{
				if(insideSQuote && !escaped)
					insideSQuote = false;
				else
					insideSQuote = true;
			}
			
			escaped = char == '\\';
		}

		return -1;
    }
}

/**
 * Represents a complete selector; e.g.: #foo >bar.first:hover
 */
class Selector
{    
    public var segments (default, null):Array<SelectorSegment>;
    
    public function new(segments:Array<SelectorSegment>) {
        this.segments = segments;
    }
    
    public function slice(start:Int, end:Int = -1):Selector {
        if (end == -1) end = segments.length;
        
        return new Selector(segments.slice(start, end));
    }
    
    public function iterator():Iterator<Null<SelectorSegment>> {
        return segments.iterator();
    }

    public static function parse(input:String):Selector {
        input = StringTools.trim(input);
        
        var segments = new Array<SelectorSegment>();
		
		if(input != '')
			segments.push(SelectorSegment.parse(input));
        
        return new Selector(segments);
    }
    
    public function toString() {
        return "Selector(" + segments + ")";
    }
    
    private function getLength():Int {
        return segments.length;
    }
}

/////////////////////////////////////////////////////////////////////

class RestApiParser
{
	private static var validResourceName : EReg = ~/^(\w+)(\.\w+)?$/;
	private static var allResource : EReg = ~/^\*?$/;
	private static var oneResource : EReg = ~/^[1-9]\d*$/;
	private static var viewResource : EReg = ~/^\w+$/;

	private static var my_stringToOperator : Hash<RestApiSelectorOperator>;
	private static function stringToOperator() : Hash<RestApiSelectorOperator>
	{
		if(my_stringToOperator == null)
		{
			my_stringToOperator = new Hash<RestApiSelectorOperator>();

			my_stringToOperator.set('*=', RestApiSelectorOperator.contains);
			my_stringToOperator.set('$=', RestApiSelectorOperator.endsWith);
			my_stringToOperator.set('=', RestApiSelectorOperator.equals);
			my_stringToOperator.set('<', RestApiSelectorOperator.lessThan);
			my_stringToOperator.set('<=', RestApiSelectorOperator.lessThanOrEqual);
			my_stringToOperator.set('>', RestApiSelectorOperator.moreThan);
			my_stringToOperator.set('>=', RestApiSelectorOperator.moreThanOrEqual);
			my_stringToOperator.set('!=', RestApiSelectorOperator.notEqual);
			my_stringToOperator.set('^=', RestApiSelectorOperator.startsWith);
		}
		
		return my_stringToOperator;
	}
	
	private static inline function validResourceTest(resource : String) : Array<String>
	{
		if(!validResourceName.match(resource))
			throw new RestApiException('Invalid resource: ' + resource, RestErrorType.invalidResource);
		
		// Test output format. Matched string will be ".format"
		var outputFormat = validResourceName.matched(2);
		
		return [validResourceName.matched(1), outputFormat != null && outputFormat.length > 1 ? outputFormat.substr(1) : null];
	}
	
	private static function parseSegments(decodedUrl : String) : Array<String>
	{
		// Remove start and end slash
		if(StringTools.startsWith(decodedUrl, '/'))
			decodedUrl = decodedUrl.substr(1);

		if(StringTools.endsWith(decodedUrl, '/'))
			decodedUrl = decodedUrl.substr(0, decodedUrl.length - 1);

		var output = new Array<String>();
		var buffer = new StringBuf();
		
		var insideBracket = false;
		var insideString = '';
		
		for(i in 0 ... decodedUrl.length)
		{
			var c = decodedUrl.charAt(i);
			if(c == '/' && !insideBracket && insideString == '')
			{
				output.push(buffer.toString());
				buffer = new StringBuf();
			}
			else
			{
				buffer.add(c);
				
				switch(c)
				{
					case '[':
						if(insideString == '') insideBracket = true;
					case ']':
						if(insideString == '') insideBracket = false;
					case '"':
						if(insideString != "'" && decodedUrl.charAt(i-1) != '\\')
						{
							insideString = (insideString == '"') ? '' : '"';
						}
					case "'":
						if(insideString != '"' && decodedUrl.charAt(i-1) != '\\')
						{
							insideString = (insideString == "'") ? '' : "'";
						}
				}				
			}
		}
		
		output.push(buffer.toString());
		
		return output;
	}
	
	public static function parse(decodedUrl : String) : Array<RestApiParsedSegment>
	{
		var parsed = new Array<RestApiParsedSegment>();
		
		// Split url and pair the resources with the types
		var urlSegments = parseSegments(decodedUrl);
		var i = 0;
		
		while(i < urlSegments.length)
		{
			// Test valid resource and return an array of [resource name, output format]
			var resourceData = validResourceTest(urlSegments[i++]);
			
			parsed.push(parseSelector(resourceData[0], urlSegments[i++]));
		}
		
		return parsed;
	}
	
	public static function parseSelector(resource : String, data : String) : RestApiParsedSegment
	{
		// Detect resource type.
		if(data == null || allResource.match(data))
			return RestApiParsedSegment.all(resource);
		
		if(oneResource.match(data))
			return RestApiParsedSegment.one(resource, Std.parseInt(data));
		
		if(viewResource.match(data))
			return RestApiParsedSegment.view(resource, data);

		try
		{
			// Concatenate all Modifiers from selector.
			var output = new Array<Modifier>();
			for(selector in Selector.parse(data))
			{
				output = output.concat(selector.modifiers);
			}
			
			return RestApiParsedSegment.some(resource, Lambda.array(Lambda.map(output, cssToRest)));
		}
		catch(e : String)
		{
			throw new RestApiException(e, RestErrorType.invalidQuery);
		}
	}
	
	private static function cssToRest(modifier : Modifier) : RestApiSelector
	{
		var field : String;
		var operator : RestApiSelectorOperator = null;
		var value : String = null;
		
		switch(modifier)
		{
			case pseudo(name):
				return RestApiSelector.func(name, new Array<String>());
			case pseudoFunc(name, args):
				return RestApiSelector.func(name, args);
			case className(value), hash(value):
				throw new RestApiException('Invalid modifier: ' + value, RestErrorType.invalidQuery);
			case attribute(name, operator, value):
				return RestApiSelector.attribute(name, getOperator(operator), value);
			case orOperator:
				return RestApiSelector.orOperator;
		}
	}
	
	private static function getOperator(stringOperator : String) : RestApiSelectorOperator
	{
		var output = stringToOperator().get(stringOperator);
		if(output == null)
			throw new RestApiException('Invalid operator: ' + stringOperator, RestErrorType.invalidQuery);
		
		return output;
	}
}
