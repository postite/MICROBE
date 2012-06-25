<?php

class haxigniter_server_libraries_DatabaseException extends haxigniter_common_exceptions_Exception {
	public function __construct($message, $connection, $stack) {
		if(!php_Boot::$skip_constructor) {
		$this->connection = $connection;
		parent::__construct($message,0,$stack);
	}}
	public $connection;
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->»dynamics[$m]) && is_callable($this->»dynamics[$m]))
			return call_user_func_array($this->»dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call «'.$m.'»');
	}
	static $__properties__ = array("get_stack" => "getStack","get_code" => "getCode","get_message" => "getMessage");
	function __toString() { return 'haxigniter.server.libraries.DatabaseException'; }
}
