package haxigniter.server;

#if php
import php.Web;
import php.Lib;
#elseif neko
import neko.Web;
import neko.Lib;
#end

import haxigniter.common.exceptions.Exception;
import haxigniter.server.exceptions.NotFoundException;

import haxigniter.server.Controller;
import haxigniter.server.content.ContentHandler;

import haxigniter.server.libraries.Server;
import haxigniter.server.libraries.Request;
import haxigniter.server.libraries.Url;

import haxigniter.common.libraries.ParsedUrl;

class Application
{
	public static function run(config : Config, ?errorHandler : Dynamic -> Void) : Controller
	{
		var controller : Controller = null;
		
		try
		{
			var method = Web.getMethod();
			var requestData : ContentData = (method == 'GET') ? null : Server.requestContentFromWeb();
			
			controller = new Request(config).execute(requestUrl(), method, Web.getParams(), requestData, Server.outputContentToWeb);
		}
		catch(e : Dynamic)
		{
			if(errorHandler != null)
			{
				errorHandler(e);
			}
			else if(config.development)
			{
				Lib.rethrow(e);
			}
			else if(Std.is(e, NotFoundException))
			{
				var server = new Server(config);
				server.error404();
			}
			else if(Std.is(e, Exception))
			{
				var fullClass = Type.getClassName(Type.getClass(e));
				logError(config, '[' + fullClass.substr(fullClass.lastIndexOf('.') + 1) + '] ' + e.message, e);				
			}
			else
				logError(config, Std.string(e), e);
		}
		
		return controller;
	}
	
	private static function logError(config : Config, message : String, e : Dynamic)
	{
		var server = new Server(config);
		var debug = new haxigniter.server.libraries.Debug(config);
		var error = genericError(e);
		
		debug.log(message, haxigniter.server.libraries.DebugLevel.error);
		server.error(error.title, error.header, error.message);
	}
	
	public static dynamic function genericError(e : Dynamic) : {title: String, header: String, message: String}
	{
		return { title: 'Page error', header: 'Page error', message: 'Something went wrong during server processing.' };
	}

	private static inline function requestUrl() : String
	{
		var url = Web.getHostName() + Web.getURI();
		var params = Web.getParamsString();
		
		if(params != null && params.length > 0)
			url += '?' + params;
		
		return url;
	}
}
