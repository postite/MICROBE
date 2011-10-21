package haxigniter.tests.mocks;

import haxigniter.server.libraries.Debug; 
import haxigniter.server.libraries.DebugLevel;

#if php
import php.Sys; import php.Web;
#elseif neko
import neko.Sys; import neko.Web;
#end

class MockConfig extends haxigniter.server.Config
{
	public function new(?dumpEnv : Dynamic)
	{
		development = false;
		
		controllerPackage = 'haxigniter.tests.unit';
		defaultController = 'start';
		defaultAction = 'index';

		indexFile = 'index.php';
		indexPath = '/';

		applicationPath = null;		
		viewPath = null;
		
		logPath = null;
		cachePath = null;
		sessionPath = null;

		permittedUriChars = 'a-z 0-9~%.:_-';

		logLevel = this.development ? DebugLevel.info : DebugLevel.warning;
		logDateFormat = '%Y-%m-%d %H:%M:%S';

		errorPage = null;
		error404Page = null;

		language = 'english';

		encryptionKey = null;
		
		// Set default variables in super class.
		super(dumpEnv);
	}
}
