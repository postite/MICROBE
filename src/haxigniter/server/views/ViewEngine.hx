package haxigniter.server.views;

import haxe.PosInfos;
import haxigniter.server.Config;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#end

import haxigniter.server.Application;
import haxigniter.server.libraries.Server;

/**
 * This is an abstract class which is the base of the views of haXigniter.
 * The following methods needs to be implemented:
 * 
 * assign(name : String, value : Dynamic)
 * clearAssign(name : String)
 * render(content : String)
 * 
 * And this var must be set:
 * 
 * templateExtension : String
 * 
 */
class ViewEngine
{
	// TODO: Caching system for ViewEngine
	public var templatePath : String;
	public var compiledPath : String;
	
	/**
	 * Template file extension, without dot. Used in displayDefault().
	 */
	public var templateExtension : String;
	
	private function new(config : Config)
	{
		this.templatePath = config.viewPath;			
		this.compiledPath = config.cachePath;
	}
	
	public function assign(name : String, value : Dynamic) : Void
	{
		throw 'Assign() must be implemented in an inherited class.';
	}
	
	public function clearAssign(name : String) : Bool
	{
		throw 'ClearAssign() must be implemented in an inherited class.';
		return null;
	}
	
	public function render(fileName : String) : String
	{
		throw 'Render() must be implemented in an inherited class.';
		return null;
	}
	
	public function display(fileName : String) : Void
	{
		Lib.print(this.render(fileName));
	}
	
	/**
	 * Uses information from the last called method to display a view.
	 * It displays the view "classname/method.EXT" where EXT is templateExtension. All lowercase.
	 * @param	?pos Information about last called method, usually this should be left blank.
	 */
	public function displayDefault(?pos : PosInfos) : Void
	{
		var className = pos.className.substr(pos.className.lastIndexOf('.')+1).toLowerCase();
		this.display(className + '/' + pos.methodName + '.' + this.templateExtension);
	}
}
