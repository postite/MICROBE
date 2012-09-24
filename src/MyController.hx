 package ;

import config.Database;
import config.Config;

import haxigniter.server.content.ContentHandler;
import haxigniter.server.request.RequestHandler;

import haxigniter.server.request.RestHandler;
import haxigniter.server.session.FileSession;
import haxigniter.server.session.SessionObject;

import haxigniter.server.libraries.Debug;
import haxigniter.server.libraries.DebugLevel;

import haxigniter.server.libraries.Database;
import haxigniter.server.views.ViewEngine;

/**
 * This class is the base controller, parent to all controllers in the application.
 * 
 * It implements haxe.rtti.Infos because some request handlers (BasicHandler and RestHandler) 
 * uses that info to typecast the web input from the web to the controller methods.
 * 
 * NOTE: Controllers called by haXigniter can only have the starting character capitalized!
 *       MyController is never called, so it's excepted.
 */
class MyController implements haxigniter.server.Controller, implements haxe.rtti.Infos
{
	/* --- Starting with the Controller interface implementation --- */
	
	// A request handler, which will determine how the controller will be used in the application.
	// Default request action is to use haxigniter.libraries.server.BasicHandler
	public var requestHandler : RequestHandler;
	
	// A content handler, which can modify the incoming and outgoing request data.
	// Default content handling is to do nothing, let the controller handle the output.
	public var contentHandler : ContentHandler;
	
	/* --- Now for some more application-specific properties --- */

	// A configuration file is required to run the application.
	public var configuration(default, null) : Config;

	// The controllers will use a template engine to render the output.
	public var view(default, null) : ViewEngine;
	
	// Database connection, if needed.
	public var db(default, null) : Database;
	
	// Session handling, if needed.
	public var session(default, null) : config.Session;

	// Debugging
	public var debug : Debug;
	
	/////////////////////////////////////////////////////////////////
	
	// The application configuration file is static, since it used in main().
	private static var appConfig = new Config();
	
	// The database is also static since it is used by all controllers.
	private static var appDb : Database;
	
	// The application session is filebased, could be switched to other implementations.
	private static var appSession = new FileSession(appConfig.sessionPath);

	// A debug object, for tracing and logging.
	private static var appDebug = new Debug(appConfig);
	
	/*
	| Template files are displayed by a ViewEngine, which is any class extending 
	| the haxigniter.views.viewEngine class.
	|
	| The engines currently supplied by haXigniter are:
	|
	|   haxigniter.server.views.Templo() - The Templo 2 engine. (http://haxe.org/com/libs/mtwin/templo)
	|   haxigniter.server.views.HaxeTemplate() - haxe.Template (http://haxe.org/doc/cross/template)
	|   haxigniter.server.views.Smarty() - Smarty, PHP only (http://smarty.net)
	|
	| If you want to use another template system, make a class extending
	| haxigniter.server.views.viewEngine and instantiate it here. Contributions 
	| are always welcome, contact us at haxigniter@gmail.com so we can include
	| your class in the distribution.
	|		
	*/
	//private static var appView = new haxigniter.server.views.Templo(appConfig);

	/*
	 * Application entrypoint
	 */
	public static function main()
	{
		// Configure database depending on development mode.
		if(appConfig.development)
			appDb = new DevelopmentConnection();
		else
			appDb = new OnlineConnection();

		// Set the database debugging so erroneous queries are logged.
		appDb.debug = appDebug;
		
		// *** Run the application ***
		haxigniter.server.Application.run(appConfig);
		
		// Need to do some cleanup after the request is done.
		
		// Close the database
		if(appDb != null)
			appDb.close();
		
		// Close the session, especially important for Neko session which doesn't close 
		// automatically like the PHP session.
		if(appSession != null)
			appSession.close();
	}

	/**
	 * The controllers are automatically created by haxigniter.server.Application.
	 */
	public function new()
	{	
		// Set the controller vars to the static vars, so they can be referenced from the controllers.
		this.configuration = appConfig;
		this.db = appDb;
		this.debug = appDebug; // Will be used in this.trace() and this.log()
		this.view = appView;

		// The session is restored from SessionObject, passing in the interface and the output type.
		this.session = SessionObject.restore(appSession, config.Session);

		// Set the default request handler to a RestHandler.
		// See haxigniter.server.request.RestHandler class for documentation.
		this.requestHandler = new RestHandler(this.configuration);
	}
	
	///// Some useful trace/log methods /////////////////////////////
	
	private function trace(data : Dynamic, ?debugLevel : DebugLevel, ?pos : haxe.PosInfos) : Void
	{
		debug.trace(data, debugLevel, pos);
	}
	
	private function log(message : Dynamic, ?debugLevel : DebugLevel) : Void
	{
		debug.log(message, debugLevel);
	}
}
