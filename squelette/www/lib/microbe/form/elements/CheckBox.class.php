<?php

class microbe_form_elements_CheckBox extends microbe_form_FormElement {
	public function __construct($name, $label, $value, $required, $validators, $attributes) { if(!php_Boot::$skip_constructor) {
		if($attributes === null) {
			$attributes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
		$this->label = Lambda::hlist(_hx_explode("_", $name))->last();
	}}
	public function render($iter) {
		if($iter === null) {
			$iter = 0;
		}
		$n = $this->name;
		$str = "";
		$str .= "<input id=\"" . $n . "\" name=\"pipo\" class=\"checkBox\" value=\"" . $this->name . "\" type=\"checkbox\" checked=\"checked\" /> ";
		return $str;
	}
	function __toString() { return 'microbe.form.elements.CheckBox'; }
}
