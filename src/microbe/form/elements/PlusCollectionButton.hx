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
		
		super("name","label",null,ButtonType.BUTTON);
		
		var transport:Transport = {data:haxe.Unserializer.run(_data),collec:haxe.Unserializer.run(_collec)};
		Xtransport =haxe.Serializer.run(transport);
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

class PlusCollectionButton extends AjaxElement {
	
	public static var debug=false;
	public static var sign:Signal1<Transport>;
	var transport:Transport;
	var elementid:String;
	public function new(list:Microfield,?pos:Int){
		
		super(list);
		id.Alerte();
		sign= new Signal1<Transport>();
		this.elementid=id;
	 var collectionWrapper=new JQuery("#"+this.elementid+pos).parent(".collectionWrapper");
	var me =collectionWrapper.find(".plusCollectionButton");
	//Std.string(me).Alerte();
	transport = cast haxe.Unserializer.run(me.val());
	me.click(onClick);
	
	}
	function onClick(e:JqEvent) : Void {
		"".Alerte();
		//transport.data.Alerte();
		sign.dispatch(transport);
	}
	
}


#end