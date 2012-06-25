package controllers;
import php.Web;
import php.io.Path;

import haxigniter.server.request.FileUploadDecorator;
import config.Config;

import haxigniter.server.content.ContentHandler;
import haxigniter.server.request.RequestHandler;

import haxigniter.server.libraries.Debug;
import haxigniter.server.libraries.DebugLevel;

import haxigniter.server.request.RestHandler;
import haxigniter.server.views.ViewEngine;

class Upload implements haxigniter.server.Controller, implements haxe.rtti.Infos
{
	public var requestHandler : RequestHandler;
	public var contentHandler : ContentHandler;

	public var config(default, null) : Config;

	public var view(default, null) : ViewEngine;

	// Debugging
	public var debug : Debug;

	private static var appConfig = new Config();

	// A debug object, for tracing and logging.
	private static var appDebug = new Debug(appConfig);

	//private static var appView = new haxigniter.server.views.Templo(appConfig);

	public function new()
	{
		this.config = new config.Config();
		this.debug = appDebug;
		//this.view = appView;
		this.requestHandler = new FileUploadDecorator(new RestHandler(this.config));

		var url = new haxigniter.server.libraries.Url(this.config);
		this.view.assign('link', url.siteUrl());
	}

	public function index()
	{
		this.view.displayDefault();
	}

	public function show(id : Int)
	{
		this.view.assign('id', id);
		//this.view.display('upload/index.mtt');
	}

	public function create(posted:Hash<String>,?files:Hash<FileInfo>)
	{
	//	this.trace("Post data : "+posted);
		//this.trace("Files : "+files);
		var name:String="";
		for (i in files){
		//trace ("iname="+i)	;		        
	if (!(i.name=="")){
	//i.copyTo(Path.directory(name /*Web.getCwd())+"/www/runtime/cache/"*/);
	//php.Lib.print(i.copyTo("uploads/images/"));
	php.Lib.print(i.copyTo(config.imagesPath));
	}
					        }
	//php.Lib.print(name);
	//	this.view.display('upload/index.mtt');
//	php.Lib.print(posted);
	}
	
	
	private function trace(data : Dynamic, ?debugLevel : DebugLevel, ?pos : haxe.PosInfos) : Void
	{
		debug.trace(data, debugLevel, pos);
	}
	
	public static function main()
	{
		haxigniter.server.Application.run(appConfig);
	}
}