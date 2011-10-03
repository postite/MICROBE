package haxigniter.server.request;

import haxigniter.server.Controller;
import haxigniter.common.libraries.ParsedUrl;

enum RequestResult
{
	noOutput;
	returnValue(value : Dynamic);
	methodCall(object : Dynamic, method : Dynamic, arguments : Array<Dynamic>);
}

interface RequestHandler
{
	/**
	 * Handle a page request.
	 * @param   controller The object that is delegated to handle the request.
	 * @param	url A parsed url of the request.
	 * @param	method Request method, "GET" or "POST" most likely.
	 * @param	getPostData A combination of GET and POST vars.
	 * @param	requestData Data sent with the request. Null for GET requests, otherwise a Dynamic value sent
	 *          from a ContentHandler. If no content handler changed it, it is the raw post data as a String.
	 * @return  Output from the controller, that will be modified with the controllers FormatHandler if set.
	 */
	public function handleRequest(controller : Controller, url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult;
}
