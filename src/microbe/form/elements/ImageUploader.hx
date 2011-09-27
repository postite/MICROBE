package microbe.form.elements;

#if php
import microbe.form.elements.AjaxUploader;

class ImageUploader extends AjaxUploader
{
	static var composantName="ImageUploader";
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
	{
		super(name,label,value,required,validators,attributes);
		
	}
	override function render(?iter:Int):String{
		//<iframe id='upload_target' name='upload_target' src='' style='width:0;height:0;border:0px solid #fff;'></iframe>
		var n = form.name + "_" +name;
		var str="";
		str+="<div id='"+n+"' class='imageuploader' microbe="+composantName+" >";
		str+="<img src='' id='"+composantName+"preview"+iter+"' >";
		str+='<a class="file_input_button" >choisir</a>';
		str+="<input type='file' class='hiddenfileinput' name='"+composantName+"fl"+iter+"' id='"+composantName+"fileinput' enctype='multipart/form-data'/>";
		str+="<input type='hidden' id='"+composantName+"retour"+iter+"' value=''>";
		str+="<iframe id='"+composantName+"upload_target"+iter+"' name='"+composantName+"upload_target"+iter+"' src='' style='width:0;height:0;border:0px solid #fff;'></iframe>";
		str+="<a id='uploadButton' ></a>";
		str+="</div>";
		return str;
	//return "<div id='"+n+"' microbe="+Type.getClassName(ImageUploader)+"><img src='' id='imgpreview"+iter+"' > <input type='file' name='img_fl"+iter+"' id='fileinput' enctype='multipart/form-data'/><input type='hidden' id='retour"+iter+"' value=''><iframe id='img_upload_target"+iter+"' name='img_upload_target"+iter+"' src='' style='width:0;height:0;border:0px solid #fff;'></iframe><input type='submit' value='Upload some data' id='uploadButton' /></div>";


	}
}
#end



#if js

import microbe.form.elements.AjaxUploader;
import microbe.form.Microfield;
import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.AjaxElement;

import microbe.tools.Debug;

class ImageUploader extends AjaxUploader {
	
	static var debug:Bool=true;
	//override public var composantName:String;
	public function new(_microfield:Microfield,?_iter:Int){
		
		super(_microfield,_iter);
	//	super.composantName="ImageUploader";
		//composantName="ImageUploader";
		new JQuery(".file_input_button").click(onFake);
		//"test".Alerte();
		//Debug.Alerte("retest");
	}
	function onFake(e:JqEvent) : Void {
		e.preventDefault();
		//Lib.alert("yo");
		new JQuery(".hiddenfileinput").trigger("click");
	}
	
	///// overrideing le setter un peu pas cool mais peux pas faire autrement. 
	override public function setComposant(val:String) : String {
		_composantName="ImageUploader";
		return _composantName;
	}
	
	override public function setValue(val:String):Void{
		//Lib.alert("setValue" +val);
		//Lib.alert("composantNAme="+this.composantName);
	getpreview().attr("src",Lib.window.location.protocol+"//"+Lib.window.location.host+"/index.php/imageBase/resize/modele/"+val);
	getRetour().attr("value",val);
	
	}
	
		
}
#end
