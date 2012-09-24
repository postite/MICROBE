<?php

class haxigniter_server_exceptions_NotFoundException extends haxigniter_common_exceptions_Exception {
	public function __construct($message, $code = null, $stack = null) { if(!php_Boot::$skip_constructor) {
		parent::__construct($message,$code,$stack);
	}}
	static $__properties__ = array("get_message" => "getMessage","get_code" => "getCode","get_stack" => "getStack");
	function __toString() { return 'haxigniter.server.exceptions.NotFoundException'; }
}
