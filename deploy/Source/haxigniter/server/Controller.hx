package haxigniter.server;

import haxigniter.server.request.RequestHandler;
import haxigniter.server.content.ContentHandler;

interface Controller
{
	/**
	 * Contains the request handler that specifies how the controller will be used in the Application.
	 */
	var requestHandler : RequestHandler;
	
	/**
	 * A format handler that specifies how the input and output to the controller will be treated.
	 * Set to null for no special treatment of the input and output from the controller.
	 */
	var contentHandler : ContentHandler;
}
