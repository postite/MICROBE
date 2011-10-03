package microbe.form.elements;



 typedef Transport =
{
	var data:String; //HTMLDOM;
	var collec:MicroFieldList;
}

#if php
import microbe.form.elements.Button;
class PlusCollectionButton extends Button
{
	
	var Xtransport:String;
	
	public function new(?_data:String,_collec:String)
	{
		
		super("name","plus",null,ButtonType.BUTTON);
		
		var transport:Transport = {data:haxe.Unserializer.run(_data),collec:haxe.Unserializer.run(_collec)};
		var nom=transport.collec.voName+"_"+transport.collec.field;
		this.name=nom+"_"+label;
		Xtransport=haxe.Serializer.run(transport);
	}
	override public function render(?iter:Int):String{
		return "<button type=\"" + type + "\" class=\"" + getClasses() +"\" name=\"" +form.name + "_" +name + "\" id=\"" +form.name + "_" +name + "\" value=\"" + Xtransport + "\"  >" +label + "</button>";
		
	}
	
}
#end

#if js
import microbe.form.Microfield;
import microbe.form.AjaxElement;
import hxs.Signal1;
import js.JQuery;
using microbe.tools.Debug;

class PlusCollectionButton  {
	
	public static var debug=1;
	
	
	public static var sign:Signal1<String>;
	public static var cont:Int=0;
	var transport:Transport;
	var elementid:String;
	var me:JQuery;
	
	public function new(_me:JQuery){
		me=_me;
		//var transport ={data:"POp",}
		sign= new Signal1<String>();
			/*	this.elementid=this.id;
				Std.string(this.elementid).Alerte();	
				var collectionWrapper=new JQuery("#"+this.elementid+"_plus").parent(".collectionWrapper");
				me =collectionWrapper.find(".plusCollectionButton");
				Std.string(collectionWrapper.attr("class")).Alerte();
				me.click(onClick);
				Std.string(me).Alerte();*/
		}
	function onClick(e:JqEvent) : Void {
	//	e.stopPropagation();
		e.stopImmediatePropagation();
	//	e.preventDefault();
		//transport.data.Alerte();
	//	transport = cast haxe.Unserializer.run(me.val());
	
		sign.dispatch("transport");
		Std.string(cont).Alerte();
		cont++;
	}
	public function init(){
			
			me.click(onClick);
	}
	public static function create(classe:String):String{
		return '<button type="BUTTON" class="'+classe+'">plus</button>';
	}
	
}


#end