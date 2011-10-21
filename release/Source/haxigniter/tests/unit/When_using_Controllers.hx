package haxigniter.tests.unit;

import haxigniter.tests.mocks.MockConfig;

import haxe.rtti.Infos;
import haxigniter.common.exceptions.Exception;
import haxigniter.server.content.ContentHandler;
import haxigniter.server.content.OutputAllContent;
import haxigniter.server.libraries.Server;
import Type;
import haxigniter.common.types.TypeFactory;
import haxigniter.common.unit.TestCase;

import haxigniter.server.content.ContentHandler;
import haxigniter.server.request.RequestHandler;

import haxigniter.server.Controller;
import haxigniter.server.request.RestHandler;
import haxigniter.server.request.BasicHandler;

import haxigniter.server.libraries.Request;

class TestContentHandler implements ContentHandler
{
	public function new() {}
	
	public function input(content : ContentData) : Dynamic
	{
		return StringTools.replace(content.data, 'a', '#');
	}
	
	public function output(content : Dynamic) : ContentData
	{
		var s = cast(content, String);
		
		return {
			mimeType: null,
			charSet: null,
			encoding : null,
			data : StringTools.replace(s, '1', '@####')
		}
	}
}


class Testrest implements Controller, implements Infos
{
	public function new()
	{
		requestHandler = new RestHandler(new MockConfig());
	}
	
	public var requestHandler : RequestHandler;
	public var contentHandler : ContentHandler;
	
	public function index() : String
	{
		return 'index';
	}
	
	public function make(arg1 : String, ?arg2 : Float) : String
	{
		return 'make ' + arg1 + (arg2 != null ? ' - ' + arg2 : '');
	}
	
	public function show(id : String, ?arg1 : String, ?arg2 : List<Int>) : String
	{
		return 'show ' + id + ' (' + arg1 + ') ' + arg2.join('=');
	}
	
	public function edit(id : Int, ?arg1 : Bool) : String
	{
		return 'edit ' + id + ' ' + arg1;
	}
	
	public function create(formData : Hash<String>) : String
	{
		return 'create ' + formData.get('id') + ' ' + formData.get('name');
	}
	
	public function update(id : Int, formData : Hash<String>) : String
	{
		return 'update ' + id + ' ' + formData.get('id') + ' ' + formData.get('name');
	}
	
	public function destroy(id : Int, formData : Hash<String>) : String
	{
		return 'destroy ' + id + ' ' + formData.get('id') + ' ' + formData.get('name');
	}
}

class Teststandard implements Controller, implements Infos
{
	public function new()
	{
	}
	
	public var myOutput : String;
	
	// The default requestHandler is a BasicHandler.
	public var requestHandler : RequestHandler;
	
	// If no contentHandler, output nothing. Controller handles that.
	public var contentHandler : ContentHandler;
	
	public function index(?arg1 : Bool) : String
	{
		return 'index' + (arg1 ? ' ' + arg1 : '');
	}
	
	public function first(arg1 : String, ?arg2 : Float) : String
	{
		return 'first ' + arg1 + (arg2 != null ? ' - ' + arg2 : '');
	}
	
	public function second(arg2 : List<String>) : String
	{
		return 'second ' + arg2.join('/');
	}
	
	public function third()
	{
		var postData = cast(requestHandler, BasicHandler).getPostData;
		var requestData = cast(requestHandler, BasicHandler).requestData;
		
		myOutput = postData.get('test') + postData.get('test2') + requestData;
	}
}

class Testcontent implements Controller, implements Infos
{
	public function new()
	{
		requestHandler = new BasicHandler(new MockConfig());
		contentHandler = new OutputAllContent();
	}
	
	public var requestHandler : RequestHandler;
	public var contentHandler : ContentHandler;
	
	public function index(arg : List<String>) : String
	{
		return 'index ' + arg.join('/');
	}	
}

///// Testing ///////////////////////////////////////////////////////

class When_using_Controllers extends haxigniter.common.unit.TestCase
{
	private var rest : Testrest;
	private var request : Request;
	
	public override function setup()
	{
		this.rest = new Testrest();
		this.request = new Request(new MockConfig());
	}
	
	public override function tearDown()
	{
	}
	
	public function test_Then_Rest_actions_should_work_according_to_reference()
	{
		var output : String;
		var data = new Hash<String>();

		// index()
		output = request.internal('testrest');
		this.assertEqual('index', output);

		// make()
		// Include in this test a prepending slash, which will be stripped.
		output = request.internal('/testrest/new/123');
		this.assertEqual('make 123', output);

		// Also test optional argument
		output = request.internal('testrest/new/123/12.45');
		this.assertEqual('make 123 - 12.45', output);
		
		// show()
		output = request.internal('testrest/123/useful/1-2-3');
		this.assertEqual('show 123 (useful) 1=2=3', output);

		// edit()
		output = request.internal('testrest/456/edit/true');
		this.assertPattern(~/^edit 456 (1|true)$/, output);

		// create()
		data.set('id', '123');
		data.set('name', 'Test');
		
		output = request.internal('testrest', 'POST', data);
		this.assertEqual('create 123 Test', output);

		// update()
		data.set('id', 'N/A');
		data.set('name', 'Test 2');

		output = request.internal('testrest/456', 'POST', data);
		this.assertEqual('update 456 N/A Test 2', output);

		// destroy()
		output = request.internal('testrest/789/delete', 'POST', data);
		this.assertEqual('destroy 789 N/A Test 2', output);
	}

	public function test_Then_standard_actions_should_work_according_to_reference()
	{
		var output : String;

		// index()
		output = request.internal('teststandard', 'GET');
		this.assertEqual('index', output);

		output = request.internal('teststandard/index/true', 'POST');
		this.assertPattern(~/^index (1|true)$/, output);

		output = request.internal('teststandard/first/true/123.987', 'GET');
		this.assertEqual('first true - 123.987', output);

		output = request.internal('teststandard/second/what-a-nice-format', 'GET');
		this.assertEqual('second what/a/nice/format', output);		
	}
	
	public function test_Then_external_requests_with_BasicHandler_should_work_with_postdata()
	{
		var data = new Hash<String>();
		data.set('test', 'abcd');
		data.set('test2', 'efgh');
		
		var controller : Teststandard = cast request.execute('http://example.com/teststandard/third', 'POST', data, Server.requestContent('ijkl'));
		this.assertEqual('abcdefghijkl', controller.myOutput);
	}
	
	public function test_Then_external_requests_with_OutputAllContent_should_be_sent_to_output_method()
	{
		var self = this;
		request.execute('http://example.com/testcontent/index/output-this-please', 'GET', null, null, function(content : ContentData) {
			self.assertEqual('index output/this/please', content.data);
		});
	}
}