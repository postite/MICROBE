package microbe.form.elements;

#if php

import php.Lib;
import microbe.form.FormElement;


class IframeUploader extends FormElement
{
	
	public var id:String;
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
	{
		
		super();
		this.name = name;
		this.label = label;
		this.value = value;
	 
		
	}
	override function render(?iter:Int):String{
	
		var n = name;
		var str="";
		str+="<div id='"+n+"' microbe=''>";
		str+="<img src='/microbe/css/assets/blankframe.png' id='preview' >";
		str+="<input type='file' name='"+n+"fl' id='fileinput' enctype='multipart/form-data'/>";
		str+="<input type='hidden' id='retour' value=''>";
		str+="<input type='submit' value='Upload some data' id='uploadButton' />";
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
	import microbe.form.Microfield;

	class IframeUploader extends AjaxElement
	{
		public var self:IframeUploader;
		public var formDefaultAction:String;
		public var base_url:String;
		public var uploadtarget:String;
	
		
		public function new(_microfield:Microfield,?_iter:Int)
		{
	
		super(_microfield,_iter);
		//self=this;
		base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
		getBouton().click(testUpload);
		
		}
		
		public function init(e:JqEvent) : Void {
			//getCollectionContainer();
		}
		
		
		
		public function testUpload(e:JqEvent){
				DisableForm();

				formDefaultAction=new JQuery("#"+getForm()).attr("target");
				
				var iframe="<iframe id='uploadtarget' name='uploadtarget' style='width:0;height:0;border:0px solid #fff;'></iframe>";
				new JQuery("#"+this.id).append(iframe);
				new JQuery("#"+getForm()).attr("target","uploadtarget");
			
				new JQuery("#"+this.id+" #"+getIframe()).load(onLoad);
				
				
				new JQuery("#"+getForm()).attr("action","/index.php/upload");
				new JQuery("#"+getForm()).submit();
			}
		
		public function onLoad(e:JqEvent){
		
			var p=new JQuery("#"+this.id+" #"+getIframe()).contents().text() ;// getElementsByTagName("body").length;
			new JQuery("#"+this.id+ " #"+getIframe()).remove();
			setValue(p);
			getpreview().fadeTo(0,0);
			getpreview().fadeTo(600,1);

			//restore defaut Action
			new JQuery("#"+getForm()).attr("target",formDefaultAction);
			enableForm();
		}
		
		///getters///
		
		public  function getBouton(){
			return new JQuery("#"+this.id+ " #uploadButton");
		}
		
		public function getRetour():JQuery {
			//champs text retour
			var retour=new JQuery("#"+this.id+ " #retour");
			return retour;
		}
		public function getInputName():String{
			var inputName= new JQuery("#"+this.id+" #fileinput").attr("name");
			return inputName;
		}
		public function getpreview(){
			return new JQuery("#"+this.id+ " #preview");

		}

		public function getIframe():String{

			return "uploadtarget";
		

		}
		////////////
		
		
		
		
		
		public	function DisableForm(){
		
			new JQuery("#"+getForm()+" input[name!='"+getInputName()+"']").attr('disabled','disabled');
		}
		function enableForm(){
		new JQuery("input").attr('disabled','');
		
		}
		
		//////////data values/////////
		
		override public function getValue():String{
			var retour=getRetour().attr("value");
			
			return retour;
		}
		override public function setValue(val:String):Void{
		
	
			if (val!=null){
		getpreview().attr("src",Lib.window.location.protocol+"//"+Lib.window.location.host+"/index.php/imageBase/resize/thumb/"+val);
	}else{
		getpreview().attr("src","/microbe/css/assets/blankframe.png");
	}
		getRetour().attr("value",val);
		}
		//////////////////////////////
}
#end