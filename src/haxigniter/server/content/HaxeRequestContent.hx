package haxigniter.server.content;

import haxe.Serializer;
import haxe.Unserializer;
import haxigniter.server.content.ContentHandler;

class HaxeRequestContent implements ContentHandler
{
	public var mimeType : String;
	public var encoding : String;
	
	public function new()
	{
		this.mimeType = 'application/haxerequest';
		this.encoding = 'application/base64';
	}
	
	public function input(content : ContentData) : Dynamic
	{
		return Unserializer.run(content.data);
	}

	public function output(content : Dynamic) : ContentData
	{
		return {
			mimeType : mimeType,
			charSet : null,
			encoding : encoding,
			data : Serializer.run(content)
		}
	}
}
