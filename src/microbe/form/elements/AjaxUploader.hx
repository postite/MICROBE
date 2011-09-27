package microbe.form.elements;

#if php

import php.Lib;
import microbe.form.FormElement;


class AjaxUploader extends FormElement
{
	static var composantName="AjaxUploader";
	public var id:String;
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
	{
		
		super();
		this.name = name;
		this.label = label;
		this.value = value;
	 
		
	}
	override function render(?iter:Int):String{
	
		var n = form.name + "_" +name;
		var str="";
		str+="<div id='"+n+"' microbe="+composantName+">";
		str+="<img src='' id='"+composantName+"preview"+iter+"' >";
		str+="<input type='file' name='"+composantName+"fl"+iter+"' id='"+composantName+"fileinput' enctype='multipart/form-data'/>";
		str+="<input type='hidden' id='"+composantName+"retour"+iter+"' value=''>";
		str+="<iframe id='"+composantName+"upload_target"+iter+"' name='"+composantName+"upload_target"+iter+"' src='' style='width:0;height:0;border:0px solid #fff;'></iframe>";
		str+="<input type='submit' value='Upload some data' id='uploadButton' />";
		str+="</div>";
		return str;
	//return "<div id='"+n+"' microbe="+Type.getClassName(TestCrossAjax)+"><img src='' id='preview"+iter+"' > <input type='file' name='fl"+iter+"' id='fileinput' enctype='multipart/form-data'/><input type='hidden' id='retour"+iter+"' value=''><iframe id='upload_target"+iter+"' name='upload_target"+iter+"' src='' style='width:0;height:0;border:0px solid #fff;'></iframe><input type='submit' value='Upload some data' id='uploadButton' /></div>";

	}
}
#end

#if js
	import js.Lib;
	import js.JQuery;
	import js.Dom;
	import microbe.form.AjaxElement;
	import microbe.form.Microfield;

	class AjaxUploader extends AjaxElement
	{
		public var self:AjaxUploader;
		public var formDefaultAction:String;
		public var base_url:String;
		public var uploadtarget:String;
		var _composantName:String;
		public var composantName(getComposant,setComposant):String;
		
		public function new(_microfield:Microfield,?_iter:Int)
		{
	//	Lib.alert("upload init");
		this.composantName="AjaxUploader";
		super(_microfield,_iter);
		self=this;
		base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
		getBouton().click(testUpload);
	
		}
		
		public function init(e:JqEvent) : Void {
			getCollectionContainer();
		}
		
		public function getComposant() : String {
			return _composantName;
		}
		public function setComposant(val:String) : String {
			_composantName=val;
			return _composantName;
		}
		
		
		public function testUpload(e:JqEvent){
				DisableForm();

				formDefaultAction=new JQuery("#"+getForm()).attr("target");
				new JQuery("#"+getForm()).attr("target",getIframe());
				new JQuery("#"+getIframe()).load(onLoad);
				
				//new JQuery("#"+getForm()).attr("action","http://localhost:8888/index.php/upload");
				new JQuery("#"+getForm()).attr("action","/index.php/upload");
				new JQuery("#"+getForm()).submit();
			}
		
		public function onLoad(e:JqEvent){
		
			var p=new JQuery("#"+getIframe()).contents().text() ;// getElementsByTagName("body").length;
		
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
			var retour=new JQuery("#"+this.id+ " #"+this.composantName+"retour"+getCollectionContainer());
		//	Lib.alert("getRetour" +retour.attr("value"));
			return retour;
		}
		public function getInputName():String{
			var inputName= new JQuery("#"+this.id+" #"+this.composantName+"fileinput").attr("name");
		//	Lib.alert("inputName="+inputName);
			return inputName;
		}
		public function getpreview(){
		//	Lib.alert("getPreview="+"#"+this.composantName+"preview"+getCollectionContainer());
			return new JQuery("#"+this.id+ " #"+this.composantName+"preview"+getCollectionContainer());

		}
		public function getCollectionContainer():String{
		var p:JQuery =new JQuery("#"+id).parents(".collection");
	//	Lib.alert("parent="+p.attr("pos"));
			if( p.attr("pos")!=null){
				return p.attr("pos");
			}
		return "";
		}
		public function getIframe():String{
			var ifr=new JQuery("#"+this.composantName+"upload_target"+getCollectionContainer()).attr("id");
		//	Lib.alert("ifr="+ifr);
			return ifr;
		//	Lib.alert(new JQuery("#myFrame"));
			//return 'myFrame';

		}
		////////////
		
		
		
		
		
		public	function DisableForm(){
		//	var idString = new JQuery("#"+this.id +" #fileinput").attr("name")+' = '+getInputName();
		//	Lib.alert("disable!="+new JQuery("#"+getForm()+" #fileinput").attr("name"));
			//new JQuery("#"+getForm()+" #fileinput").attr('disabled', "true");
			new JQuery("#"+getForm()+" input[name!='"+getInputName()+"']").attr('disabled','disabled');
		}
		function enableForm(){
		new JQuery("input").attr('disabled','');
			//	new JQuery("#fileinput").attr('disabled','false');
		}
		
		//////////data values/////////
		
		override public function getValue():String{
			var retour=getRetour().attr("value");
			//Lib.alert("retour="+getRetour()+":"+retour); 
			return retour;
		}
		override public function setValue(val:String):Void{
		//	Lib.alert("setValue" +val);
		//		Lib.alert("composantNAme="+this.composantName);
		getpreview().attr("src",Lib.window.location.protocol+"//"+Lib.window.location.host+"/index.php/imageBase/resize/thumb/"+val);
		getRetour().attr("value",val);
		}
		//////////////////////////////
}
#end		