package microbe.form.elements;

#if php

import php.Lib;
import microbe.form.FormElement;


class TestCrossAjax extends FormElement
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
		//<iframe id='upload_target' name='upload_target' src='' style='width:0;height:0;border:0px solid #fff;'></iframe>
		var n = name;
	return "<div id='"+n+"' microbe="+Type.getClassName(TestCrossAjax)+"><img src='' id='preview"+iter+"' > <input type='file' name='fl"+iter+"' id='fileinput' enctype='multipart/form-data'/><input type='hidden' id='retour"+iter+"' value=''><iframe id='upload_target"+iter+"' name='upload_target"+iter+"' src='' style='width:0;height:0;border:0px solid #fff;'></iframe><input type='submit' value='Upload some data' id='uploadButton' /></div>";

	}
}
#end

#if js

import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.AjaxElement;
import microbe.form.Microfield;
using microbe.tools.Debug;
class TestCrossAjax extends AjaxElement
{
	static var debug=false;
	public var self:TestCrossAjax;
	public var formDefaultAction:String;
	public var base_url:String;
	public var uploadtarget:String;
	public function new(_microfield:Microfield,?_iter:Int)
	{
	"".Alerte();
	super(_microfield,_iter);
	self=this;
	//Lib.alert("collectionContainer="+this.getCollectionContainer());
	
	//attention pas CDN proof!
	base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
	//new JQuery("#upload_target").attr('id',this.id+"target");
	//getBouton().bind("click",function(e):Void{Lib.alert("op="+e.target);},{param:"1"});
	//getBouton().click(function(e):Void{Lib.alert("op=");/*testUpload(e);*/});
	getBouton().click(testUpload);
	//getBouton().click=testUpload(e);
	//self.creeIframe();
	//$(this).attr('id',   this.id + '_' + new_id)
	}
	public function init(e:JqEvent) : Void {
		getCollectionContainer();
	}
	
	public function testUpload(e:JqEvent){
			DisableEnableForm();
			
			//trace("yo les gars"+self.id);
			//new JQuery("#"+getIframe()).contents().text("");
		//	Lib.alert("testUpload="+self.id);
			//var preview=getpreview();
			new JQuery("#"+getForm()).attr("target",getIframe());
		//	Lib.alert("formTarget="+new JQuery("#"+getForm()).attr("target"));
			new JQuery("#"+getIframe()).load(onLoad);
			//store l'action par defaut avant de la changer au profit de l'iframe
			formDefaultAction=new JQuery("#"+getForm()).attr("action");
			new JQuery("#"+getForm()).attr("action","http://localhost:8888/index.php/upload");
			new JQuery("#"+getForm()).submit();
		//e.preventDefault();
		//	e.preventDefault(); //	var filename= new JQuery("#"+input).attr('value');
	//	var field=new JQuery("#"+input).attr('name');
	//	new JQuery("#"+getForm()).submit();

		//request("http://localhost:8888/index.php/upload",onUpload);
		}
	 public function onLoad(e:JqEvent){
	//	Lib.alert("onLoad"+getpreview());
		//Lib.alert(new JQuery("#upload_target").context.innerHTML);
		var p=new JQuery("#"+getIframe()).contents().text() ;// getElementsByTagName("body").length;
	//	Lib.alert("onLoad"+p +this);
		//new JQuery(preview).attr("src",p);
		//Lib.alert("host="+Lib.window.location.protocol+Lib.window.location.host);
	//	new JQuery(preview).attr("src","http://localhost:8888/index.php/imageBase/resize/thumb/"+p);
	
	
						//getpreview().attr("src",base_url+"/index.php/imageBase/resize/thumb/"+p);
						//getRetour().attr("value",p);
						setValue(p);
						getpreview().fadeTo(0,0);
						getpreview().fadeTo(600,1);
		
		//restore defaut Action
		//new JQuery("#"+getForm()).attr("action",formDefaultAction);
		enableForm();
			}
			
		public	function DisableEnableForm(){
		//	var idString = new JQuery("#"+this.id +" #fileinput").attr("name")+' = '+getInputName();
		//	Lib.alert("disable!="+new JQuery("#"+getForm()+" #fileinput").attr("name"));
			//new JQuery("#"+getForm()+" #fileinput").attr('disabled', "true");
			new JQuery("#"+getForm()+" input[name!='"+getInputName()+"']").attr('disabled','disabled');
			}
			function enableForm(){
		new JQuery("input").attr('disabled','');
			//	new JQuery("#fileinput").attr('disabled','false');
			}
			
	public function creeIframe(){
		new JQuery("#"+"myFrame").remove();
		new JQuery('<iframe id="myFrame" />').appendTo("body");
	//	new JQuery("#myFrame").appendTo("#"+this.id);
		
	}
	public function getIframe():String{
		var ifr=new JQuery("#"+"upload_target"+getCollectionContainer()).attr("id");
	//	Lib.alert("ifr="+ifr);
		return ifr;
	//	Lib.alert(new JQuery("#myFrame"));
		//return 'myFrame';
				
	}
	public function active(){
		new JQuery("#uploadButton");
	}
	public  function getBouton(){
		return new JQuery("#"+this.id+ " #uploadButton");
	}
	public function getRetour() {
		//champs text retour
		return new JQuery("#"+this.id+ " #retour"+getCollectionContainer());
	}
	
/*	public function getTarget(){
		//iframe
		return new JQuery("#"+this.id+ " #upload_target");
	}*/
	public function getInputName():String{
		return new JQuery("#"+this.id+" #fileinput").attr("name");
	}
	public function getpreview(){
	//	Lib.alert("getPreview="+"#preview"+getCollectionContainer());
		return new JQuery("#"+this.id+ " #preview"+getCollectionContainer());
		
	}
	public function getCollectionContainer():String{
	var p:JQuery =new JQuery("#"+id).parents(".collection");
//	Lib.alert("parent="+p.attr("pos"));
	if( p.attr("pos")!=null){
	return p.attr("pos");
}
return "";
	}
	
	public function setpreview(source:String){
		/*new JQuery("#preview").attr("src",source);
				new JQuery("#preview").fadeTo(0,0);
				new JQuery("#preview").fadeTo(600,1);*/
	//		Lib.alert("source"+source);
			getpreview().css("width","300px");
			getpreview().attr("src",source);
			getpreview().fadeTo(0,0);
			getpreview().fadeTo(600,1);
	}
	override public function getValue():String{
		return new JQuery("#retour"+getCollectionContainer()).attr("value");
	}
	override public function setValue(val:String):Void{
	//	new JQuery("#preview").attr("value",val);
	//getpreview().attr("src",self.base_url+"/index.php/imageBase/resize/thumb/"+val);
	getpreview().attr("src",Lib.window.location.protocol+"//"+Lib.window.location.host+"/index.php/imageBase/resize/thumb/"+val);
	getRetour().attr("value",val);
	}
	override public function output() : String {
		return "yeah from js";
	}
	
}
#end