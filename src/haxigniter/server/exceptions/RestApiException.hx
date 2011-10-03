package haxigniter.server.exceptions;

import haxigniter.common.restapi.RestApiResponse;

class RestApiException extends haxigniter.common.exceptions.Exception
{
	public var error(default, null) : RestErrorType;
	
	public function new(message : String, error : RestErrorType, ?code : Int = 0, ?stack : haxe.PosInfos)
	{
		this.error = error;		
		super(message, code, stack);
	}
}
