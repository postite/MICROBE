package haxigniter.common.restapi;

import haxigniter.common.restapi.RestApiResponse;

interface RestApiInterface 
{
	function create(url : String, data : Dynamic, callBack : RestApiResponse -> Void) : Void;
	function read(url : String, callBack : RestApiResponse -> Void) : Void;
	function update(url : String, data : Dynamic, callBack : RestApiResponse -> Void) : Void;
	function delete(url : String, callBack : RestApiResponse -> Void) : Void;
}