package haxigniter.server.libraries;

import haxigniter.server.content.ContentHandler;
import haxigniter.server.session.SessionObject;

#if php
import php.io.Path;
import php.io.File;
import php.Lib;
import php.Web;
import php.Sys;
#elseif neko
import neko.io.Path;
import neko.io.File;
import neko.Lib;
import neko.Web;
import neko.Sys;
#end

import haxigniter.server.Config;

class Server
{
	private var config : Config;
	private var session : SessionObject;
	private var SSLInDevelopmentMode : Bool;
	
	public function new(config : Config, ?session : SessionObject, ?SSLInDevelopmentMode = false)
	{
		this.config = config;
		this.session = session;
		this.SSLInDevelopmentMode = SSLInDevelopmentMode;
	}
	
	#if php
	/**
	 * Convenience method for external libraries.
	 * @param	path
	 */
	public function requireExternal(path : String) : Void
	{
		untyped __call__('require_once', config.externalPath + path);
	}

	/**
	 * Gives access to any php $_SERVER variable.
	 * @param	varName
	 * @return  the variable as a string, or null if variable didn't exist.
	 */
	public static inline function param(parameter : String) : String
	{
		try
		{
			return untyped __var__('_SERVER', parameter);
		}
		catch(e : String)
		{
			return null;
		}
	}
	#end
	
	///// Error handling ////////////////////////////////////////////
	
	public function error404(?title : String, ?header : String, ?message : String) : Void
	{
		// TODO: Multiple languages
		if(title == null)
			title = '404 not found';

		if(header == null) 
			header = title;
		
		if(message == null)
			message = 'The page you requested was not found.';
		
		this.error(title, header, message, 404);
	}
	
	public function error(title : String, header : String, message : String, returnCode : Int = null) : Void
	{
		var errorPage = returnCode == 404 ? config.error404Page : config.errorPage;
		
		if(returnCode != null)
			Web.setReturnCode(returnCode);
		
		if(errorPage == null)
		{
			// Super-simple content-replace of the views/error.html file.
			var content = File.getContent(config.viewPath + 'error.html');
			content = StringTools.replace(content, '::TITLE::', title);
			content = StringTools.replace(content, '::HEADER::', header);
			content = StringTools.replace(content, '::MESSAGE::', message);
			
			Lib.print(content);
		}
		else
		{
			// Error page is specified, so request that controller.
			var request = new Request(config);			
			request.execute(errorPage);			
		}
	}

	///// Redirection ///////////////////////////////////////////////
	
	/**
	 * Redirect to another page. If url is absolute or starting with a slash, a normal redirect is made. Otherwise, siteUrl() is used to create a local redirect.
	 * Note: In order for this function to work it must be used before anything is outputted to the browser, since it utilizes server headers.
	 * @param	?url
	 * @param	?flashMessage
	 * @param	?https
	 * @param	?responseCode
	 */
	public function redirect(?url : String = null, ?flashMessage : String = null, ?https : Bool = null, ?responseCode : Int = null) : Void
	{
		if(flashMessage != null && session != null)
			session.flashVar = flashMessage;

		if(responseCode != null)
			Web.setReturnCode(responseCode);

		var urlLib = new Url(this.config);
			
		if(url == null)
			url = urlLib.siteUrl(urlLib.uriString());
		else if(!StringTools.startsWith(url, '/') && url.indexOf('://') == -1)
			url = urlLib.siteUrl(url);
		
		if(https != null)
			url = (https ? 'https' : 'http') + url.substr(url.indexOf(':'));

        // No SSL redirect in development mode.
        if(config.development && !this.SSLInDevelopmentMode)
            url = StringTools.replace(url, 'https://', 'http://');
		
		Web.redirect(url);
	}
	
	public function forceSsl(ssl = true, ?sslActive : Bool) : Void
	{
		// No SSL redirect in development mode.
		if(config.development && !this.SSLInDevelopmentMode)
			return;

		// Default test
		if(sslActive == null)
			sslActive = Sys.environment().exists('HTTPS') && Sys.environment().get('HTTPS') == 'on';
		
		if((sslActive && ssl) || !(sslActive || ssl))
			return;
		
		this.redirect(null, session != null ? session.flashVar : null, ssl);
	}
	
	/////////////////////////////////////////////////////////////////

	public static function outputContentToWeb(content : ContentData) : Void
	{
		if(content == null) return;
		
		// Format the final output according to response and send it to the client.
		var header = [];

		// Content-Type, including mimetype and charset
		if(content.mimeType != null)
			header.push(content.mimeType);
		if(content.charSet != null)
			header.push('charset=' + content.charSet);
		if(header.length > 0)
			Web.setHeader('Content-Type', header.join('; '));

		// Content-Encoding
		if(content.encoding != null)
			Web.setHeader('Content-Encoding', content.encoding);

		// Content-Length and MD5 should be handled automatically by the server.
		Lib.print(content.data);
	}
	
	public static function requestContentFromWeb() : ContentData
	{
		var contentData = Web.getPostData();
		var contentType = Web.getClientHeader('content-type');
		var contentEncoding = Web.getClientHeader('content-encoding');
		
		return requestContent(contentData, contentType == null ? null : StringTools.trim(contentType), contentEncoding == null ? null : StringTools.trim(contentEncoding));
	}
	
	private static var charsetRegexp = ~/\bcharset=([\w-]+)/;
	
	public static function requestContent(contentData : String, ?contentType : String, ?contentEncoding : String) : ContentData
	{
		var output = {
			mimeType : null,
			charSet : null,
			encoding : contentEncoding,
			data : contentData
		}
		
		if(contentType != null)
		{
			var splitPos = contentType.indexOf(';');
			output.mimeType = StringTools.trim((splitPos == -1) ? contentType : contentType.substr(0, splitPos));
			
			if(charsetRegexp.match(contentType))
				output.charSet = charsetRegexp.matched(1);
		}
		
		return output;
	}
	
	/////////////////////////////////////////////////////////////////
	
	/**
	 * Implementation of the php function dirname(). Return value is without appending slash.
	 * Note: If there are no slashes in path, a dot ('.') is returned, indicating the current directory.
	 * @param	path
	 * @return  given a string containing a path to a file, this function will return the name of the directory.
	 */
	public static function dirname(path : String) : String
	{
		#if php
		return Path.directory(path);
		#elseif neko
		var output = Path.directory(path);
		return output.length == 0 ? '.' : output;
		#end
	}

	/**
	 * Implementation of the php function basename().
	 * Given a string containing a path to a file, this function will return the base name of the file.
	 * 
	 * @param	path
	 * @param   suffix If the filename ends in suffix this will also be cut off.
	 * @return  given a string containing a path to a file, this function will return the name of the directory.
	 */
	public static function basename(path : String, ?suffix : String) : String
	{
		var output = Path.withoutDirectory(path);
		
		if(suffix == null)
			return output;
		else
			return StringTools.endsWith(output, suffix) ? output.substr(0, output.length - suffix.length) : output;
	}
}
