<?php

class microbe_form_elements_Mock extends microbe_form_FormElement {
	public function __construct($name, $label, $value = null, $required = null, $validators = null, $attributes = null) { if(!php_Boot::$skip_constructor) {
		if($attributes === null) {
			$attributes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
		$this->label = $label;
	}}
	public function render($iter = null) {
		$str = "<input  name='" . $this->name . "' id='" . $this->name . "'/>";
		$str .= "<div id='" . $this->name . "test' style='width:30px;height:30px;background: #0af;margin-top:30px'>choisir</div>";
		return $str;
	}
	function __toString() { return 'microbe.form.elements.Mock'; }
}
