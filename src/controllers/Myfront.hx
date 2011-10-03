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
		this.view.assign("link", url.siteUrl());
		this.view.assign("jsScript",jsScript);
		this.view.assign("jsLib",jsLib);
		this.view.assign("scope",this);
		this.view.assign("side",null);
		this.view.assign("content",null);
//	var news= vo.News.manager.all();
	
	var news= vo.News.manager.search({titre:"emma"});
		this.view.assign("news", news);
		
		this.view.display("front/frontest.html");
		
	
	}
	
		
	
	
		    
	
}