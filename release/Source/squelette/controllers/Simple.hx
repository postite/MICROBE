package controllers;
import microbe.controllers.GenericController;
import haxigniter.server.request.BasicHandler;
class Simple extends GenericController
{

	public var test:String;
	public function new()
	{
		test="paf";
		// Call the superclass to set up database, configuration, etc
		super();
	log("new Simple");
		var url = new haxigniter.server.libraries.Url(this.configuration);
		this.requestHandler = new BasicHandler(this.configuration);
		// Some default view assignments for every page
		this.view.assign('application', 'haXigniter');
		
		// The siteUrl() method creates a link to the web directory haXigniter is currently
		// located, so links won't be broken if moved somewhere else.
		this.view.assign('link', url.siteUrl());
		
		this.view.assign('id', null);
		log("after new Simple");
	}
	
	public function index()
	{
		log("index");
		// Displays 'start/index.mtt' (className/method, extension is from the ViewEngine.)
		//this.view.displayDefault();
	}

	public function show(id : Int)
	{
		this.view.assign('id', id);
		this.view.display('simple.html');
	}
	
	public function create(posted : Hash<String>)
	{
		// this.trace() gives a nicer trace output.
		this.trace(posted);
		this.view.display('simple.html');
	}
}