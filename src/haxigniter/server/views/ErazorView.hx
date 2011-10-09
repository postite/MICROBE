package haxigniter.server.views;
import haxigniter.server.Config;
import php.io.File;
import php.Web;

import erazor.Template;
class ErazorVars
{
	public function new() {}
}

class ErazorView extends ViewEngine
{
	private var templateVars : ErazorVars;
	private var macros : String;
	private var optimized : Bool;
	private var wrappers:List<Template>;
	public var tempo(getTempo,setTempo):String;
	private var _tempo:String;
	
	public function new(config : Config, ?macros : String = null, ?optimized : Bool = false)
	{
		super(config);
		this.templateExtension = 'html';
		wrappers= new List<Template>();
		this.templateVars = new ErazorVars();
		assign("include", function(file,?suppVar:Hash<Dynamic>){	return inRender(file,suppVar);});
		assign("wrap", function(file){  wrap(file);});
		
		//assign("layoutContent","...");
	}
	function setTempo(val:String) : String {
//php.Lib.print("settempo"+val);
		if(wrappers.length>0){
		assign("wrap",null);
		assign("layoutContent",renderString(val));
		tempo=wrappers.pop().execute(templateVars);
		assign("wrap",function(file){ wrap(file);}); //wrap deviuent nulll  pas d'incrementation////
		}
		_tempo=val;
		return _tempo;
	}
	function getTempo() : String {
		return _tempo;
	}
	
	
	public override function assign(name : String, value : Dynamic) : Void
	{
		Reflect.setField(this.templateVars,name,value);
	}

	public override function clearAssign(name : String) : Bool
	{
		return Reflect.deleteField(this.templateVars,name);
	}

	private function wrap(outTemplate):Void{
	
				var t:erazor.Template;
				var fileContent = File.getContent(this.templatePath+outTemplate);
				t = new erazor.Template(fileContent);
				wrappers.add(t);

	}
	private function renderString(t:String):String{	
		var t = new erazor.Template(t);
		return t.execute(this.templateVars);
	}
	private function inRender(inTemplate,?suppVar:Hash<Dynamic>):String{
		//php.Lib.print("templte="+inTemplate);
		if( suppVar != null){
			for (supp in suppVar.keys())
			assign(supp,suppVar.get(supp));
		}
			var t:erazor.Template;
			var fileContent = File.getContent(this.templatePath+inTemplate);
			//php.Lib.print(fileContent);
			t = new erazor.Template(fileContent);
			//	php.Lib.print("tempolite="+t.execute(this.templateVars));
			return t.execute(this.templateVars);
	}
	public override function render (fileName : String) : String
	{

		var fileContent = File.getContent(this.templatePath+fileName);
		var t = new erazor.Template(fileContent);
		tempo=t.execute(this.templateVars);
		return renderString(tempo);
		
	}
}