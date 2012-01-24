package config; 

import haxigniter.server.libraries.Debug; import haxigniter.server.libraries.DebugLevel;
#if php
import php.Sys; import php.Web;
#elseif neko
import neko.Sys; import neko.Web;
#end

// ========================================================================
// === Start of configuration file ========================================
// ========================================================================

/*
|--------------------------------------------------------------------------
| Import controllers
|--------------------------------------------------------------------------
| Import all controllers that your application uses here.
|
| This is because dynamic loading of classes in haXe isn't possible, so 
| they have to be defined somewhere to be referenced by the compiler.
|
| The package name ("controllers" as default) must also be specified in the
| controllerPackage setting below.
|
*/
//import controllers.Start;
import controllers.Terazor;
import controllers.Myback;
import controllers.Test;
import controllers.Pipo;
import vo.MicrobeNews;
import vo.Edito;
import controllers.Upload;
import controllers.ImageBase;
import controllers.Myfront;
import controllers.Gap;
import controllers.Login;
import vo.RelationTest;
import vo.ChildTest;

class Config extends haxigniter.server.Config
{
	
	
	
	public var jsPath:String;
	public var cssPath:String;
	public var voPackage:String;
	public var uploadsPath:String;
	public var imagesPath:String;
	public var backjs:String;
	public var frontjsPath:String;
	public var frontcssPath:String;

	
	
	
	/*
	|--------------------------------------------------------------------------
	| Superclass and debugging
	|--------------------------------------------------------------------------
	|
	| If you instantiate with true as argument, the environment will be
	| dumped to screen. Useful for debugging.
	|
	| If you specify a filename instead, the dump will be written to
	| that file IF that file doesn't exist! (A safety since it's called
	| on every page request.)
	|
	*/
	public function new(?dumpEnv : Dynamic)
	{
		
		microbe.tools.Debug.debug=false;
		/*
		|--------------------------------------------------------------------------
		| Development mode
		|--------------------------------------------------------------------------
		|
		| Development mode is used to choose automatically between different 
		| database connections, paths, etc. You should make this setting 
		| auto-detecting, so you can upload the application to a live server 
		| and it should work without changing anything.
		|
		| Here are a few examples how to auto-detect development mode:
		|
		| If you're on a Windows machine when developing and Linux when live:
		|    development = Sys.getEnv('OS') == 'Windows_NT';
		|
		| To test depending on host name: 
		|    development = Web.getHostName() == 'localhost';
		|
		| Or IP address (PHP only):
		|    development = Server.Param('SERVER_ADDR') == '127.0.0.1';
		|
		*/
		development = (Web.getHostName() == 'localhost') || (Web.getHostName() == '127.0.0.1');

		/*
		|--------------------------------------------------------------------------
		| Controller package
		|--------------------------------------------------------------------------
		|
		| Because of the dynamic loading of controllers, you must specify the
		| package name of the controllers here. It should be the same as the
		| imported controllers on the top of this file. No dot at the end.
		|
		|   Example: "myapp.controllers"
		|
		*/
		controllerPackage = 'controllers';

		/*
		|--------------------------------------------------------------------------
		| Default controller
		|--------------------------------------------------------------------------
		|
		| If you want another controller than the default 'start' to be used
		| when the URL is empty, specify it here.
		|
		*/
		defaultController = 'myfront';

		/*
		|--------------------------------------------------------------------------
		| Default controller action
		|--------------------------------------------------------------------------
		|
		| If you want another controller action than the default 'index' to be used
		| when the URL is empty, specify it here.
		|
		*/
		defaultAction = 'index';

		/* ===================================================================== */
		/* === Paths ============================================================*/
		/* ===================================================================== */

		/*
		|--------------------------------------------------------------------------
		| Index file
		|--------------------------------------------------------------------------
		|
		| Filename of the index file. It can be autodetected for PHP, so leave it
		| as null unless you're using mod_rewrite (see below). 
		|
		| If you're using Neko or autodetection doesn't work, the most common value
		| is "index.php" for PHP and "index.n" for Neko.
		|
		| NOTE: If you are using mod_rewrite to remove the index page, set this 
		| value to "" (empty string).
		|
		*/
		#if php
		indexFile = null;
		#elseif neko
		indexFile = 'index.n';
		#end
		
		/*
		|--------------------------------------------------------------------------
		| Index path
		|--------------------------------------------------------------------------
		|
		| This is the absolute web path to your index file. Usually for PHP it can 
		| be autodetected, so you can leave it as null.
		|
		| If you're using Neko or autodetection doesn't work, you must specify it
		| manually. For example, if the index file is located in the folder 
		| "haxigniter" on the web server, indexPath should be set to 
		| "/haxigniter/". If your application is in the root of the web 
		| server, it will be just "/". Remember to include a trailing slash.
		|
		*/
		#if php
		indexPath = null;
		#elseif neko
		indexPath = '/';
		#end

		/*
		|--------------------------------------------------------------------------
		| Application Path
		|--------------------------------------------------------------------------
		|
		| Full server path to the application, is set automatically to the location
		| of the index file location.
		|
		*/
		applicationPath = null;
		
		/*
		|--------------------------------------------------------------------------
		| Views Directory Path
		|--------------------------------------------------------------------------
		|
		| Set to null unless you would like to set something other than the default
		| application/views/ folder. Use a full server path with trailing slash.
		|
		*/
		viewPath = null;
		//viewPath="http://localhost:8888/views/";

		/*
		|--------------------------------------------------------------------------
		| External Resources Path
		|--------------------------------------------------------------------------
		|
		| Some files like PHP libraries needs to be located by haXigniter. This path
		| can be used for these non-compiled resources. If null, it's default value 
		| is applicationPath/external/. Use a full server path with trailing slash.
		|
		*/
		externalPath = null;

		/* === Runtime path =====================================================*/

		/*
		|--------------------------------------------------------------------------
		| Runtime Path
		|--------------------------------------------------------------------------
		|
		| Location of runtime generated files, like logs, cache and session.
		| If null, this will be set to applicationPath/runtime/.
		| 
		| You may want to move this directory outside the web server directory,
		| though the haXigniter project generated by "init" protects this directory
		| using a .htaccess file.
		|
		*/
		runtimePath = null;
		
		/*
		|--------------------------------------------------------------------------
		| Error Logging Directory Path
		|--------------------------------------------------------------------------
		|
		| If null, this will be set to runtimePath/logs/.
		| If you're setting it manually, use a full server path with trailing slash.
		|
		*/
		logPath = null;

		/*
		|--------------------------------------------------------------------------
		| Cache Directory Path
		|--------------------------------------------------------------------------
		|
		| If null, this will be set to runtimePath/cache/.
		| If you're setting it manually, use a full server path with trailing slash.
		|
		*/
		cachePath = null;

		/*
		|--------------------------------------------------------------------------
		| Session Path
		|--------------------------------------------------------------------------
		|
		| If null, this will be set to runtimePath/session/.
		| If you're setting it manually, use a full server path with trailing slash.
		|
		*/
		sessionPath = null;

		/* ===================================================================== */
		/* === Other =========================================================== */
		/* ===================================================================== */

		/*
		|--------------------------------------------------------------------------
		| Controller Router
		|--------------------------------------------------------------------------
		|
		| Every server request must be mapped to a Controller. This is where the
		| Router comes in. It analyzes the request URL and returns a suitable
		| Controller that can be used by the application.
		|
		| If this value is set to null, haxigniter.server.routing.DefaultRouter
		| will be used, which creates a router with the same name as the first
		| request segment, in the controllerPackage package. 
		|
		| A request of "/test/me/123" will create "controllers.Test" for example,
		| if config.controllerPackage is set to "controllers".
		|
		*/
		router = null;
		
		/*
		|--------------------------------------------------------------------------
		| Allowed URL Characters
		|--------------------------------------------------------------------------
		|
		| This lets you specify which characters are permitted within your URLs.
		| When someone tries to submit a URL with disallowed characters they will
		| get a warning message.
		|
		| As a security measure you are STRONGLY encouraged to restrict URLs to
		| as few characters as possible.  By default only these are allowed: 
		|
		| a-z 0-9~%.:_-
		|
		| Set to null to allow all characters -- but only if you are insane.
		|
		| DO NOT CHANGE THIS UNLESS YOU FULLY UNDERSTAND THE REPERCUSSIONS!!
		|
		*/
		permittedUriChars = 'a-z 0-9~%.:_-';

		/*
		|--------------------------------------------------------------------------
		| Error Logging Threshold
		|--------------------------------------------------------------------------
		|
		| You can enable error logging by setting a threshold over Off. The
		| threshold determines what gets logged. Threshold options are:
		|
		|	DebugLevel.off = Disables logging, Error logging TURNED OFF
		|	DebugLevel.error = Error Messages (including PHP errors)
		|	DebugLevel.warning = Warning Messages
		|	DebugLevel.info = Info Messages
		|	DebugLevel.verbose = All Messages
		|
		| For a live site you'll usually only enable Error or Warning otherwise
		| your log files will fill up very fast.
		|
		*/
		logLevel = this.development ? DebugLevel.info : DebugLevel.warning;

		/*
		|--------------------------------------------------------------------------
		| Date Format for Logs
		|--------------------------------------------------------------------------
		|
		| Each item that is logged has an associated date. You can use strftime
		| codes to set your own date formatting.
		|
		*/
		logDateFormat = '%Y-%m-%d %H:%M:%S';

		/*
		|--------------------------------------------------------------------------
		| Error page
		|--------------------------------------------------------------------------
		|
		| haxigniter.server.libraries.Server.error() can be used to display an error page
		| when things go wrong.
		|
		| If you want to call a controller as an error page, set it here. For 
		| example "site/error".
		|
		| If it's set to null, the template in application/views/error.html will
		| be used for display, with a generic error message.
		|
		*/
		errorPage = null;

		/*
		|--------------------------------------------------------------------------
		| Error 404 page
		|--------------------------------------------------------------------------
		|
		| haxigniter.server.libraries.Server.error404() can be used to display the 404
		| error page (not found error). Correct headers are sent automatically.
		|
		| If you want to call a controller as an error page, set it here. For 
		| example "site/error404".
		|
		| If it's set to null, the template in application/views/error.html will
		| be used for display, with a generic error 404 message.
		|
		*/
		error404Page = null;

		/*
		|--------------------------------------------------------------------------
		| Default Language
		|--------------------------------------------------------------------------
		|
		| This determines which set of language files should be used. Make sure
		| there is an available translation if you intend to use something other
		| than english.
		|
		*/
		language = 'english';

		/*
		|--------------------------------------------------------------------------
		| Encryption Key
		|--------------------------------------------------------------------------
		|
		| If you use the Encryption class you MUST set an encryption key.
		|
		*/
		encryptionKey = null;



	/*
			/-------------------------------------------
			/microbe settings
			--------------------------------------------
			*/

			jsPath = "/microbe/js/";
			cssPath = "/microbe/css/";
			backjs="backjs.js";
			voPackage="vo.";
			uploadsPath=applicationPath+"uploads/";
			imagesPath=uploadsPath+"images/";
			
			
			/*
			/-------------------------------------------
				/front Settings
			--------------------------------------------
			*/
			frontjsPath="/js/";
			frontcssPath="/css/";
			
		
		// Set default variables in super class and/or debug if dumpEnv is set.
		super(dumpEnv);
	}
}
