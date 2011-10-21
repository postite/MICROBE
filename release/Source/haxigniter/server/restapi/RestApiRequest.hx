package haxigniter.server.restapi;

import haxigniter.server.exceptions.RestApiException;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.restapi.RestApiFormatHandler;

enum RestApiSelectorOperator
{
    contains;        // *=
    endsWith;        // $=
    equals;          // =
    lessThan;        // <
    lessThanOrEqual; // <=
    moreThan;        // >
    moreThanOrEqual; // >=
    notEqual;        // !=
    startsWith;      // ^=
}

enum RestApiSelector
{
    func (name : String, args : Array<String>);
    attribute (name : String, operator : RestApiSelectorOperator, value : String);
	orOperator;
}
	
enum RestApiParsedSegment
{
	one(resourceName : String, id : Int);
    all(resourceName : String);
    some(resourceName : String, selectors : Array<RestApiSelector>);
    view(resourceName : String, viewName : String);
}

typedef RestApiResource = {
	var name : String;
	var selectors : Array<RestApiSelector>;
}

enum RestApiRequestType // CRUD
{
	create;
	read;
	update;
	delete;
}

/////////////////////////////////////////////////////////////////////

class RestApiRequest
{
	public var type(default, null) : RestApiRequestType;
    public var resources(default, null) : Array<RestApiResource>;
    public var apiVersion(default, null) : Int;
	public var queryParameters(default, null) : Hash<String>;
    public var data(default, null) : PropertyObject; // Any extra data for create/update

	public function new(type : RestApiRequestType, resources : Array<RestApiResource>, apiVersion : Int, queryParameters : Hash<String>, ?data : PropertyObject)
	{
		if(type == null)
			throw new RestApiException('No request type specified.', RestErrorType.invalidRequestType);
		if(resources == null)
			throw new RestApiException('No selectors in request.', RestErrorType.invalidQuery);
		
		this.type = type;
		this.resources = resources;
		this.apiVersion = apiVersion;
		
		this.queryParameters = queryParameters;
		this.data = data;
	}
	
	public function toString() : String
	{
		var output = 'RestApiRequest.' + type + '(';
		var resourceOutput = [];
		
		for(resource in resources)
		{
			var selectors = [];
			if(resource.selectors.length == 0)
				selectors.push('all');
			else
			{
				for(selector in resource.selectors)
				{
					selectors.push(Std.string(selector));
				}
			}
			
			resourceOutput.push(resource.name + ': ' + selectors.join(', '));
		}
		
		output += resourceOutput.join(', ');
		output += ' ' + queryParameters + ' ' + data + ')';
		
		return output;
	}
}