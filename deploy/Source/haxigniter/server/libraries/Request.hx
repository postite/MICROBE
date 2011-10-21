package haxigniter.server.libraries;

import haxigniter.server.request.BasicHandler;
import haxigniter.server.request.RequestHandler;
import Type;
import haxigniter.common.types.TypeFactory;
import haxigniter.common.libraries.ParsedUrl;

import haxigniter.server.Controller;
import haxigniter.server.Config;

import haxigniter.server.routing.Router;
import haxigniter.server.content.ContentHandler;

class Request
{
	private var config : Config;
	
	public function new(config : Config)
	{
		this.config = config;
	}
	
	/**
	 * Convenience method for creating a controller based on a class name and the configuration file.
	 * @param	controllerName   Controller class, taken from config.defaultController if empty or null. Package is taken from config.controllerPackage.
	 * @param	?controllerArgs  Arguments to the controller.
	 * @return  The Controller that was created. Throws NotFoundException if no class exists.
	 */
	public function createController(controllerName : String, ?controllerArgs : Array<Dynamic>) : Controller
	{
		var controllerClass : String = (controllerName == null || controllerName == '') ? config.defaultController : controllerName;
		controllerClass = config.controllerPackage + '.' + controllerClass.substr(0, 1).toUpperCase() + controllerClass.substr(1);
		
		// Instantiate a controller with the above class name.
		var classType : Class<Dynamic> = Type.resolveClass(controllerClass);
		if(classType == null)
			throw new haxigniter.server.exceptions.NotFoundException(controllerClass + ' not found. (Is it defined in Config.hx and has only the first character Capitalized?)');

		return cast(Type.createInstance(classType, controllerArgs == null ? [] : controllerArgs), Controller);
	}

	/**
	 * Makes an internal request; A controller is executed without http redirecting and content handling. 
	 * It's basically the same as instantiating a controller class and call a method on it, but in a much more dynamic fashion.
	 * @param	request  Internal request path, "/start/test/123" for example.
	 * @param	?method  Request method, "GET", "POST", etc.
	 * @param	?getPostData  Get/Post query variables to send with the request. Will be treated separately from the request query parameters.
	 * @param	?requestData  Dynamic data that will be supplied to the controller in some circumstances, depending on the RequestHandler.
	 * @return  The return value from the controller.
	 */
	public function internal(request : String, ?method : String = 'GET', ?getPostData : Hash<String>, ?requestData : Dynamic) : Dynamic
	{
		// Need to prepend url with a slash so ParsedUrl doesn't treat the first
		// segment as the host name.
		if(!StringTools.startsWith(request, '/'))
			request = '/' + request;
		
		var parsedUrl : ParsedUrl = testUrl(request);
		var controller = config.router.createController(config, parsedUrl);

		// Test if a request handler exists, if not set it to a BasicHandler.
		if(controller.requestHandler == null)
		{
			controller.requestHandler = new BasicHandler(config);
		}

		var result : RequestResult = controller.requestHandler.handleRequest(controller, parsedUrl, method, getPostData, requestData);
		return requestResultOutput(result);
	}
	
	/**
	 * Make a haXigniter request. This is the method called from Application.run().
	 * @param	url  Full or partial URL to the request.
	 * @param	?method  Request method, "GET", "POST", etc.
	 * @param	?getPostData  Get/Post query variables to send with the request. Will be treated separately from the request query parameters.
	 * @param	?requestContent  Content send most likely from a web request.
	 * @param	?outputFunction  If the instantiated controller has a ContentHandler, this method will be called if the controller returns something
	 *                           and will output and transform that content. If no ContentHandler, this method will do nothing even if specified.
	 * @return  The Controller that was instantiated in the request.
	 */
	public function execute(url : String, ?method : String = 'GET', ?getPostData : Hash<String>, ?requestContent : ContentData, ?outputFunction : ContentData -> Void) : Controller
	{
		var parsedUrl = testUrl(url);
		var controller = config.router.createController(config, parsedUrl);

		var requestData : Dynamic = null;
		if(requestContent != null && method != 'GET')
		{
			// If a content handler exists, transform the request data.
			if(controller.contentHandler != null)
				requestData = controller.contentHandler.input(requestContent);
			else
				requestData = requestContent.data;
		}
		
		// Test if a request handler exists, if not set it to a BasicHandler.
		if(controller.requestHandler == null)
		{
			controller.requestHandler = new BasicHandler(config);
		}
		
		var result : RequestResult = controller.requestHandler.handleRequest(controller, parsedUrl, method, getPostData, requestData);
		var output = requestResultOutput(result);
		
		// If a content handler exists, output the data based on the content handler modifications.
		if(output != null && outputFunction != null && controller.contentHandler != null)
		{
			var outContent = controller.contentHandler.output(output);

			if(outContent != null)
				outputFunction(outContent);
		}

		return controller;
	}

	private function requestResultOutput(result : RequestResult) : Dynamic
	{
		switch(result)
		{
			case returnValue(value):
				return value;
				
			case methodCall(object, method, arguments):
				return Reflect.callMethod(object, method, arguments);
				
			case noOutput:
				return null;
		}		
	}
	
	private inline function testUrl(url : String) : ParsedUrl
	{
		var parsedUrl = new ParsedUrl(url);

		// Test url for valid characters.
		new Url(config).testValidUri(parsedUrl.path);

		return parsedUrl;
	}
}
