<?php

class microbe_form_elements_FakeElement extends microbe_form_FormElement {
	public function __construct($name, $value = null, $required = null, $display = null, $attributes = null) {
		if(!php_Boot::$skip_constructor) {
		if($attributes === null) {
			$attributes = "";
		}
		if($display === null) {
			$display = false;
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
		$this->value = $value;
		$this->required = $required;
		$this->display = $display;
		$this->attributes = $attributes;
	}}
	public function toString() {
		return $this->render(null);
	}
	public function getPreview() {
		return $this->render(null);
	}
	public function render($iter = null) {
		$n = $this->name;
		return $n;
	}
	public $display;
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
	function __toString() { return $this->toString(); }
}
