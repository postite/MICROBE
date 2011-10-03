package haxigniter.tests.unit;

import Type;
import haxigniter.common.unit.TestCase;

/**
* This is fun, unit testing a unit test class.
*/
class When_UnitTesting_With_TestCase extends TestCase
{
	public function test_Then_assertNull_should_null_if_null()
	{
		this.assertNull(null);
	}

	public function test_Then_assertNotNull_shouldnt_null_if_not_null()
	{
		this.assertNotNull(0);
		this.assertNotNull("");

		this.assertNotNull('aaa');
		this.assertNotNull(~/not null/);
	}
	
	public function test_Then_assertIsA_should_test_class_if_input_is_class()
	{
		var test : EReg = ~/test me/;
		this.assertIsA(test, EReg);
	}

	public function test_Then_assertIsA_should_test_type_if_input_is_not_class()
	{
		var test : Float = 123.456;
		this.assertIsA(test, ValueType.TFloat);
	}
	
	public function test_Then_assertNotA_should_invert_assertIsA()
	{
		var test : Float = 123.456;
		this.assertNotA(test, ValueType.TInt);

		var test2 : EReg = ~/test me/;
		this.assertNotA(test2, haxe.Stack);
	}

	public function test_Then_assertEqual_should_be_same_as_assertEquals()
	{
		var a = {b: 123};
		var b = a;
		
		this.assertEqual(123, 123);
		this.assertEqual(a, b);
	}

	public function test_Then_assertNotEqual_should_not_be_equal()
	{
		var a = {b: 123};
		var b = {b: 123};
		
		this.assertNotEqual(123, 124);
		this.assertNotEqual(a, b);
	}

	public function test_Then_assertPattern_works_with_anything()
	{
		var a = "I am a string";
		var b = 7890.12;
		var c = new List<Bool>();
		
		c.add(true); c.add(false);
		
		this.assertPattern(~/a string$/, a);
		this.assertPattern(~/^7890\./, b);
		this.assertPattern(~/\{true/, c);
	}

	public function test_Then_assertNotPattern_is_inverse_of_assertPattern()
	{
		var a = "I am a string";
		this.assertNotPattern(~/not a string$/, a);
	}	
}
