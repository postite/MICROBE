package haxigniter.tests.unit;

import haxigniter.common.libraries.ParsedUrl;

class When_using_ParsedUrl extends haxigniter.common.unit.TestCase
{
	public override function setup()
	{
	}
	
	public override function tearDown()
	{
	}

	public function test_Then_parseUrl_should_parse_correctly_for_a_full_url()
	{
		var output = new ParsedUrl('https://username:password@hostname.com:1234/path?arg=value&arg2=value2#anchor');
		
		this.assertEqual('https', output.scheme);
		this.assertEqual('username', output.user);
		this.assertEqual('password', output.pass);
		this.assertEqual('hostname.com', output.host);
		this.assertEqual(1234, output.port);
		this.assertEqual('/path', output.path);
		this.assertEqual('arg=value&arg2=value2', output.query);
		this.assertEqual('anchor', output.fragment);
	}
	
	public function test_Then_parseUrl_should_parse_correctly_for_partial_urls()
	{
		var output = new ParsedUrl('localhost:7777/path/index.php');
		
		this.assertEqual(null, output.scheme);
		this.assertEqual(null, output.user);
		this.assertEqual(null, output.pass);
		this.assertEqual('localhost', output.host);
		this.assertEqual(7777, output.port);
		this.assertEqual('/path/index.php', output.path);
		this.assertEqual(null, output.query);
		this.assertEqual(null, output.fragment);
	}
	
	public function test_Then_parseUrl_should_parse_correctly_for_partial_urls_with_query()
	{
		var output = new ParsedUrl('www.hostname.com/path/index.php/?/testRest/123/with/[query^=abc]');
		
		this.assertEqual(null, output.scheme);
		this.assertEqual(null, output.user);
		this.assertEqual(null, output.pass);
		this.assertEqual('www.hostname.com', output.host);
		this.assertEqual(null, output.port);
		this.assertEqual('/path/index.php/', output.path);
		this.assertEqual('/testRest/123/with/[query^=abc]', output.query);
		this.assertEqual(null, output.fragment);
	}
	
	public function test_Then_parseUrl_should_parse_correctly_for_no_query_but_a_fragment()
	{
		var output = new ParsedUrl('hostname/index.php#hello');
		
		this.assertEqual(null, output.scheme);
		this.assertEqual(null, output.user);
		this.assertEqual(null, output.pass);
		this.assertEqual('hostname', output.host);
		this.assertEqual(null, output.port);
		this.assertEqual('/index.php', output.path);
		this.assertEqual(null, output.query);
		this.assertEqual('hello', output.fragment);
	}

	public function test_Then_parseUrl_should_return_slash_path_for_nothing_but_hostname()
	{
		var output = new ParsedUrl('www.domain.com');
		
		this.assertEqual(null, output.scheme);
		this.assertEqual(null, output.user);
		this.assertEqual(null, output.pass);
		this.assertEqual('www.domain.com', output.host);
		this.assertEqual(null, output.port);
		this.assertEqual('/', output.path);
		this.assertEqual(null, output.query);
		this.assertEqual(null, output.fragment);
	}

	public function test_Then_parseUrl_should_parse_correctly_for_path_only()
	{
		var output = new ParsedUrl('/path/to/index.php/a/b/c');
		
		this.assertEqual(null, output.scheme);
		this.assertEqual(null, output.user);
		this.assertEqual(null, output.pass);
		this.assertEqual(null, output.host);
		this.assertEqual(null, output.port);
		this.assertEqual('/path/to/index.php/a/b/c', output.path);
		this.assertEqual(null, output.query);
		this.assertEqual(null, output.fragment);
	}
	
	public function test_Then_parseQuery_should_parse_query_parameters()
	{
		var output = ParsedUrl.parseQuery('best=123&in=234&test=345');
		
		this.assertEqual('123', output.get('best'));
		this.assertEqual('234', output.get('in'));
		this.assertEqual('345', output.get('test'));

		output = ParsedUrl.parseQuery('best=&=234& ');
		
		this.assertEqual('', output.get('best'));
		this.assertEqual('234', output.get(''));

		output = ParsedUrl.parseQuery('model=S%26W');
		
		this.assertEqual('S&W', output.get('model'));

		output = ParsedUrl.parseQuery('http://www.haxigniter.com/test.php?ve/ry=useful&quite=handy');
		
		this.assertEqual('useful', output.get('ve/ry'));
		this.assertEqual('handy', output.get('quite'));
	}
}
