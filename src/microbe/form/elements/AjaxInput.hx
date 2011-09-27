package microbe.form.elements;


#if php
import microbe.form.Formatter;
import microbe.form.FormElement;
import microbe.form.Form;
import microbe.form.FormElement;
import microbe.form.Validator;
import microbe.form.validators.BoolValidator;
import microbe.form.Formatter;

class AjaxInput extends FormElement
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
		
		width = 180;
	}
	override public function render(?iter:Int):String
	{		
		var n = form.name + "_" +name;
		var tType:String = password ? "password" : "text";
		
		if (showLabelAsDefaultValue && value == label){
			addValidator(new BoolValidator(false, "Not valid"));
		}
		
		if ((value == null || value == "") && showLabelAsDefaultValue) {
			value = label;
		}		
		
		var style = useSizeValues ? "style=\"width:" + width + "px\"" : "";
		
		var str = "<input " + style + " class=\"" + getClasses() +"\" type=\"" + tType + "\" name=\"" + n + "\" id=\"" + n + "\" value=\"" +safeString(value) + "\"  " + attributes + " />" ;
		
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

class AjaxInput extends AjaxElement
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
	
	new JQuery("#"+id).attr("value",val);
	}
	
}
#end