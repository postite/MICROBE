#if php
package haxigniter.server.external;

/**
 * How to use: Set your external directory in config.externalPath. Then put the Smarty files 
 * in the <externalPath>/smarty folder.
 * 
 * (The Smarty "libs" folder should be located at <externalPath>/smarty/libs)
 * 
 * Then you need to make a small adjustment to the file 
 * "smarty/libs/internals/core.write_file.php". You need to change this line:
 * 
 *      @unlink($params['filename']);
 * 
 * Into the following:
 * 
 *      if(file_exists($params['filename'])) 
 *            @unlink($params['filename']);
 * 
 * (For more information: http://tylermac.wordpress.com/2009/09/06/haxe-php-smarty-flashdevelop)
 * 
 * When that is done, you can use haxigniter.server.views.Smarty as a ViewEngine.
 * Use Server.requireExternal('smarty/libs/Smarty.class.php') to include it.
 * 
 */
extern class Smarty 
{
	public function new() : Void;

	public function assign(name : String, value : Dynamic) : Void;
	public function clear_assign(name : String) : Void;
	public function get_template_vars(?name : String) : Dynamic;
	
	public function display(template : String, ?cache_id : String, ?compile_id : String) : Void;
	public function fetch(template : String, ?cache_id : String, ?compile_id : String) : String;
	
	public function is_cached(template : String, ?cache_id : String, ?compile_id : String) : String;
	public function template_exists(template : String) : Bool;
	
	/////////////////////////////////////////////////////////////////
	
	public function register_block(name : String, impl : Dynamic, cacheable : Bool, cache_attr : Dynamic) : Void;
	public function register_function(name : String, impl : Dynamic, cacheable : Bool, cache_attr : Dynamic) : Void;
	public function register_modifier(name : String, impl : Dynamic) : Void;
	
	public function register_outputfilter(impl : Dynamic) : Void;
	public function register_postfilter(impl : Dynamic) : Void;
	public function register_prefilter(impl : Dynamic) : Void;
	
	/////////////////////////////////////////////////////////////////
	
	public var template_dir : String;
	public var compile_dir : String;
	public var cache_dir : String;
	
	public var compile_check : Bool;
	public var compile_id : String;
	public var force_compile : String;
	
	public var caching : Int;
	public var cache_lifetime : Int;
}
#end
