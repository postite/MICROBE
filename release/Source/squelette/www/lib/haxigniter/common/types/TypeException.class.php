<?php

class haxigniter_common_types_TypeException extends haxigniter_common_exceptions_Exception {
	public function __construct($className, $value, $stack = null) {
		if(!php_Boot::$skip_constructor) {
		$this->my_className = $className;
		$this->my_value = $value;
		$output = "Invalid value for " . $className . ": ";
		$output .= haxigniter_common_types_TypeException_0($this, $className, $output, $stack, $value);
		parent::__construct($output,0,$stack);
	}}
	public function getValue() {
		return $this->my_value;
	}
	public $my_value;
	public $value;
	public function getClassName() {
		return $this->my_className;
	}
	public $my_className;
	public $className;
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
	static $__properties__ = array("get_className" => "getClassName","get_value" => "getValue","get_message" => "getMessage","get_code" => "getCode","get_stack" => "getStack");
	function __toString() { return 'haxigniter.common.types.TypeException'; }
}
function haxigniter_common_types_TypeException_0(&$»this, &$className, &$output, &$stack, &$value) {
	if($value !== null) {
		return "\"" . $value . "\"";
	} else {
		return "null";
	}
}
