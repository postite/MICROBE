package haxigniter.server.request;

/**
 * ...
 * @author postite
 */
import config.Session;
import haxigniter.server.request.RequestHandler;
import haxigniter.server.Controller;
import haxigniter.common.libraries.ParsedUrl;
//import microbe.controllers.IDController;




class AuthRequestDecorator extends  RequestHandlerDecorator
{

	private var session:Session;
	private var loginPage:Controller;
	
	public function new(requestHandler : RequestHandler,loginPage:Controller,session:Session, ?restrictClass : Class<Dynamic>, ?addToArguments = false)
	{
		super(requestHandler);
		this.session = session;
		this.loginPage = loginPage;
		//this.restrictClass = restrictClass;
		//this.addToArguments = addToArguments;
	}

	public override function handleRequest(controller :Controller , url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
		var result:RequestResult;
		if (session.user != null){
			trace("session="+session.user);
		result = requestHandler.handleRequest(controller, url, method, getPostData, requestData);
		return result;
		}else {
		trace("pas identifié");
		result = requestHandler.handleRequest(loginPage, url, method, getPostData, requestData);
		return result;
		//cast(controller).checkID();
		//result = RequestResult.returnValue("pas identifié");
		}
		return RequestResult.noOutput;
	}
	
}