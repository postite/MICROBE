package haxigniter.server.request;

import haxigniter.common.exceptions.Exception;
import haxigniter.server.request.RequestHandler;
import haxigniter.server.Controller;
import haxigniter.common.libraries.ParsedUrl;

class HaxeRequestDecorator extends RequestHandlerDecorator
{
	public var restrictClass : Class<Dynamic>;
	public var addToArguments : Bool;
	
	public function new(requestHandler : RequestHandler, ?restrictClass : Class<Dynamic>, ?addToArguments = false)
	{
		super(requestHandler);
		
		this.restrictClass = restrictClass;
		this.addToArguments = addToArguments;
	}	
	
	public override function handleRequest(controller : Controller, url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
		if(restrictClass != null && requestData != null && !Std.is(requestData, restrictClass))
			throw new Exception('Only objects of type ' + Type.getClassName(restrictClass) + ' are allowed. (Was: ' + Type.getClassName(Type.getClass(requestData)) + ')');
			
		var result = requestHandler.handleRequest(controller, url, method, getPostData, requestData);
		
		switch(result)
		{
			case noOutput:
				return result;

			case returnValue(value):
				return result;

			case methodCall(object, method, arguments):
				// Append the requestData to the arguments if it exists.
				if(requestData != null && addToArguments)
					arguments.push(requestData);
					
				return RequestResult.methodCall(object, method, arguments);
		}
	}
}