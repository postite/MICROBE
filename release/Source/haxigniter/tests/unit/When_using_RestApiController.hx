package haxigniter.tests.unit;

import haxigniter.tests.mocks.MockDatabaseConnection;
import haxigniter.tests.mocks.MockConfig;

import haxigniter.common.libraries.ParsedUrl;
import haxigniter.server.content.ContentHandler;
import Type;
import haxigniter.common.types.TypeFactory;
import haxigniter.common.unit.TestCase;

import haxigniter.server.request.RestApiHandler;
import haxigniter.server.request.RequestHandler;
import haxigniter.server.Controller;

import haxigniter.common.restapi.RestApiInterface;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.restapi.RestApiSecurityHandler;
import haxigniter.server.restapi.RestApiFormatHandler;
import haxigniter.server.restapi.RestApiRequest;
import haxigniter.server.restapi.RestApiRequestHandler;

import haxigniter.server.libraries.Request;

class SecurityMock implements RestApiSecurityHandler
{
	public function new() {}
	
	public function install(api : RestApiInterface) : Void
	{
	}
	
	public function create(resourceName : String, data : Dynamic, ?parentResource : String, ?parentId : Int, ?parameters : Hash<String>) : Void
	{
	}
	
	public function read(resourceName : String, data : RestDataCollection, ?parameters : Hash<String>) : Void
	{
	}
	
	public function update(resourceName : String, ids : List<Int>, data : Dynamic, ?parameters : Hash<String>) : Void
	{
	}
	
	public function delete(resourceName : String, ids : List<Int>, ?parameters : Hash<String>) : Void
	{
	}
}

class TestRestApi implements Controller, implements RestApiRequestHandler, implements RestApiFormatHandler
{
	public var lastRequest : RestApiRequest;
	public var lastFormat : RestApiFormat;
	public var lastData : String;
	
	public var requestHandler : RequestHandler;
	public var contentHandler : ContentHandler;
	
	public function new()
	{
		restApiFormats = ['json', 'xml'];
	}
	
	///// Interface implementation //////////////////////////////////
	
	public function handleApiRequest(request : RestApiRequest, security : RestApiSecurityHandler) : RestApiResponse
	{
		this.lastRequest = request;
		return RestApiResponse.success([]);
	}

	public var restApiFormats(default, null) : Array<RestApiFormat>;

	public function restApiInput(data : String, inputFormat : RestApiFormat) : PropertyObject
	{
		this.lastData = data;
	}

	public function restApiOutput(response : RestApiResponse, outputFormat : RestApiFormat) : RestResponseOutput
	{
		this.lastFormat = outputFormat;

		return {
			contentType: 'mock1',
			charSet: 'mock2',
			output: 'mock3'
		}
	}
}

class When_using_RestApiController extends haxigniter.common.unit.TestCase
{
	private var api : TestRestApi;
	private var requestHandler : RestApiHandler;
	
	private var request : Request;

	private var r : Array<RestApiResource>;
	
	public override function setup()
	{
		var config = new MockConfig();
		config.controllerPackage = 'haxigniter.tests.unit';

		this.api = new TestRestApi();
		this.request = new Request(config);		

		this.requestHandler = new RestApiHandler(new SecurityMock(), this.api, this.api);
		this.requestHandler.noOutput = true;
	}
	
	public override function tearDown()
	{
	}
	
	public function test_Then_a_request_should_handle_the_basic_data()
	{
		this.requestHandler.handleRequest(this.api, new ParsedUrl('/api/v1/?/bazaars'), 'GET', null, null);
		
		this.assertEqual(1, api.lastRequest.apiVersion);
		
		this.assertEqual('{}', Std.string(api.lastRequest.queryParameters));
		this.assertEqual(1, api.lastRequest.resources.length);
		this.assertEqual(RestApiRequestType.read, api.lastRequest.type);
	}

	public function test_Then_a_request_should_handle_not_so_basic_data()
	{
		this.requestHandler.handleRequest(this.api, new ParsedUrl('/couldBeAnything/v23?/what/3/is/[this^=stuff]/'), 'DELETE', null, 'abcde');
		
		this.assertEqual(23, api.lastRequest.apiVersion);
		
		this.assertEqual('{}', Std.string(api.lastRequest.queryParameters));
		this.assertEqual(2, api.lastRequest.resources.length);
		this.assertEqual(RestApiRequestType.delete, api.lastRequest.type);
		this.assertEqual('abcde', api.lastData);
	}

	public function test_Then_a_request_should_handle_null_api_version()
	{
		this.requestHandler.handleRequest(this.api, new ParsedUrl('/?mock'), 'GET', null, null);
		this.assertEqual(null, api.lastRequest.apiVersion);
	}

	public function test_Then_output_format_should_use_first_format_as_default()
	{
		this.requestHandler.handleRequest(this.api, new ParsedUrl('/?mock'), 'GET', null, null);
		this.assertEqual('json', this.api.lastFormat);
	}

	public function test_Then_output_format_should_use_specified_format()
	{
		r = requestResource('/mock/3.xml');
		
		this.assertEqual('xml', this.api.lastFormat);
		this.assertEqual(1, r.length);
		this.assertResource('mock', 'attribute(id,equals,3)', r[0]);
	}

	public function test_Then_output_format_should_be_specified_before_query_parameters()
	{
		r = requestResource('/mock/*.xml&test=123');
		
		this.assertEqual('xml', this.api.lastFormat);
		this.assertEqual(1, r.length);
		this.assertResource('mock', '', r[0]);
	}

	public function test_Then_a_request_should_generate_valid_resources()
	{
		r = requestResource('/bazaars');
		this.assertEqual(1, r.length);
		this.assertResource('bazaars', '', r[0]);

		r = requestResource('/bazaars//');
		this.assertEqual(1, r.length);
		this.assertResource('bazaars', '', r[0]);

		r = requestResource('/bazaar2/12');		
		this.assertEqual(1, r.length);
		this.assertResource('bazaar2', 'attribute(id,equals,12)', r[0]);
		
		r = requestResource('/bazaars/3/libraries/');
		this.assertEqual(2, r.length);
		this.assertResource('bazaars', 'attribute(id,equals,3)', r[0]);
		this.assertResource('libraries', '', r[1]);

		r = requestResource('/bazaars/[field^=123][field2*="test"]/');
		this.assertEqual(1, r.length);
		this.assertResource('bazaars', 'attribute(field,startsWith,123),attribute(field2,contains,test)', r[0]);
		
		r = requestResource('/bazaars/[id<20]:range(0,10)/');
		this.assertEqual(1, r.length);
		this.assertResource('bazaars', 'attribute(id,lessThan,20),func(range[0,10])', r[0]);

		r = requestResource('/bazaars/:range(10,20)/');
		this.assertEqual(1, r.length);
		this.assertResource('bazaars', 'func(range[10,20])', r[0]);
	}
	
	private function assertResource(name : String, selectorDump : String, resource : RestApiResource)
	{
		this.assertEqual(name, resource.name);
		this.assertEqual(selectorDump, selectorsToString(resource.selectors));
	}
	
	// PHP cannot dump data like Neko, so this is needed.
	private function selectorsToString(selectors : Array<RestApiSelector>) : String
	{
		var output = [];
		for(s in selectors)
		{
			switch(s)
			{
				case func(name, args):
					output.push('func(' + name + '[' + args.join(',') + '])');
				
				case attribute(name, operator, value):
					output.push('attribute(' + name + ',' + operator + ',' + value + ')');
					
				case orOperator:
					output.push('OR');
			}
		}
		
		return output.join(',');
	}
	
	private function requestResource(query : String, method = 'GET') : Array<RestApiResource>
	{
		this.api.lastRequest = null;
		var response = this.requestHandler.handleRequest(this.api, new ParsedUrl('/api/v1?' + query), method, null, null);
		
		if(this.api.lastRequest == null)
			trace(response);
		
		return this.api.lastRequest.resources;
	}
}