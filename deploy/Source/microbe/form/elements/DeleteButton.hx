package microbe.form.elements;

#if php
import microbe.form.elements.Button;

class DeleteButton extends Button
{

	public function new(name:String, label:String, ?value:String = null, ?type:ButtonType = null,?link:String=null)
	{
		link="javascript: new microbe.form.elements.DeleteButton";
		super(name,label,value,type,link);
		
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

class DeleteButton extends AjaxElement{
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
	//	Lib.alert("YOUHOU");
		new JQuery("#"+this.elementid).bind("click",onClick);
	}
	function onClick(event) : Void {
		new JQuery("body").append("<div class='tooltip'><span>sure ?</span></div>");
		var tooltip=new JQuery(".tooltip");
		
		buttonwidth=cast(new JQuery("#"+this.elementid).outerWidth());
		new JQuery(".tooltip").offset(new JQuery("#"+this.elementid).offset());
	
		start=cast(new JQuery("#"+this.elementid).offset().left);
		var maTween = new Tween(start, start+(buttonwidth/2), 500, Bounce.easeOut);
	    maTween.setTweenHandlers(anime,fini);
	    maTween.start();
		new JQuery("#"+this.elementid).unbind("click");
	}
	function anime(e:Float) : Void {
	//	Lib.alert("e="+e);
		new JQuery(".tooltip").css("left",e+"px");
		
	}
	function fini(e:Float) : Void {
//	Lib.alert("onfini");
	new JQuery("#"+this.elementid).text("oui");
	new JQuery("#"+this.elementid).bind("click",onTool);	
	}
	function onTool(e:JqEvent) : Void {
	//	Lib.alert('onTool');
		sign.dispatch();
	}
	
	
	
	
}
#end