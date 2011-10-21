package controllers;

/**
 * The Start controller
 * Start is the default controller name, so if your application is in the root folder of the
 * web server, http://yourhostname/ will go here.
 * 
 * This controller uses a RestHandler, which follows the RESTful approach used in Ruby on Rails.
 * A GET request like http://yourhostname/start/123 will map to the show() method.
 * 
 * Please look at haxigniter.server.request.RestHandler for a full reference of the mappings.
 * 
 * Important: When creating your own controllers, they must be referenced in the 
 * file config/Config.hx, so the compiler is aware of them. See that file for more information.
 * 
 */
class Start extends MyController
{
	public function new()
	{
		// Call the superclass to set up database, configuration, etc
		super();

		var url = new haxigniter.server.libraries.Url(this.configuration);
		
		// Some default view assignments for every page
		this.view.assign('application', 'haXigniter');
		
		// The siteUrl() method creates a link to the web directory haXigniter is currently
		// located, so links won't be broken if moved somewhere else.
		this.view.assign('link', url.siteUrl());
		
		this.view.assign('id', null);
	}
	
	public function index()
	{
		// Displays 'start/index.mtt' (className/method, extension is from the ViewEngine.)
		this.view.displayDefault();
	}

	public function show(id : Int)
	{
		this.view.assign('id', id);
		this.view.display('start/index.mtt');
	}
	
	public function create(posted : Hash<String>)
	{
		// this.trace() gives a nicer trace output.
		this.trace(posted);
		this.view.display('start/index.mtt');
	}
}
