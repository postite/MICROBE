package haxigniter.tests.unit;

import haxigniter.server.libraries.Input;

class TestInputClass
{
	public var field1 : String;	
	public var field2(default, null) : String;
	
	private var my_field3 : String;
	public var field3(getField3, setField3) : String;
	private function getField3() { return my_field3; }
	private function setField3(value : String) { my_field3 = value; return my_field3; }
	
	public var field4(default, null) : Int;
	
	private var privateField : String;
	
	public function new()
	{
		field1 = '<test>';
		field2 = '"Who?"';
		field3 = '&';
		field4 = 1337;
		
		privateField = '"Private"';
	}
}

class When_using_library_Input extends haxigniter.common.unit.TestCase
{
	private function uselessEscape(input : String) : String
	{
		return 'Mock';
	}
	
	public function test_Then_htmlEscape_should_escape_html()
	{
		this.assertEqual('abc&lt;&gt;&#039;&quot;&amp;едц', Input.htmlEscape('abc<>\'"&едц'));
	}	

	public function test_Then_htmlUnescape_should_unescape_html()
	{
		this.assertEqual('abc<>\'"&едц', Input.htmlUnescape('abc&lt;&gt;&#039;&quot;&amp;едц'));
	}
	
	public function test_Then_escapeData_should_escape_objects()
	{
		var input = new TestInputClass();
		var output = Input.escapeData(input);

		// Public fields will be quoted
		this.assertEqual('&lt;test&gt;', output.field1);
		
		// Public accessible fields will be quoted
		this.assertEqual('&quot;Who?&quot;', output.field2);
		
		// Accessor fields will not be quoted, but their private fields will.
		this.assertEqual('&amp;', output.my_field3);
		
		// Non-strings will stay as Int
		this.assertEqual(1337, output.field4);
		
		// Private fields are quoted too.
		this.assertEqual('&quot;Private&quot;', Reflect.field(output, 'privateField'));
	}

	public function test_Then_escapeData_should_escape_hash()
	{
		var input = new Hash<Dynamic>();
		input.set('field1', '<test>');
		input.set('field2', '"Who?"');
		input.set('field3', '&');
		input.set('field4', 1337);
		
		var output : Hash<Dynamic> = Input.escapeData(input);
		
		this.assertEqual('&lt;test&gt;', output.get('field1'));
		
		// Public accessible fields will be quoted
		this.assertEqual('&quot;Who?&quot;', output.get('field2'));
		
		// Accessor fields will be quoted
		this.assertEqual('&amp;', output.get('field3'));
		
		// Non-strings will stay as Int
		this.assertEqual(1337, output.get('field4'));
	}

	public function test_Then_escapeData_should_loop_through_all_items_and_escape_them()
	{
		var data = [ { test: '<test>', me: '&' }, { test: '"Who?"', me: 123 } ];
		
		var output : List<Dynamic> = Input.escapeData(data);

		this.assertEqual(2, output.length);
		
		var output1 = output.pop();
		var output2 = output.pop();
		
		this.assertEqual('&lt;test&gt;', output1.test);
		this.assertEqual('&amp;', output1.me);
		
		this.assertEqual('&quot;Who?&quot;', output2.test);
		this.assertEqual(123, output2.me);
	}
	
	public function test_Then_escapeData_should_wrap_iterators_to_iterable()
	{
		var list : Array<Dynamic> = ['&', '"', "'"];
		var data = { next : function() { return list.shift(); }, hasNext : function() { return list.length > 0; } };
		
		var output : List<Dynamic> = Input.escapeData(data);

		this.assertEqual('&amp;-&quot;-&#039;', output.join('-'));
	}

	public function test_Then_escapeData_can_use_a_custom_callback()
	{
		var input = new TestInputClass();
		var output = Input.escapeData(input, this.uselessEscape);
		
		this.assertEqual('Mock', output.field1);
		this.assertEqual('Mock', output.field2);
		this.assertEqual('Mock', output.my_field3);
		this.assertEqual(1337, output.field4);
	}

	public function test_Then_escapeData_can_escape_everything()
	{
		var input = new Hash<Dynamic>();
		input.set('field3', '&');
		input.set('field4', 1337);

		var output : Hash<String> = Input.escapeData(input, null, true);
		
		this.assertEqual('&amp;', output.get('field3'));
		this.assertEqual('1337', output.get('field4'));
	}
}
