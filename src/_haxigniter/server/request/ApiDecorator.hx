package haxigniter.server.request;
import haxigniter.common.types.TypeFactory;
import config.Config;
import haxigniter.server.libraries.Url;

import haxigniter.common.exceptions.Exception;
import haxigniter.server.request.RequestHandler;
import haxigniter.server.Controller;
import haxigniter.common.libraries.ParsedUrl;
//import microbe.Apiprox;
import microbe.Api;
class ApiDecorator extends RequestHandlerDecorator
{

	
	public var api: Api;
	public var config: Config;
	public var getPostData(default, null) : Hash<String>;
	public var requestData(default, null) : Dynamic;
	public function new(requestHandler : RequestHandler,_config:Config, ?restrictClass : Class<Dynamic>, ?addToArguments = false)
	{
		config=_config;
		super(requestHandler);
		api=new Api();
		//this.restrictClass = restrictClass;
		//this.addToArguments = addToArguments;
	}

	public override function handleRequest(controller:Controller , url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
	//	php.Lib.print("okok"+url.path);
		var uriSegments = new Url(config).split(url.path);

			var controllerType = Type.getClass(controller);
			var controllerMethod : String = (uriSegments[1] == null) ? config.defaultAction : uriSegments[1];

			var callMethod : Dynamic = Reflect.field(api, controllerMethod);
			if(callMethod == null)
				throw new haxigniter.server.exceptions.NotFoundException(Type.getClassName(Api) + ' method "' + controllerMethod + '" not found.');

			// Typecast the arguments.
			var arguments : Array<Dynamic> = TypeFactory.typecastArguments(Api, controllerMethod, uriSegments.slice(2));
			
			this.getPostData = getPostData;
			this.requestData = requestData;
			var result:Dynamic= Reflect.callMethod(api, callMethod, arguments);
		//	Reflect.callMethod(controller,"index",[result]);
			return RequestResult.noOutput;
		//	return RequestResult.methodCall(controller, "index", "result");
	}
}