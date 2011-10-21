package haxigniter.server.request;

import haxe.Serializer;
import haxigniter.server.exceptions.RestApiValidationException;
import haxigniter.server.libraries.DebugLevel;
import haxigniter.common.libraries.ParsedUrl;
import haxigniter.server.request.RequestHandler;
import haxigniter.server.Controller;

#if php
import php.Lib;
import php.Web;
import php.Utf8;
#elseif neko
import neko.Lib;
import neko.Web;
import neko.Utf8;
#end

import haxigniter.server.libraries.Debug;

import haxigniter.common.restapi.RestApiInterface;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.restapi.RestApiParser;
import haxigniter.server.restapi.RestApiRequest;
import haxigniter.server.restapi.RestApiSecurityHandler;
import haxigniter.server.restapi.RestApiFormatHandler;
import haxigniter.server.restapi.RestApiRequestHandler;

import haxigniter.server.exceptions.RestApiException;

class RestApiHandler implements RequestHandler, implements RestApiFormatHandler, implements RestApiInterface
{
	public static var commonMimeTypes = {
		haxigniter: 'application/vnd.haxe.serialized', 
		xml: 'application/xml',
		xhtml: 'application/xhtml+xml',
		html: 'text/html',
		json: 'application/json'
	};
	
	public var apiRequestHandler : RestApiRequestHandler;
	public var apiFormatHandler : RestApiFormatHandler;
	public var apiSecurityHandler : RestApiSecurityHandler;

	public var noOutput : Bool;
	public var logger : Debug;
	public var development : Bool;
	
	public function new(apiSecurityHandler : RestApiSecurityHandler, apiRequestHandler : RestApiRequestHandler, ?apiFormatHandler : RestApiFormatHandler)
	{
		this.apiRequestHandler = apiRequestHandler;
		this.apiSecurityHandler = apiSecurityHandler;

		// If no format handler specified, use itself, which handles haxigniter format (serialized).
		if(apiFormatHandler == null)
		{
			this.apiFormatHandler = this;
			this.restApiFormats = ['haxigniter'];
		}
		else
			this.apiFormatHandler = apiFormatHandler;

		if(apiSecurityHandler != null)
		{
			// Install a RestApiHandler without security for the security handler.
			this.apiSecurityHandler.install(new RestApiHandler(null, apiRequestHandler, apiFormatHandler));
		}
		
		this.viewTranslations = new Hash<Hash<String>>();
		this.noOutput = false;
		this.development = false;
	}
	
	///// RestApiInterface implementation ///////////////////////////
	
	public function create(url : String, data : Dynamic, callBack : RestApiResponse -> Void) : Void
	{
		restApiRequest(url, data, callBack, RestApiRequestType.create);
	}
	
	public function read(url : String, callBack : RestApiResponse -> Void) : Void
	{
		restApiRequest(url, null, callBack, RestApiRequestType.read);
	}
	
	public function update(url : String, data : Dynamic, callBack : RestApiResponse -> Void) : Void
	{
		restApiRequest(url, data, callBack, RestApiRequestType.update);
	}
	
	public function delete(url : String, callBack : RestApiResponse -> Void) : Void
	{
		restApiRequest(url, null, callBack, RestApiRequestType.delete);
	}
	
	private function restApiRequest(url : String, data : Dynamic, callBack : RestApiResponse -> Void, requestType : RestApiRequestType) : Void
	{
		var urlData = parseUrl(url);
		callBack(sendRequest(urlData.api, requestType, urlData.query, data, urlData.parameters));		
	}

	///// RestApiFormatHandler implementation ///////////////////////

	// Set in constructor to haxigniter, the only format supported by RestApiController.
	public var restApiFormats(default, null) : Array<RestApiFormat>;

	public function restApiInput(data : String, inputFormat : RestApiFormat) : PropertyObject
	{
		if(data == '') 
			return null;
		else 
			return haxe.Unserializer.run(data);
	}
	
	public function restApiOutput(response : RestApiResponse, outputFormat : RestApiFormat) : RestResponseOutput
	{
		return {
			contentType: commonMimeTypes.haxigniter,
			charSet: 'utf-8',
			output: Utf8.encode(haxe.Serializer.run(response))
		};
	}
	
	/////////////////////////////////////////////////////////////////

	private static var apiRequestPattern = ~/(?:\/[vV](\d+))?\/\?(\/[^&]+)&?(.*)/;
	private static var apiFormatPattern = ~/\.(\w+)$/;
	
	private function parseUrl(url : String) : { api: Int, query: String, parameters: Hash<String>, format: RestApiFormat }
	{
		if(!apiRequestPattern.match(url))
		{
			throw new RestApiException('Invalid request.', RestErrorType.invalidQuery);
		}
		else
		{
			var api = apiRequestPattern.matched(1);
			var query = apiRequestPattern.matched(2);
			var parameters = ParsedUrl.parseQuery(apiRequestPattern.matched(3));
			var format : RestApiFormat = null;

			// Parse format from query, if any.
			// The slash prepending the query is kept so this pattern can detect the format:
			if(apiFormatPattern.match(query))
			{
				format = apiFormatPattern.matched(1);
				query = query.substr(0, query.length - format.length - 1);
			}

			if(StringTools.endsWith(query, '/'))
				query = query.substr(0, query.length - 1);			
			
			return { api: (api != null ? Std.parseInt(api) : null), query: query.substr(1), parameters: parameters, format: format };
		}
	}
	
	/////////////////////////////////////////////////////////////////

	private function sendRequest(apiVersion : Int, type : RestApiRequestType, query : String, data : PropertyObject, queryParameters : Hash<String>) : RestApiResponse
	{
		// Urldecode the query so it can be parsed.
		query = StringTools.urlDecode(query);
		
		try
		{
			// Parse the query
			var selectors = RestApiParser.parse(query);
			
			// Create the RestApiRequest object and pass it along to the handler.
			var request = new RestApiRequest(
				type, 
				Lambda.array(Lambda.map(selectors, this.parsedSegmentToResource)), 
				apiVersion, 
				queryParameters, 
				data
				);
			
			return apiRequestHandler.handleApiRequest(request, this.apiSecurityHandler);
		}
		catch(e : RestApiValidationException)
		{
			return RestApiResponse.validationFailure(e.errorFields);
		}
		catch(e : RestApiException)
		{
			if(logger != null)
				logger.log(Std.string(e), DebugLevel.error);

			return RestApiResponse.failure(e.message, e.error);
		}
		catch(e : Dynamic)
		{
			if(logger != null)
				logger.log(Std.string(e), DebugLevel.error);
			
			var message : String = this.development ? Std.string(e) : 'An unknown error occured.';
				
			return RestApiResponse.failure(message, RestErrorType.unknown);
		}
	}
	
	/**
	 * Handle a page request. (RequestHandler implementation)
	 */
	public function handleRequest(controller : Controller, url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
		var uriPath = url.path;
		var rawQuery = url.query;
		
		// Fix the query formatting.
		if(!StringTools.endsWith(uriPath, '/'))
			uriPath += '/';

		if(StringTools.startsWith(rawQuery, '?'))
		{
			rawQuery = rawQuery.substr(1);
			
			if(!StringTools.startsWith(rawQuery, '/'))
				rawQuery = '/' + rawQuery;
		}
		else if(!StringTools.startsWith(rawQuery, '/'))
		{
			rawQuery = '/' + rawQuery;
		}
		
		var response : RestApiResponse;
		var urlParts = this.parseUrl(uriPath + '?' + rawQuery);
		
		// Test if format is supported by the output handler.
		if(urlParts.format != null && !Lambda.has(apiFormatHandler.restApiFormats, urlParts.format))
		{
			response = RestApiResponse.failure('Non-supported format: ' + urlParts.format, RestErrorType.invalidOutputFormat);
		}
		else
		{
			if(urlParts.format == null)
				urlParts.format = apiFormatHandler.restApiFormats[0];
		
			// Convert the raw request data using the RestApiFormatHandler.
			var requestData : PropertyObject = (requestData != null) ? apiFormatHandler.restApiInput(requestData, urlParts.format) : null;

			// Create the request type depending on method
			var type = switch(method)
			{
				case 'POST': RestApiRequestType.create;
				case 'DELETE': RestApiRequestType.delete;
				case 'GET': RestApiRequestType.read;
				case 'PUT': RestApiRequestType.update;
				default: null;
			}
			
			if(type == null)
				response = RestApiResponse.failure('Invalid request type: ' + method, RestErrorType.invalidRequestType);
			else
			{
				// Make the request.
				response = this.sendRequest(urlParts.api, type, urlParts.query, requestData, urlParts.parameters);
			}
		}
		
		var finalOutput : RestResponseOutput = apiFormatHandler.restApiOutput(response, urlParts.format);

		//this.trace(RestApiDebug.responseToString(response));
		//trace(finalOutput);
		
		if(!this.noOutput)
		{
			// Format the final output according to response and send it to the client.
			var header = [];
			
			if(finalOutput.contentType != null)
				header.push(finalOutput.contentType);
			if(finalOutput.charSet != null)
				header.push('charset=' + finalOutput.charSet);
			
			if(header.length > 0)
				Web.setHeader('Content-Type', header.join('; '));

			Lib.print(finalOutput.output);
		}
		
		return RequestResult.returnValue(finalOutput);
	}

	///// View translations /////////////////////////////////////////
	
	private var viewTranslations : Hash<Hash<String>>;

	private function translateView(resourceName : String, viewName : String) : String
	{
		if(!this.viewTranslations.exists(resourceName))
			throw new RestApiException('Resource "' + resourceName + '" not found for view "' + viewName + '"', RestErrorType.invalidQuery);
		
		var views = this.viewTranslations.get(resourceName);
		
		if(!views.exists(viewName))
			throw new RestApiException('View "' + viewName + '" not found in resource "' + resourceName + '"', RestErrorType.invalidQuery);
		
		return views.get(viewName);
	}
	
	public function addView(resourceName : String, viewName : String, viewTranslation : String) : Void
	{
		var views : Hash<String>;
		if(!this.viewTranslations.exists(resourceName))
		{
			views = new Hash<String>();
			this.viewTranslations.set(resourceName, views);
		}
		else
			views = this.viewTranslations.get(resourceName);
		
		views.set(viewName, viewTranslation);
	}

	/////////////////////////////////////////////////////////////////
	
	private function parsedSegmentToResource(segment : RestApiParsedSegment) : RestApiResource
	{
		switch(segment)
		{
			case one(name, id):
				// Create a selector where id=X
				return { name: name, selectors: [RestApiSelector.attribute('id', RestApiSelectorOperator.equals, Std.string(id))] };
			
			case all(name):
				// Create an resource with only name, no selectors.
				return { name: name, selectors: [] };
			
			case view(name, viewName):
				// Translate the view to a selector string and parse it.
				return this.parsedSegmentToResource(RestApiParser.parseSelector(name, this.translateView(name, viewName)));
				
			case some(name, selectors):
				// Selectors are parsed already, just pass them on.
				return {name: name, selectors: selectors};
		}
	}
}
