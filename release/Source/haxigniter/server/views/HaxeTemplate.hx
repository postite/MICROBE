package haxigniter.server.views;

import haxigniter.server.Config;

#if php
import php.io.File;
#elseif neko
import neko.io.File;
#end

class HaxeTemplateVars
{
	public function new() {}
}

class HaxeTemplate extends ViewEngine
{
	private var templateVars : HaxeTemplateVars;
	
	public function new(config : Config)
	{
		super(config);
		this.templateExtension = 'mtt';
		
		this.templateVars = new HaxeTemplateVars();
	}
	
	public override function assign(name : String, value : Dynamic) : Void
	{
		Reflect.setField(this.templateVars, name, value);
	}
	
	public override function clearAssign(name : String) : Bool
	{
		return Reflect.deleteField(this.templateVars, name);
	}
	
	public override function render(fileName : String) : String
	{
		var content = File.getContent(this.templatePath + fileName);
		return new haxe.Template(content).execute(this.templateVars);
	}
}
