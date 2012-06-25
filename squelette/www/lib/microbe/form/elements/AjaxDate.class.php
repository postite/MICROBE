<?php

class microbe_form_elements_AjaxDate extends microbe_form_FormElement {
	public function __construct($name, $label, $value, $required, $validators, $attributes) { if(!php_Boot::$skip_constructor) {
		if($attributes === null) {
			$attributes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
		$this->label = "date de publication";
	}}
	public function render($iter) {
		if($iter === null) {
			$iter = 0;
		}
		$str = "<input id='madate_" . $iter . "' type='date'  name='madate_" . $iter . "' value='' />";
		return $str;
	}
	function __toString() { return 'microbe.form.elements.AjaxDate'; }
}
