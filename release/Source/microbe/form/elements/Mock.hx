package microbe.form.elements;
#if php
import microbe.form.FormElement;
import microbe.form.elements.AjaxInput;
class Mock extends FormElement
{
	

	
		public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="") 
			{
				super();
				this.name = name;
				this.label = label;
			

				
			}
		override public function render(?iter:Int):String
		{		
			

			var str = "<input  name='" + name + "' id='" + name + "'/>" ;
			str+="<div id='"+name+"test' style='width:30px;height:30px;background: #0af;margin-top:30px'>choisir</div>";
			
			return str;
			}

	}

#end
#if js
import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.AjaxElement;
import microbe.form.Microfield;
import microbe.form.elements.AjaxInput;
using microbe.tools.Debug;
class Mock extends AjaxElement
{
	
	public static var debug=1;
	//public var moduleid:String;
	public function new(_microfield:Microfield)
	{
		super(_microfield);
		this.id.Alerte();
		var pop=new JQuery("#"+this.id+"test").click(onFake);
		//log.console(pop);
	}
	
	
	public function onFake(e:JqEvent) : Void {
		"onFake".Alerte();
	}
	
	override public function getValue():String{
		"".Alerte();
		return new JQuery("#"+id).attr("value");
	
	}
	override public function setValue(val:String):Void{
		"".Alerte();
		
		new JQuery("#"+id).attr("value",val);
	}
	
}

#end