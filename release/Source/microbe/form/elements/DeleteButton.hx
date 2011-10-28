package microbe.form.elements;

#if php
import microbe.form.FormElement;

class DeleteButton extends FormElement
{
 /*var name:String;
 	var label:String;
 */
	public function new(name:String, label:String)
	{
		
		super();
		this.name=name;
		this.label=label;
	
		
		
	}
	override public function render(?iter:Int) :String
	{
		
		return "<button type='BUTTON' class='deletebutton'  id='"+name + "' ><span>" +label + "</span></button>";
	
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
	//	Lib.alert("new Delete boutton"+id);
	//	Lib.alert("YOUHOU");
		new JQuery("#"+this.elementid).bind("click",onClick);
	}
	function onClick(event) : Void {
	//	Lib.alert("delete button click");
		
		//new JQuery("#"+this.elementid).wrap("<div class='tooltip'><span>sure ?</span></div>");
		new JQuery("#"+this.elementid).append("<div class='tooltip'><span>sure ?</span></div>");
		
		var tooltip=new JQuery(".tooltip");
		tooltip.css("top","0");
		
		buttonwidth=cast(new JQuery("#"+this.elementid).outerWidth());
	/*		new JQuery(".tooltip").offset(new JQuery("#"+this.elementid).offset());
		
			start=cast(new JQuery("#"+this.elementid).offset().left);
			var maTween = new Tween(start, start+(buttonwidth/2), 500, Bounce.easeOut);
		    maTween.setTweenHandlers(anime,fini);
		    maTween.start();
			new JQuery("#"+this.elementid).unbind("click");*/
				var maTween = new Tween(start, start+(buttonwidth/2), 500, Bounce.easeOut);
			    maTween.setTweenHandlers(anime,fini);
			    maTween.start();		
			
	}
	function anime(e:Float) : Void {
	//	Lib.alert("e="+e);
		new JQuery(".tooltip").css("left",e+"px");
		
	}
	function fini(e:Float) : Void {
//	Lib.alert("onfini");
	new JQuery("#"+this.elementid +" span").first().text("oui");
	new JQuery("#"+this.elementid).css("width","120px").css("text-align", "left"); ///TODO hackish
	new JQuery("#"+this.elementid).bind("click",onTool);	
	}
	function onTool(e:JqEvent) : Void {
	//	Lib.alert('onTool');
		sign.dispatch();
	}
	
	
	
	
}
#end