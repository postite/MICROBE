package haxigniter.server.request;

import haxigniter.server.request.RequestHandler;

import haxigniter.server.Controller;
import haxigniter.server.Config;
import haxigniter.common.types.TypeFactory;
import haxigniter.server.libraries.Url;
import haxigniter.common.libraries.ParsedUrl;

class BasicHandler implements RequestHandler
{
	private var config : Config;
	
	public var getPostData(default, null) : Hash<String>;
	public var requestData(default, null) : Dynamic;
	
	public function new(config : Config)
	{
		this.config = config;

	}
	
	public function handleRequest(controller : Controller, url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
microbe.controllers.GenericController.appDebug.log("handlerequest");
		var uriSegments = new Url(config).split(url.path);
		
		var controllerType = Type.getClass(controller);
		var controllerMethod : String = (uriSegments[1] == null) ? config.defaultAction : uriSegments[1];
		microbe.controllers.GenericController.appDebug.log("handlerequestend1"+Std.string( controllerType));
		var callMethod : Dynamic = Reflect.field(controller, controllerMethod);
		//var callMethod : Dynamic = null;
		microbe.controllers.GenericController.appDebug.log("handlerequestend1.5"+Std.string(callMethod));
		if(callMethod == null)
			throw new haxigniter.server.exceptions.NotFoundException(Type.getClassName(controllerType) + ' method "' + controllerMethod + '" not found.');
microbe.controllers.GenericController.appDebug.log("handlerequestend2");
		// Typecast the arguments.
		var arguments : Array<Dynamic> = TypeFactory.typecastArguments(controllerType, controllerMethod, uriSegments.slice(2));
		microbe.controllers.GenericController.appDebug.log("handlerequestend3");
		this.getPostData = getPostData;
		this.requestData = requestData;
		microbe.controllers.GenericController.appDebug.log("handlerequestend");
		return RequestResult.methodCall(controller, callMethod, arguments);
	}
}
