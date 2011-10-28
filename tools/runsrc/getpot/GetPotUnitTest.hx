// Copyright (c) 2009, Jens Peter Secher <jpsecher@gmail.com>
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

package getpot;

class GetPotUnitTest
extends haxe.unit.TestCase
{
	public function testNoArgs()
	{
		var options = new GetPot( [] );
		assertFalse( options.got( ["foo"] ) );
		assertEquals( null, options.next() );
		assertEquals( null, options.unknown() );
		assertEquals( null, options.unprocessed() );
	}
	public function testMultipleArgs()
	{
		var options = new GetPot
		(
			["--move","--in","file1","file2","--out","file3","file4"]
		);
		assertTrue( options.got( ["--move"] ) );
		assertEquals( null, options.next() );
		assertTrue( options.got( ["--out"] ) );
		assertEquals( "file3", options.next() );
		assertEquals( "file4", options.next() );
		assertEquals( null, options.next() );
		assertTrue( options.got( ["--in"] ) );
		assertEquals( "file1", options.next() );
		assertEquals( "file2", options.next() );
		assertEquals( null, options.next() );
		assertEquals( null, options.unknown() );
		assertEquals( null, options.unprocessed() );
	}
	public function testExtras()
	{
		var options = new GetPot
		(
			["file1","file2","-C","file3","--unknown","file4"]
		);
		assertTrue( options.got( ["--check","-C"] ) );
		assertEquals( "--unknown", options.unknown() );
		assertEquals( "file1", options.unprocessed() );
		assertEquals( "file2", options.unprocessed() );
		assertEquals( "file3", options.unprocessed() );
		assertEquals( "file4", options.unprocessed() );
		assertEquals( null, options.unknown() );
	}
	public function testShortLong()
	{
		var options = new GetPot
		(
			["-null","/var","--0"]
		);
		assertTrue( options.got( ["-null","--0"] ) );
		assertTrue( options.got( ["-null","--0"] ) );
		var unprocessed = options.unprocessed();
		assertEquals( "/var", unprocessed );
		assertEquals( null, options.unknown() );
	}
}
