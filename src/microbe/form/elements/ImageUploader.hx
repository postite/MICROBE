package microbe.form.elements;

#if php
import microbe.form.elements.IframeUploader;

class ImageUploader extends IframeUploader
{
	static var composantName="ImageUploader";
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
	{
		super(name,label,value,required,validators,attributes);
		
	}
	override function render(?iter:Int):String{
		//<iframe id='upload_target' name='upload_target' src='' style='width:0;height:0;border:0px solid #fff;'></iframe>
		var n = name;
		var str="";
		str+="<div class='imageuploader' id="+n+">";
		str+="<img src='/microbe/css/assets/blankframe.png' id='preview' >";
		str+="<a class='file_input_button'>choisir</a>";

		str+="<input type='file' class='hiddenfileinput' name='"+name+"fl' id='fileinput' enctype='multipart/form-data'/>";
		str+="<input type='hidden' id='retour' value=''>";
		//str+="<iframe id='"+composantName+"upload_target"+iter+"' name='"+composantName+"upload_target"+iter+"' src='' style='width:0;height:0;border:0px solid #fff;'></iframe>";
		str+="<a id='uploadButton' ></a>";
		str+="<a id='cancel'>rien</a>";
		str+="</div>";
		return str;
	//return "<div id='"+n+"' microbe="+Type.getClassName(ImageUploader)+"><img src='' id='imgpreview"+iter+"' > <input type='file' name='img_fl"+iter+"' id='fileinput' enctype='multipart/form-data'/><input type='hidden' id='retour"+iter+"' value=''><iframe id='img_upload_target"+iter+"' name='img_upload_target"+iter+"' src='' style='width:0;height:0;border:0px solid #fff;'></iframe><input type='submit' value='Upload some data' id='uploadButton' /></div>";


	}
}
#end



#if js

import microbe.form.elements.IframeUploader;
import microbe.form.Microfield;
import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.AjaxElement;

import microbe.tools.Debug;

class ImageUploader extends IframeUploader {
	
	static var debug:Bool=true;
	//override public var composantName:String;
	public function new(_microfield:Microfield,?_iter:Int){
		
		super(_microfield,_iter);
	//	super.composantName="ImageUploader";
		//composantName="ImageUploader";
	//	Lib.alert("ImageUploader"+this.id);
		new JQuery("#"+this.id+" .file_input_button").click(onFake);
		new JQuery("#"+this.id+" #cancel").click(onVide);
		//"test".Alerte();
		//Debug.Alerte("retest");
	}
	function onVide(e:JqEvent) 
	{
		setValue(null);
	}
	function onFake(e:JqEvent) : Void {
		e.preventDefault();
		//Lib.alert("yo");
		new JQuery("#"+this.id+" .hiddenfileinput").trigger("click");
	}
	
	///// overrideing le setter un peu pas cool mais peux pas faire autrement. 
	/*override public function setComposant(val:String) : String {
			_composantName="ImageUploader";
			return _composantName;
		}*/
	
	override public function setValue(val:String):Void{
	//	Lib.alert("setValueimageuploader" +val);
		//Lib.alert("composantNAme="+this.composantName);
		if (val!=null){
	getpreview().attr("src",Lib.window.location.protocol+"//"+Lib.window.location.host+"/index.php/imageBase/resize/modele/"+val);
}else{
	getpreview().attr("src","/microbe/css/assets/blankframe.png");
}
	getRetour().attr("value",val);
	
	}
	
		
}
#end
