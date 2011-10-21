#if php
package haxigniter.server.views;

import haxigniter.server.Config;

/**
 * The Smarty template engine can be used by putting the "smarty" folder in config.externalPath. See your Config.hx for more
 * details about that directory.
 * 
 * Because of haXes error handling overriding Smarty, you must ensure a template var is set before using it, or test if it 
 * exists explicitly using isset($var).
 * 
 * IMPORTANT NOTE: For smarty to work in haXe, you need to make a small adjustment to the file "internals/core.write_file.php".
 * You need to change this line:
 * 
 *      @unlink($params['filename']);
 * 
 * Into the following:
 * 
 *      if(file_exists($params['filename'])) 
 *            @unlink($params['filename']);
 * 
 * For more information: http://tylermac.wordpress.com/2009/09/06/haxe-php-smarty-flashdevelop/
 * 
 */
class Smarty extends ViewEngine
{
	private var smartyEngine : haxigniter.server.external.Smarty;

	private var cachePath : String;
	private var cacheId : String;
	
	public function new(config : Config, ?cacheId : String)
	{
		super(config);
		this.templateExtension = 'tpl';
		
		// Include the smarty engine class.
		untyped __call__('require_once', config.externalPath + 'smarty/libs/Smarty.class.php');
		this.smartyEngine = new haxigniter.server.external.Smarty();

		this.cacheId = cacheId;
	}

	private inline function toPhpValue(value : Dynamic) : Dynamic
	{
		// TODO: This is only compatible with 2.05 or better.
		/*
		if(Std.is(value, Hash))
			return php.Lib.associativeArrayOfHash(value);
		else
		*/
		return value;
	}

	public override function assign(name : String, value : Dynamic) : Void
	{
		this.smartyEngine.assign(name, this.toPhpValue(value));
	}
	
	public override function clearAssign(name : String) : Bool
	{
		var exists = this.smartyEngine.get_template_vars(name) != null;
		this.smartyEngine.clear_assign(name);
		
		return exists;
	}

	public override function render(fileName : String) : String
	{
		this.smartyEngine.template_dir = this.templatePath;
		this.smartyEngine.compile_dir = this.compiledPath;

		return this.smartyEngine.fetch(fileName, this.cacheId);
	}
}
#end
