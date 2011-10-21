package haxigniter.tests.unit;

import Type;
import haxigniter.common.types.TypeFactory;
import haxigniter.common.unit.TestCase;

import haxigniter.server.restapi.RestApiRequest;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.restapi.RestApiParser;

class When_using_RestApiParser extends haxigniter.common.unit.TestCase
{
	var output : Array<RestApiParsedSegment>;
	
	public override function setup()
	{
	}
	
	public override function tearDown()
	{
	}
	
	public function test_Then_ALL_ONE_and_VIEW_selectors_should_be_parsed_properly()
	{
		output = parse('bazaars');
		
		this.assertEqual(1, output.length);
		this.assertApiResource(output[0], 'bazaars', null);

		output = parse('/bazaars');
		
		this.assertEqual(1, output.length);
		this.assertApiResource(output[0], 'bazaars', null);

		output = parse('/bazaars/');
		
		this.assertEqual(1, output.length);
		this.assertApiResource(output[0], 'bazaars', null);

		output = parse('/bazaars//');
		
		this.assertEqual(1, output.length);
		this.assertApiResource(output[0], 'bazaars', null);

		output = parse('/bazaars/1');
		
		this.assertEqual(1, output.length);
		this.assertApiResource(output[0], 'bazaars', 1);

		output = parse('/bazaars//libraries');
		
		this.assertEqual(2, output.length);
		this.assertApiResource(output[0], 'bazaars', null);
		this.assertApiResource(output[1], 'libraries', null);

		output = parse('/bazaars//libraries//');
		
		this.assertEqual(2, output.length);
		this.assertApiResource(output[0], 'bazaars', null);
		this.assertApiResource(output[1], 'libraries', null);

		output = parse('/bazaars/1/libraries');
		
		this.assertEqual(2, output.length);
		this.assertApiResource(output[0], 'bazaars', 1);
		this.assertApiResource(output[1], 'libraries', null);
		
		output = parse('/bazaars/1/libraries/2');
		
		this.assertEqual(2, output.length);
		this.assertApiResource(output[0], 'bazaars', 1);
		this.assertApiResource(output[1], 'libraries', 2);

		output = parse('/bazaars/testview/');
		
		this.assertEqual(1, output.length);
		this.assertApiResource(output[0], 'bazaars', 'testview');

		output = parse('/bazaars/testview');
		
		this.assertEqual(1, output.length);
		this.assertApiResource(output[0], 'bazaars', 'testview');

		output = parse('/bazaars/testview/libraries/2');
		
		this.assertEqual(2, output.length);
		this.assertApiResource(output[0], 'bazaars', 'testview');
		this.assertApiResource(output[1], 'libraries', 2);

		output = parse('/bazaars/1/libraries/testview');
		
		this.assertEqual(2, output.length);
		this.assertApiResource(output[0], 'bazaars', 1);
		this.assertApiResource(output[1], 'libraries', 'testview');
		
		// All ok, lets test errors.
		badParse('', ~/Invalid resource: /, RestErrorType.invalidResource);
		badParse('/', ~/Invalid resource: /, RestErrorType.invalidResource);
		badParse('//', ~/Invalid resource: /, RestErrorType.invalidResource);
		
		badParse('/Bäd request/', ~/Invalid resource: Bäd request/, RestErrorType.invalidResource);
		badParse('/bazaars./', ~/Invalid resource: bazaars\./, RestErrorType.invalidResource);
		
		badParse('/bazaars///', ~/Invalid resource: /, RestErrorType.invalidResource);
	}

	public function test_Then_SOME_selectors_should_be_parsed_properly()
	{
		output = parse('/bazaars/[id=3][name ^= Boris]/');
		
		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'id', RestApiSelectorOperator.equals, '3');
		this.assertSelectorAttrib(output[0], 1, 'name', RestApiSelectorOperator.startsWith, 'Boris');

		
		output = parse('/bazaars/:test[name*=Doris]:range(0,10):urlencode/');

		this.assertEqual(1, output.length);
		this.assertSelectorFunc(output[0], 0, 'test', new Array<String>());
		this.assertSelectorAttrib(output[0], 1, 'name', RestApiSelectorOperator.contains, 'Doris');
		this.assertSelectorFunc(output[0], 2, 'range', ['0', '10']);
		this.assertSelectorFunc(output[0], 3, 'urlencode', new Array<String>());

		
		output = parse('/bazaars/1/libraries/:test[name*="D\"oris"]:range(0,10):urlencode/');

		this.assertEqual(2, output.length);
		this.assertSelectorFunc(output[1], 0, 'test', new Array<String>());
		this.assertSelectorAttrib(output[1], 1, 'name', RestApiSelectorOperator.contains, 'D"oris');
		this.assertSelectorFunc(output[1], 2, 'range', ['0', '10']);
		this.assertSelectorFunc(output[1], 3, 'urlencode', new Array<String>());


		output = parse('/bazaars/[name^=test][email$=google.com]');

		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'name', RestApiSelectorOperator.startsWith, 'test');
		this.assertSelectorAttrib(output[0], 1, 'email', RestApiSelectorOperator.endsWith, 'google.com');


		output = parse('/bazaars/[url^=http://]');

		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'url', RestApiSelectorOperator.startsWith, 'http://');

		
		output = parse('/bazaars/[url^=http://]');

		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'url', RestApiSelectorOperator.startsWith, 'http://');

		
		output = parse('/bazaars/[url^="N/A"]');

		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'url', RestApiSelectorOperator.startsWith, 'N/A');


		// Escaping the brackets
		output = parse('/bazaars/[url^=\\[Brackets\\]]');

		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'url', RestApiSelectorOperator.startsWith, '[Brackets]');

		output = parse('/bazaars/[url^="\\[Bracket\\]"]');

		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'url', RestApiSelectorOperator.startsWith, '[Bracket]');

		// And an error check.
		badParse('/bazaars/[this]]is not good', ~/Unrecognized selector segment: \]is/, RestErrorType.invalidQuery);
	}
	
	public function test_Then_SOME_selectors_with_OR_should_be_parsed_properly()
	{
		output = parse('/bazaars/[a="\\"3"|b=4]/');
		
		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'a', RestApiSelectorOperator.equals, '\\"3');
		this.assertSelectorAttrib(output[0], 1, 'OR');
		this.assertSelectorAttrib(output[0], 2, 'b', RestApiSelectorOperator.equals, '4');

		output = parse("/bazaars/[a='3|4']/");
		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'a', RestApiSelectorOperator.equals, '3|4');
		
		output = parse('/bazaars/[a="3|4"]/');
		this.assertEqual(1, output.length);
		this.assertSelectorAttrib(output[0], 0, 'a', RestApiSelectorOperator.equals, '3|4');
	}

	/////////////////////////////////////////////////////////////////
	
	private function assertSelectorAttrib(selector : RestApiParsedSegment, selectorIndex : Int, name : String, ?operator : RestApiSelectorOperator, ?value : String, ?resourceName : String)
	{
		switch(selector)
		{
			case some(resource, selectors):
				if(resourceName != null)
					this.assertEqual(resourceName, resourceName);
					
				switch(selectors[selectorIndex])
				{
					case attribute(aName, aOp, aValue):
						this.assertEqual(name, aName);
						this.assertEqual(operator, aOp);
						this.assertEqual(value, aValue);
					case orOperator:
						this.assertEqual('OR', name);
					default:
						this.assertTrue(false); // The lazy way out
				}
			default:
				this.assertTrue(false);
		}		
	}

	private function assertSelectorFunc(selector : RestApiParsedSegment, selectorIndex : Int, name : String, args : Array<String>)
	{
		switch(selector)
		{
			case some(resource, selectors):
				switch(selectors[selectorIndex])
				{
					case func(aName, aArgs):
						this.assertEqual(name, aName);
						this.assertEqual(Std.string(args), Std.string(aArgs));
					default:
						this.assertTrue(false); // The lazy way out
				}
			default:
				this.assertTrue(false);
		}		
	}
	
	private function assertApiResource(selector : RestApiParsedSegment, resourceName : String, data : Dynamic)
	{
		switch(selector)
		{
			case one(resource, id):
				this.assertEqual(resourceName, resource);
				this.assertEqual(data, id);
			
			case some(resource, selectors):
				this.assertEqual(resourceName, resource);
				this.assertEqual(data, selectors);

			case all(resource):
				this.assertEqual(resourceName, resource);
			
			case view(resource, name):
				this.assertEqual(resourceName, resource);
				this.assertEqual(data, name);
		}		
	}

	private function badParse(input : String, expectedError : EReg, expectedErrorType : RestErrorType) : Void
	{
		try 
		{
			parse(input);
			this.assertEqual('', 'Parse data "' + input + '" should\'ve failed.');
		}
		catch(e : haxigniter.server.exceptions.RestApiException)
		{
			this.assertPattern(expectedError, e.message);
			this.assertEqual(expectedErrorType, e.error);
		}
	}
	
	private function parse(input : String) : Array<RestApiParsedSegment>
	{
		return RestApiParser.parse(input);
	}
}