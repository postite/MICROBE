<?php

class microbe_form_Validator {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->errors = new HList();
	}}
	public function reset() {
		$this->errors->clear();
	}
	public function isValid($value) {
		$this->errors->clear();
		return true;
	}
	public $errors;
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->�dynamics[$m]) && is_callable($this->�dynamics[$m]))
			return call_user_func_array($this->�dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call �'.$m.'�');
	}
	function __toString() { return 'microbe.form.Validator'; }
}
