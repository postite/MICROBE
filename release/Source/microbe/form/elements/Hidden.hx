package microbe.form.elements;


#if php
import microbe.form.Formatter;
import microbe.form.FormElement;
import microbe.form.Form;
import microbe.form.FormElement;
import microbe.form.Validator;
import microbe.form.validators.BoolValidator;
import microbe.form.Formatter;

class Hidden extends FormElement
{

	public var password:Bool;
	public var width:Int;
	public var showLabelAsDefaultValue:Bool;
	public var useSizeValues:Bool;
	public var printRequired:Bool;
	
	public var formatter:Formatter;
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="") 
	{
		super();
		this.name = name;
		this.label = label;
		this.value = value;
		this.required = required;
		this.attributes = attributes;
		this.password = false;
		
		showLabelAsDefaultValue = false;
		useSizeValues = false;
		printRequired = false;
		
		width=180;
	}
	override public function render(?iter:Int):String
	{		
		var n = name;
		

		var str = "<input   type='hidden' name=\"" + n + "\" id=\"" + n + "\" value=\"\"  " + attributes + " />" ;
		
		str += (if (required && form.isSubmitted() && printRequired) " required");
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

class Hidden extends AjaxElement
{
	
	public var moduleid:String;
	public function new(_microfield:Microfield)
	{
		super(_microfield);
	
		
	}
	
	
	
	override public function getValue():String{
		return new JQuery("#"+id).attr("value");
	}
	override public function setValue(val:String):Void{
		Lib.alert("val="+val);
	new JQuery("#"+id).attr("value",val);
	}
	
}
#end