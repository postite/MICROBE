package haxigniter.tests.unit.given_a_requesthandlerdecorator;

import haxe.rtti.Infos;
import haxigniter.common.exceptions.Exception;
import haxigniter.server.content.ContentHandler;
import haxigniter.server.content.OutputAllContent;
import haxigniter.server.libraries.Server;
import haxigniter.tests.mocks.MockConfig;
import haxigniter.tests.mocks.MockRequestHandler;
import Type;
import haxigniter.common.types.TypeFactory;
import haxigniter.common.unit.TestCase;

import haxigniter.server.content.ContentHandler;
import haxigniter.server.request.RequestHandler;

import haxigniter.server.Controller;
import haxigniter.server.request.RestHandler;
import haxigniter.server.request.BasicHandler;

import haxigniter.server.request.HaxeRequestDecorator;

///// Testing ///////////////////////////////////////////////////////

class When_using_HaxeRequestDecorator extends haxigniter.common.unit.TestCase
{
	public override function setup()
	{
	}
	
	public override function tearDown()
	{
	}

	public function requestCallback() {}
	
	public function test_Then_it_should_auto_add_requestData_to_argument_if_exists()
	{
		var requestResult = RequestResult.methodCall(this, this.requestCallback, []);
		
		var handler = new HaxeRequestDecorator(new MockRequestHandler(requestResult));
		handler.addToArguments = true;
		
		switch(handler.handleRequest(null, null, null, null, "I am Error."))
		{
			case methodCall(_, _, arguments):
				this.assertEqual(1, arguments.length);
				this.assertEqual("I am Error.", arguments[0]);
			
			default:
				this.assertFalse(true);
		}

		// Force the requestData to be an array.
		handler.restrictClass = Array;
		handler.handleRequest(null, null, null, null, ['I', 'am', 'Array']);
		
		try
		{
			handler.handleRequest(null, null, null, null, "I am not an Array.");
			this.assertTrue(false); // Should not be executed.
		}
		catch(e : Exception)
		{
			this.assertEqual("Only objects of type Array are allowed. (Was: String)", e.message);
		}
	}
}