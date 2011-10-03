package haxigniter.common.restapi;

enum RestErrorType 
{
	invalidRequestType;
    invalidResource;
    invalidQuery;
	invalidApiVersion;
	invalidOutputFormat;
	invalidData;
	invalidResponse;
	
	configurationError;	
	unauthorizedRequest;
	unknown;
}

class RestDataCollection
{
	public var startIndex(default, null) : Int;
	public var endIndex(default, null) : Int;
	public var totalCount(default, null) : Int;
	public var data : Array<Dynamic>;
	
	public function new(startIndex : Int, endIndex : Int, totalCount : Int, data : Array<Dynamic>)
	{
		if(startIndex == null || startIndex < 0)
			throw '[RestDataCollection] Invalid startIndex: ' + startIndex;

		if(endIndex == null || endIndex < 0)
			throw '[RestDataCollection] Invalid endIndex: ' + endIndex;

		if(totalCount == null || totalCount < 0)
			throw '[RestDataCollection] Invalid totalCount: ' + totalCount;

		if(data == null)
			throw '[RestDataCollection] Data is null.';

		this.startIndex = startIndex;
		this.endIndex = endIndex;
		this.totalCount = totalCount;
		this.data = data;
	}
	
	public function iterator() { return data.iterator(); }
}

class RestApiDebug
{
	public static function responseToString(response : RestApiResponse) : String
	{
		switch(response)
		{
			case success(rows):
				return 'RestApiResponse.success(Affected: ' + rows + ')';
			
			case successData(collection):
				return 'RestApiResponse.successData(' + StringTools.replace(collection.data.join(', '), '}, ', '},\n') + ' [From ' + collection.startIndex + ' to ' + collection.endIndex + ', total ' + collection.totalCount + '])';
			
			case failure(message, errorType):
				return 'RestApiResponse.failure("' + message + '", RestErrorType.' + errorType + ')';
			
			case validationFailure(fields):
				return 'RestApiResponse.validationFailure([' + fields.join(', ') + '])';
		}
	}	
}

/////////////////////////////////////////////////////////////////////

enum RestApiResponse 
{
	success(affectedIds : Array<Int>);
	successData(collection : RestDataCollection);
	failure(message : String, errorType : RestErrorType);
	validationFailure(fields : List<String>);
}
