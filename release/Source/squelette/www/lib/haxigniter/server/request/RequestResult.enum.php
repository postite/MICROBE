<?php

class haxigniter_server_request_RequestResult extends Enum {
	public static function methodCall($object, $method, $arguments) { return new haxigniter_server_request_RequestResult("methodCall", 2, array($object, $method, $arguments)); }
	public static $noOutput;
	public static function returnValue($value) { return new haxigniter_server_request_RequestResult("returnValue", 1, array($value)); }
	public static $__constructors = array(2 => 'methodCall', 0 => 'noOutput', 1 => 'returnValue');
	}
haxigniter_server_request_RequestResult::$noOutput = new haxigniter_server_request_RequestResult("noOutput", 0);
