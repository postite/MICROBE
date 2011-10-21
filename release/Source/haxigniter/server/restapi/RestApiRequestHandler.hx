package haxigniter.server.restapi;

import haxigniter.common.restapi.RestApiResponse;

interface RestApiRequestHandler
{
	/**
	 * Handle an incoming request.
	 * @param	request
	 * @return
	 */
	function handleApiRequest(request : RestApiRequest, security : RestApiSecurityHandler) : RestApiResponse;
}
