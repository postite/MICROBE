<?php

class haxigniter_common_exceptions_Exception {
	public function __construct($message, $code = null, $stack = null) {
		if(!php_Boot::$skip_constructor) {
		if($code === null) {
			$code = 0;
		}
		$message = StringTools::htmlEscape($message);
		$this->my_message = $message;
		$this->my_code = $code;
		$this->my_stack = $stack;
	}}
	public function toString() {
		$msg = "[" . $this->getStack()->className . " -> ";
		$msg .= $this->getStack()->methodName . "() line ";
		$msg .= _hx_string_rec($this->getStack()->lineNumber, "") . "] " . $this->getMessage();
		return $msg;
	}
	public function getStack() {
		return $this->my_stack;
	}
	public $my_stack;
	public $stack;
	public function getCode() {
		return $this->my_code;
	}
	public $my_code;
	public $code;
	public function getMessage() {
		return $this->my_message;
	}
	public $my_message;
	public $message;
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
	static $__properties__ = array("get_message" => "getMessage","get_code" => "getCode","get_stack" => "getStack");
	function __toString() { return $this->toString(); }
}
