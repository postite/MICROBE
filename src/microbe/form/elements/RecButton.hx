package microbe.form.elements;

#if php
import microbe.form.FormElement;

class RecButton extends Button
{
 /*var name:String;
 	var label:String;
 */
	public function new(name:String, label:String, ?value:String = null, ?type:Button.ButtonType = null,?link:String=null)
	{
		
		super(name,label,value,type,link);
		this.name=name;
		this.label=label;
	
		
		
	}
	override public function render(?iter:Int) :String
	{
		var _onClick = "";
		if (link != null) {
		// _onClick = " onclick=\"window.location.href='" + link + "'\""; TODO: j'ai cassé un truc mais je sais plus quoi
			_onClick = " onclick="+link;
		}
		return "<button type=\"" + type + "\" class=\"" + getClasses() +"\" name=\"" +form.name + "_" +name + "\" id=\"" +form.name + "_" +name + "\" value=\"" + value + "\" " + _onClick+" >" +label + "</button>";
	//	return "<button type=\""+type+">" +label+ "</button>";
	}
}
#end
#if js


import hxs.Signal;
import js.Lib;
import js.JQuery;
import feffects.Tween;
import feffects.easing.Bounce;
import js.Dom.HtmlDom;

class RecButton extends AjaxElement{
	private var elementid:String;
		public static var sign:Signal;
		private var tooltip:JQuery;
		var start:Int;
		var buttonwidth:Float;
	
	public function new(id:String)
	{
		
		super(null);
		sign= new Signal();
		
		this.elementid=id;
	//	Lib.alert("new Delete boutton"+id);
	//	Lib.alert("YOUHOU");
		new JQuery("#"+this.elementid).bind("click",onClick);
	}
	function onClick(event) : Void {
	//	Lib.alert("delete button click");
		microbe.jsTools.BackSignal.preredirect.add(AfterRec);
		//new JQuery("#"+this.elementid).wrap("<div class='tooltip'><span>sure ?</span></div>");
		new JQuery("#"+this.elementid).css("background","red");
				
			
	}

	function AfterRec(d) 
	{
		new JQuery("#"+this.elementid).css("background","");
	}
	
	
	
}
#end