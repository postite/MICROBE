package haxigniter.tests.unit;

import haxigniter.server.libraries.Server;

class When_using_library_Server extends haxigniter.common.unit.TestCase
{
	public function test_Then_basename_should_work_as_in_php()
	{
		var filename : String;
		
		filename = '/test/file.txt';
		this.assertEqual('file.txt', Server.basename(filename));

		filename = '/file2.txt';
		this.assertEqual('file2.txt', Server.basename(filename));

		filename = 'file2.txt';
		this.assertEqual('file2.txt', Server.basename(filename));

		filename = '/test/file.txt';
		this.assertEqual('file', Server.basename(filename, '.txt'));
		
		filename = 'file2.txt';
		this.assertEqual('file2', Server.basename(filename, '.txt'));
	}
	
	public function test_Then_request_content_should_return_proper_ContentData()
	{
		var output = Server.requestContent('abcdefg', ' application/test-this-encoding; charset=VERY-COMPLICATED ', 'lha');
		
		this.assertEqual('application/test-this-encoding', output.mimeType);
		this.assertEqual('VERY-COMPLICATED', output.charSet);
		this.assertEqual('lha', output.encoding);
		this.assertEqual('abcdefg', output.data);
		
		output = Server.requestContent('aabbcc', 'text/html', null);
		
		this.assertEqual('text/html', output.mimeType);
		this.assertEqual(null, output.charSet);
		this.assertEqual(null, output.encoding);
		this.assertEqual('aabbcc', output.data);
	}
}
