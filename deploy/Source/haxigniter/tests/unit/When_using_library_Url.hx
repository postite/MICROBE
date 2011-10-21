package haxigniter.tests.unit;

import haxigniter.server.libraries.Url;
import haxigniter.tests.mocks.MockConfig;

class When_using_library_Url extends haxigniter.common.unit.TestCase
{
	private var config : MockConfig;
	private var url : Url;
	
	public override function setup()
	{
		this.config = new MockConfig();
		this.url = new Url(this.config);
	}
	
	public override function tearDown()
	{
	}

	public function test_Then_linkUrl_should_strip_last_slash()
	{
		config.indexPath = '/';
		this.assertEqual('', url.linkUrl());
		
		config.indexPath = '/test/';
		this.assertEqual('/test', url.linkUrl());

		config.indexPath = '/test/test2/';
		this.assertEqual('/test/test2', url.linkUrl());
	}
	
	public function test_Then_siteUrl_should_strip_last_slash()
	{
		this.assertEqual('/index.php', url.siteUrl());
		this.assertEqual('/index.php/test/me', url.siteUrl('test/me'));
		
		config = new MockConfig();
		config.indexFile = '';
		config.indexPath = '/';		
		url = new Url(config);
		
		this.assertEqual('', url.siteUrl());
		this.assertEqual('/test/me', url.siteUrl('test/me'));
	}	
}
