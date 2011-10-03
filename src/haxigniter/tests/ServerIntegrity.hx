package haxigniter.tests;

import haxigniter.server.Config;
import haxigniter.server.libraries.Integrity;

#if php
import php.FileSystem;
import php.io.File;
import php.Lib;
import php.Web;
#elseif neko
import neko.FileSystem;
import neko.io.File;
import neko.Lib;
import neko.Web;
#end

class ServerIntegrity extends Integrity
{
	private var config : Config;
	
	public function new(config : Config)
	{
		this.config = config;
		super(this);
	}
	
	public override function run() : Void
	{
		this.printHeader('Development mode: ' + (this.config.development ? 'True' : 'False') + '<br><br>');
		super.run();
	}
	
	/////////////////////////////////////////////////////////////////
	
	public function test1(title : { value : String }) : Bool
	{
		printHeader('[haXigniter] Directory access');
		
		title.value = 'Cache path <b>"' + config.cachePath + '"</b> exists and is writable';
		return this.isWritable(config.cachePath);
	}

	public function test2(title : { value : String }) : Bool
	{
		title.value = 'Log path <b>"' + config.logPath + '"</b> exists and is writable';
		return this.isWritable(config.logPath);
	}

	public function test3(title : { value : String }) : Bool
	{
		title.value = 'Session path <b>"' + config.sessionPath + '"</b> exists and is writable';
		return this.isWritable(config.sessionPath);
	}

	public function test4(title : { value : String }) : Bool
	{
		printHeader('[haXigniter] File integrity');
		
		return fileExistsTest(title, config.runtimePath);
	}

	public function test5(title : { value : String }) : Bool
	{
		return fileExistsTest(title, config.viewPath);
	}

	public function test6(title : { value : String }) : Bool
	{
		return fileExistsTest(title, config.externalPath);
	}
	
	private function fileExistsTest(title : { value : String }, path : String, file = '.htaccess') : Bool
	{
		// Neko cannot handle paths that ends with slash in FileSystem.exists().
		if(StringTools.endsWith(path, '/'))
			path = path.substr(0, path.length - 1);
		
		// Don't test if external path is outside the public web directory.
		if(!FileSystem.exists(path) || path.indexOf(Web.getCwd()) != 0)
			return null;
		
		var htaccess = FileSystem.fullPath(path + '/' + file);

		title.value = '<b>"' + path + '/.htaccess"</b> exists to prevent web access';
		
		return FileSystem.exists(htaccess);		
	}
	
	#if php
	public function test7(title : { value : String }) : Bool
	{
		var smarty = FileSystem.fullPath(config.externalPath + 'smarty/libs/internals/core.write_file.php');

		if(!FileSystem.exists(smarty))
			return null;

		title.value = 'Smarty file <b>"' + smarty + '"</b> is patched according to haxigniter.server.external.Smarty';
		
		var patch : EReg = ~/file_exists\s*\([^\)]*\$params\[['"]filename['"]\]/;
		
		return patch.match(File.getContent(smarty));
	}
	#end
}
