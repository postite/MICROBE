package haxigniter.tests.mocks;

import haxigniter.server.request.RequestHandler;

import haxigniter.server.Controller;
import haxigniter.server.Config;
import haxigniter.common.types.TypeFactory;
import haxigniter.server.libraries.Url;
import haxigniter.common.libraries.ParsedUrl;

class MockRequestHandler implements RequestHandler
{
	public var requestResult : RequestResult;
	
	public function new(?requestResult : RequestResult)
	{
		this.requestResult = requestResult;
	}
	
	public function handleRequest(controller : Controller, url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
		return requestResult;
	}
}
