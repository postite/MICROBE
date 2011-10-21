package haxigniter.tests.unit.given_the_routing_system;

import haxigniter.server.routing.Alias;

class When_using_Alias extends haxigniter.common.unit.TestCase
{
	private var rw : Alias;
	
	public override function setup()
	{
		rw = new Alias();
	}
	
	public override function tearDown()
	{
	}

	public function test_Then_removing_a_rewrite_is_possible()
	{
		rw.add(~/abc/, 'bca');
		rw.add(~/aaa/, 'bbb');
		
		this.assertFalse(rw.remove(2));
		this.assertTrue(rw.remove(0));
	}
	
	public function test_Then_rewriting_simple_regexps_should_work()
	{
		rw.add(~/abc/, 'bca');
		rw.add(~/aaa/, 'bbb');

		// No substitution if no match
		this.assertEqual('ccc', rw.rewriteUrl('ccc'));

		this.assertEqual('bca', rw.rewriteUrl('abc'));
		this.assertEqual('bbb', rw.rewriteUrl('aaa'));
	}
	
	public function test_Then_rewriting_in_correct_order_should_work()
	{
		rw.add(~/a.*/, '1');
		rw.add(~/aaa/, '2');
		
		this.assertEqual('1', rw.rewriteUrl('aaa'));
	}
	
	public function test_Then_rewriting_with_substitution_should_work()
	{
		rw.add(~/^first\/(p[^\/]+)\/(.*)/, '$2/$1');
		
		this.assertEqual('here/path', rw.rewriteUrl('first/path/here'));
	}
}
