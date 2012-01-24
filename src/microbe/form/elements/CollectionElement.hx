package microbe.form.elements;
import microbe.form.FormElement;
import microbe.form.MicroFieldList;
#if php

import microbe.form.Formatter;
import microbe.form.FormElement;
import microbe.form.Form;
import microbe.form.FormElement;
import microbe.form.Validator;
//import microbe.form.validators.BoolValidator;
import microbe.form.Formatter;



class CollectionElement extends FormElement

{
	public var collItemId:Int;
	public var pos:Int;
	private var inside:List<FormElement>;
	public function new(name:String, label:String,?inside:List<FormElement>,?_pos:Int,?_collItemId:Int) 
	{
		super();
		this.name = name;
		this.label = label;
		
		if( _collItemId!=null)
		this.collItemId=_collItemId;
		
		if (inside!=null){
			this.inside=inside;	
			
		}
		if(_pos!=null) pos=_pos;
		
	}
	
	override public function render(?_pos:Int):String
	{		
		var n = name;

		
		var str="<div class='collection' name='"+n+"' id='"+n+pos+"' pos='"+pos+"' tri='id_"+collItemId+"'>";
	//	str+= "<span>length="+inside.length+"</span>";
		str+="<span class='realpos'> realpos="+collItemId+"</span>";
		str+="<span class='pos'> pos="+pos+"</span>";
		str+="<button value='delete' type='BUTTON' id='delete"+pos+"' class='deletecollection' >delete</button>";
	
		  for(item in inside){
			//this.form.addElement(item);
			item.form=form;
			//str+=item.test();
			
			str+=item.value;
			str+="<div>";
			str+="<label for='"+item.name+"'>"+item.label+"</label>";
			str+=item.render(pos);
			str+="</div>";
			//this.form.removeElement(item);
			}
			str+="</div>";
			
		
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
import hxs.Signal4;
using microbe.tools.Debug;
class CollectionElement extends AjaxElement
{
	static var debug=0;
	public static var deleteSignal:Signal4<String,String,Int,Int>= new Signal4();
	//public var moduleid:String;
	public var elementid:String;
	public var collItemId:Int;
	public function new(?_liste:MicroFieldList,?_pos:Int)
	{
		
		
		super(_liste,_pos);
		this.elementid=this.id +_pos;
		this.pos=_pos;
	
		//Lib.alert("colectionElemnt>micro="+_pos);
		//Lib.alert("microfield elementId="+this.id+_pos);
		//new JQuery("#delete"+_pos).click(delete);
		this.collItemId=getCollecItemId(new JQuery("#"+this.elementid).attr("tri"));
		Std.string("collecItemId="+collItemId).Alerte();
		new JQuery("#"+this.elementid +" .deletecollection").bind("click",beforedelete);
		//Std.string(plusId).Alerte();
	//	new PlusCollectionButton(plusId);
		//new JQuery("."+"collection").css("background-color","#FF0000");
		
	}
	
	function getCollecItemId(tri:String):Int{
		var splited= Lambda.list(tri.split("_")).last();
		return Std.parseInt(splited);
	}
	function beforedelete(e:JqEvent){
	var target=	new JQuery(e.target);
	target.attr("id").Alerte();
		target.text("sure?");
		target.unbind("click",beforedelete);
		target.click(delete);
	}
	function delete(e:JqEvent) : Void {
		"delete".Alerte();
		Std.string("id="+collItemId);
		deleteSignal.dispatch(this.elementid,this.voName,this.pos,this.collItemId);
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