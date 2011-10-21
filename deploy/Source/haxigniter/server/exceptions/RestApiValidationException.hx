package haxigniter.server.exceptions;

import haxigniter.common.restapi.RestApiResponse;

class RestApiValidationException extends RestApiException
{
	public var errorFields(default, null) : List<String>;
	
	public function new(errorFields : List<String>, ?message = 'Data validation failed.', ?code : Int = 0, ?stack : haxe.PosInfos)
	{
		this.errorFields = errorFields;
		super(message, RestErrorType.invalidData, stack);
	}
}
