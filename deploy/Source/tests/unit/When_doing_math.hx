package tests.unit;

import haxigniter.common.unit.TestCase;

/**
* This can be a template of your own unit test classes.
* This test class is based on Behavior Driven Development!
* More info: http://jonkruger.com/blog/2008/07/25/why-behavior-driven-development-is-good/
*/
class When_doing_math extends TestCase
{
	public function test_Then_one_plus_one_is_two()
	{
		this.assertEqual(1+1, 2);
	}

	public function test_Then_sin_90_degrees_is_one()
	{
		this.assertTrue(Math.sin(90 * Math.PI / 180) == 1);
	}
}
