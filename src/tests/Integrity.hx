package tests;

import haxigniter.server.Config;
import haxigniter.tests.ServerIntegrity;

/**
 * This is a template for your own integrity tests.
 * For the default application, browse to dev/integrity/password to run the tests.
 * 
 * NOTE: When using PHP the methods will be executed in the order you put them in
 * the class, but for neko they will be executed in alphabetical order!
 * 
 */
class Integrity extends ServerIntegrity
{
	/**
	 * Integrity test template method.
	 * 
	 * Any method starting with "test" will be executed and should return true/false
	 * whether the test succeeded.
	 * 
	 * Use title.value to set the test title that will be displayed.
	 * printHeader() can be used to output a separator to group tests together.
	 * 
	 */
	public function testLogic(title : { value : String }) : Bool
	{
		printHeader('Logic tests - Template class (tests/Integrity.hx)');
		title.value = 'true != false';
		
		return true != false;
	}

	public function new(config : Config) { super(config); }
}
