package haxigniter.server.libraries;

import haxigniter.common.libraries.Mime;

#if php
import php.Web;
import php.Lib;
#elseif neko
import neko.Web;
import neko.Lib;
#end

class Download
{
	#if (php || neko)
	public static function forceDownload(data : Dynamic, ?fileName : String, ?mimeType : String) : Void
	{
		var isIe : Bool = false;
		
		// Test if IE
		var userAgent = Web.getClientHeader('User-Agent');
		if(userAgent != null)
		{
			isIe = userAgent.indexOf('MSIE') >= 0;
		}
		
		// TODO: Need to enclose Lib.print in an anonymous function until http://code.google.com/p/haxe/issues/detail?id=34 is fixed.
		new Download(function(output : Dynamic) { Lib.print(output); }, Web.setHeader, Mime.type, isIe).force(data, fileName, mimeType);
	}
	#end
	
	public var output : Dynamic -> Void;
	public var header : String -> String -> Void;
	public var mimeTypeFunc : String -> String;
	public var isIe : Bool;
	
	public function new(output : Dynamic -> Void, ?header : String -> String -> Void, ?mimeTypeFunc : String -> String, ?isIe = false)
	{
		this.output = output;
		this.header = header;
		this.mimeTypeFunc = mimeTypeFunc;
		this.isIe = isIe;
	}
	
	public function force(data : Dynamic, ?fileName : String, ?specifiedMimeType : String) : Void
	{
		var mimeType = (specifiedMimeType != null) ? specifiedMimeType : 'application/octet-stream';

		// If no mime but a filename exists, search for the extension in the mimetypes.
		if(specifiedMimeType == null && fileName != null && mimeTypeFunc != null)
		{
			var extensionTest = ~/\.(\w+)$/;
			
			if(extensionTest.match(fileName))
			{
				mimeType = mimeTypeFunc(extensionTest.matched(1));
			}
		}
		
		if(header != null)
		{
			header('Content-Type', mimeType);
			
			var contentHeader = 'attachment';
			if(fileName != null)
			{
				contentHeader += '; filename="' + StringTools.replace(fileName, '"', '\\"') + '"';
			}			
			header('Content-Disposition', contentHeader);

			if(isIe)
			{
				header('Expires', '0');
				header('Cache-Control', 'must-revalidate, post-check=0, pre-check=0');
				header('Pragma', 'public');
			}
			else
			{
				header('Expires', '0');
				header('Pragma', 'no-cache');
			}
			
			header('Content-Transfer-Encoding', 'binary');
			
			if(Std.is(data, String))
				header('Content-Length', Std.string(cast(data, String).length));
		}
		
		output(data);
	}
}