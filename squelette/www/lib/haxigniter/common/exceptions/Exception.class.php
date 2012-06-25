<?php

class haxigniter_common_exceptions_Exception {
	public function __construct($message, $code, $stack) {
		if(!php_Boot::$skip_constructor) {
		if($code === null) {
			$code = 0;
		}
		$message = StringTools::htmlEscape($message);
		$this->my_message = $message;
		$this->my_code = $code;
		$this->my_stack = $stack;
	}}
	public $message;
	public $my_message;
	public function getMessage() {
		return $this->my_message;
	}
	public $code;
	public $my_code;
	public function getCode() {
		return $this->my_code;
	}
	public $stack;
	public $my_stack;
	public function getStack() {
		return $this->my_stack;
	}
	public function toString() {
		$msg = "[" . $this->getStack()->className . " -> ";
		$msg .= $this->getStack()->methodName . "() line ";
		$msg .= $this->getStack()->lineNumber . "] " . $this->getMessage();
		return $msg;
	}
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
	function __toString() { return $this->toString(); }
}
