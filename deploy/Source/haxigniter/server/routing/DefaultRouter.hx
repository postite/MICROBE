package haxigniter.server.routing;

import haxigniter.server.Controller;
import haxigniter.server.Config;
import haxigniter.server.libraries.Url;

import haxigniter.server.libraries.Request;
import haxigniter.common.libraries.ParsedUrl;

class DefaultRouter implements Router
{
	public function new() {}
	
	/**
	 * A quite simple router, creates a controller with the same name as the first segment in the url.
	 */ 
	public function createController(config : Config, url : ParsedUrl) : Controller
	{
		var request : Request = new Request(config);
		var urlLib = new Url(config);
		
		var segments = urlLib.split(url.path);
		
		return request.createController(segments[0]);
	}	
}