package haxigniter.server.request;

import haxigniter.server.request.RequestHandler;
import haxigniter.server.Controller;
import haxigniter.common.libraries.ParsedUrl;

class RequestHandlerDecorator implements RequestHandler
{
	private var requestHandler : RequestHandler;
	
	private function new(requestHandler : RequestHandler)
	{
		this.requestHandler = requestHandler;
	}
	
	public function handleRequest(controller : Controller, url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
		throw 'RequestHandlerDecorater.handleRequest() is an abstract method and must be overridden in a child class.';
		return null;
	}
}