package controllers;
import microbe.Api;
import haxigniter.server.libraries.Url;
import microbe.controllers.GenericController;
import haxigniter.server.request.BasicHandler;
import haxigniter.server.libraries.LibCurl;
import php.Lib;
import microbe.vo.Spodable;
import php.Utf8;
class Myfront extends GenericController
{
	
	public var jsScript:List<String>;
	public var jsLib:List<String>;
	public var api: Api;
	public var url:Url;
	
	
	
	
	public function new()
	{
		super();
		this.requestHandler = new BasicHandler(this.configuration);
		api= new Api();
		jsLib= new List<String>();
		url = new Url(this.configuration);
	}
	
	function index() : Void {
		
		
		jsLib.add("/js/front.js");
		jsLib.add("/js/VariantesManager.js");
		
		this.view.assign("link", url.siteUrl());
		this.view.assign("jsScript",jsScript);
		this.view.assign("jsLib",jsLib);
		this.view.assign("scope",this);
		this.view.assign("side",null);
		this.view.assign("content",null);
		var content:List<Spodable>= api.getAll("News");
		var tab=Lambda.array(content);
		tab.reverse();
		var orded=Lambda.list(tab);
		this.view.assign("venir",orded);
		this.view.assign("edito", api.getLast("Edito"));
		this.view.display("front.html");
		
	
	}
		public function blog():Void{
			var content= api.getAll("News");
			this.view.assign("venir","content");
		//	this.view.display("blog.html");
		}
		
	
	
		    
	
}