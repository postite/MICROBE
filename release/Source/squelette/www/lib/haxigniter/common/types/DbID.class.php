<?php

class haxigniter_common_types_DbID {
	public function __construct($input) {
		if(!php_Boot::$skip_constructor) {
		$intValue = Std::parseInt($input);
		if($intValue === null || $intValue <= 0) {
			throw new HException(new haxigniter_common_types_TypeException(Type::getClassName(Type::getClass($this)), $input, _hx_anonymous(array("fileName" => "TypeFactory.hx", "lineNumber" => 19, "className" => "haxigniter.common.types.DbID", "methodName" => "new"))));
		}
		$this->intValue = $intValue;
	}}
	public $intValue;
	public function toInt() {
		return $this->intValue;
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
	function __toString() { return 'haxigniter.common.types.DbID'; }
}
