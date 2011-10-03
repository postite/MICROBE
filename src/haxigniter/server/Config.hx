package haxigniter.server; 

import haxigniter.server.libraries.Debug;
import haxigniter.server.libraries.DebugLevel;
import haxigniter.server.libraries.Server;
import haxigniter.server.routing.Router;
import haxigniter.server.views.ViewEngine;

#if php
import php.Web;
import php.Lib;
import php.Sys;
#elseif neko
import neko.Web;
import neko.Lib;
import neko.Sys;
#end

class Config
{
	public var development : Bool;
	public var controllerPackage : String;

	public var indexFile : String;
	public var indexPath : String;
	
	public var applicationPath : String;
	public var viewPath : String;
	public var externalPath : String;
	
	public var runtimePath : String;
	public var logPath : String;
	public var cachePath : String;
	public var sessionPath : String;
	
	public var permittedUriChars : String;
	public var logLevel : DebugLevel;
	public var logDateFormat : String;
	
	public var errorPage : String;
	public var error404Page : String;
	
	public var language : String;
	public var encryptionKey : String;
	
	public var defaultController(default, null) : String;
	public var defaultAction(default, null) : String;
	
	public var router : Router;
	
	public var view : ViewEngine;
	
	/**
	 * Setting non-initialized constants.
	 */
	private function new(?debug : Dynamic)
	{
		var env = Sys.environment();
		
		if(this.applicationPath == null)
		{
			applicationPath = Web.getCwd();
		}

		if(this.indexFile == null)
		{
			if(env.exists('SCRIPT_NAME'))
			{
				this.indexFile = Server.basename(env.get('SCRIPT_NAME'));
			}
			else
			{
				throw 'indexFile cannot be auto-detected. Please set it in "application/config/Config.hx".';
			}
		}

		if(this.indexPath == null)
		{
			if(env.exists('SCRIPT_NAME'))
			{
				var script = env.get('SCRIPT_NAME');
				this.indexPath = script.substr(0, script.lastIndexOf('/') + 1);
			}
			else
			{
				throw 'indexPath cannot be auto-detected. Please set it in "application/config/Config.hx".';
			}
		}
		
		// Other paths that can be specified in config.
		if(this.viewPath == null)
		{
			this.viewPath = this.applicationPath + 'views/';
		}
		
		if(this.externalPath == null)
		{
			this.externalPath = this.applicationPath + 'external/';
		}

		// Set runtime path based on application path.
		if(this.runtimePath == null)
		{
			this.runtimePath = this.applicationPath + 'runtime/';
		}

		if(this.cachePath == null)
		{
			this.cachePath = this.runtimePath + 'cache/';
		}
		
		if(this.logPath == null)
		{
			this.logPath = this.runtimePath + 'logs/';
		}

		if(this.sessionPath == null)
		{
			this.sessionPath = this.runtimePath + 'session/';
		}
		
		/////////////////////////////////////////////////////////////
		
		if(this.defaultController == null)
		{
			this.defaultController = 'start';
		}

		if(this.defaultAction == null)
		{
			this.defaultAction = 'index';
		}
		
		// Create a default router if not set.
		if(this.router == null)
		{
			router = new haxigniter.server.routing.DefaultRouter();
		}

		if(debug != null)
			this.dumpEnvironment(debug);
	}

	///// Debug method //////////////////////////////////////////////
	
	public function dumpEnvironment(?logFile : Dynamic) : Void
	{
		var date = DateTools.format(Date.now(), '%Y-%m-%d %H:%M:%S');
		var output = '';
			
		output += "*** [" + date + "] Start of dump\n";

		output += "\nhaXigniter configuration:\n\n";
		for(field in Reflect.fields(this))
		{
			// Skip the sensitive parts
			if(field == 'encryptionKey') continue;
			
			output += field + ": '" + Reflect.field(this, field) + "'\n";
		}
		
		output += "\nhaXe web environment ";
		#if php
		output += "(PHP)";
		#elseif neko
		output += "(Neko)";
		#end
		output += ":\n\n";
		output += 'getCwd(): \'' + Web.getCwd() + "'\n";
		output += 'getHostName(): \'' + Web.getHostName() + "'\n";
		output += 'getURI(): \'' + Web.getURI() + "'\n";
		output += 'getParamsString(): \'' + Web.getParamsString() + "'\n";
		
		output += "\nServer environment:\n\n";
		for(field in Sys.environment().keys())
		{
			output += field + ": '" + Sys.environment().get(field) + "'\n";
		}

		#if php
		output += "\nPHP environment:\n\n";
		untyped __call__('ob_start');
		untyped __php__('foreach($_SERVER as $_dk => $_dv) echo "$_dk: \'$_dv\'\n";');
		output += untyped __call__('ob_get_clean');
		#end

		output += "\n*** End of dump";
		
		if(!Std.is(logFile, String))
		{
			output = '<hr><pre>' + output + '</pre><hr>';
			Lib.print(output);
		}
		else
		{
			#if php
			if(!php.FileSystem.exists(logFile))
				php.io.File.putContent(logFile, output);
			#elseif neko
			if(!neko.FileSystem.exists(logFile))
			{
				var file = neko.io.File.write(logFile, false);
				file.writeString(output);
				file.close();
			}
			#end
		}
	}
}
