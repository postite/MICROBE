<?php

class microbe_form_elements_AjaxArea extends microbe_form_FormElement {
	public function __construct($name, $label, $value, $required, $validators, $attributes) {
		if(!php_Boot::$skip_constructor) {
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->label = $label;
		$this->name = $name;
		$this->value = $value;
		$this->required = $required;
		$this->attributes = $attributes;
	}}
	public $height;
	public function render($iter) {
		$n = $this->name;
		$s = "";
		$s .= "<textarea  name=\"" . $n . "\" id=\"" . $n . "\" " . $this->attributes . " >" . $this->value . "</textarea>";
		return $s;
	}
	public function toString() {
		return $this->render(null);
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
	function __toString() { return $this->toString(); }
}
