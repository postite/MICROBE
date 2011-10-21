package haxigniter.server.content;

import haxigniter.server.content.ContentHandler;

/**
 * Minimal implementation of ContentHandler that outputs what is sent to it.
 * A Controller with this ContentHandler will output the value that is returned from it.
 */
class OutputAllContent implements ContentHandler
{
	public function new() {}
	
	public function input(content : ContentData) : Dynamic
	{
		return content.data;
	}

	public function output(content : Dynamic) : ContentData
	{
		return {
			mimeType : null,
			charSet : null,
			encoding : null,
			data : content
		}
	}
}
