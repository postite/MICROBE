package microbe.form.elements;
/////modele pour composant ///////

#if php

class Fake extends FormElement
{

	

		public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators:Array<Validator>, ?attributes:String) 
		{		
			super();
			this.label = label;
			this.name = name;
			this.value = value;
			this.required = required;
			this.attributes = attributes;
		//	width = 300;
		//	height = 50;
		}

		override public function render(?iter:Int):String
		{
			var n = name;
			
			var s="";
		
			s += "<textarea  name=\"" + n + "\" id=\"" + n + "\" " + attributes + " >" + value + "</textarea>";

			return s;
		}
		public function toString() :String
		{
			return render();
		}
		


	
}
#end



#if js

import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.AjaxElement;
import microbe.form.Microfield;
using  microbe.tools.Debug;
class AjaxArea extends AjaxElement
{
	
	
	public function new(_microfield:Microfield)
	{
		super(_microfield);
		
	}
	

	
	override public function getValue():String{
		var val=new JQuery("#"+id).val();
		val.Alerte();
		return val;
	}
	override public function setValue(val:String):Void{
	val.Alerte();
	new JQuery("#"+id).val(val);
	}
	
}
#end