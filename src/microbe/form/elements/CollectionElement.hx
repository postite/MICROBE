package microbe.form.elements;
import microbe.form.FormElement;
import microbe.form.MicroFieldList;
#if php

import microbe.form.Formatter;
import microbe.form.FormElement;
import microbe.form.Form;
import microbe.form.FormElement;
import microbe.form.Validator;
import microbe.form.validators.BoolValidator;
import microbe.form.Formatter;



class CollectionElement extends FormElement

{
	public var realpos:Int;
	public var pos:Int;
	private var inside:List<FormElement>;
	public function new(name:String, label:String,?inside:List<FormElement>,?_pos:Int,?_realpos:Int) 
	{
		super();
		this.name = name;
		this.label = label;
		
		if( _realpos!=null)
		this.realpos=_realpos;
		
		if (inside!=null){
			this.inside=inside;	
			
		}
		if(_pos!=null) pos=_pos;
		/*this.value = value;
				this.required = required;
				this.attributes = attributes;
				this.password = false;*/
		
		/*showLabelAsDefaultValue = false;
				useSizeValues = false;
				printRequired = false;*/
		
	//	width = 180;
	}
	
	override public function render(?_pos:Int):String
	{		
		var n = name;
	/*	var tType:String = password ? "password" : "text";
			
			if (showLabelAsDefaultValue && value == label){
				addValidator(new BoolValidator(false, "Not valid"));
			}
			
			if ((value == null || value == "") && showLabelAsDefaultValue) {
				value = label;
			}	*/	
		
		//var style = useSizeValues ? "style=\"width:" + width + "px\"" : "";
		
		var str="<div class='collection' name='"+n+"' id='"+n+pos+"' pos='"+pos+"' tri='id_"+realpos+"'>";
	//	str+= "<span>length="+inside.length+"</span>";
		
		str+="<button value='delete' type='BUTTON' id='delete"+pos+"' class='deletecollection' >delete</button>";
	
		  for(item in inside){
			//this.form.addElement(item);
			item.form=form;
			//str+=item.test();
		//	str+="<p>"+item.getLabel()+"</p>";
			str+=item.value;
			str+="<div>";
			str+="<label for='"+item.name+"'>"+item.label+"</label>";
			str+=item.render(pos);
			str+="</div>";
			//this.form.removeElement(item);
			}
			str+="</div>";
			
		//var str = "<input " + style + " class=\"" + getClasses() +"\" type=\"" + tType + "\" name=\"" + n + "\" id=\"" + n + "\" value=\"" +safeString(value) + "\"  " + attributes + " />" ;	
		//str += (if (required && form.isSubmitted() && printRequired) " required");
		return str;
		}
}
#end



#if js
import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.AjaxElement;
import microbe.form.elements.PlusCollectionButton;
import microbe.form.Microfield;
import hxs.Signal3;
using microbe.tools.Debug;
class CollectionElement extends AjaxElement
{
	static var debug=false;
	public static var deleteSignal:Signal3<String,String,Int>= new Signal3();
	//public var moduleid:String;
	public var elementid:String;
	public function new(?_liste:MicroFieldList,?_pos:Int)
	{
		"".Alerte();
		
		super(_liste,_pos);
		this.elementid=this.id +_pos;
	Lib.alert("popoop"+ this.elementid);
		//Lib.alert("colectionElemnt>micro="+_pos);
		//Lib.alert("microfield elementId="+this.id+_pos);
		//new JQuery("#delete"+_pos).click(delete);
		new JQuery("#"+this.elementid +" .deletecollection").click(delete);
		//Std.string(plusId).Alerte();
	//	new PlusCollectionButton(plusId);
		//new JQuery("."+"collection").css("background-color","#FF0000");
		
	}
	function delete(e:JqEvent) : Void {
	//	Lib.alert("delete");
		deleteSignal.dispatch(this.elementid,this.voName,this.pos);
	}
	
	public function active(){
		new JQuery("#uploadButton");
	}
	
	override public function getValue():String{
		return new JQuery("#"+id).attr("value");
	}
	override public function setValue(val:String):Void{
	new JQuery("#"+id).attr("value",val);
	}
	
}
#end