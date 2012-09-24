<?php

class microbe_form_elements_AjaxDate extends microbe_form_FormElement {
	public function __construct($name, $label = null, $value = null, $required = null, $validators = null, $attributes = null) { if(!php_Boot::$skip_constructor) {
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
	public function render($iter = null) {
		if($iter === null) {
			$iter = 0;
		}
		$str = "<input id='madate_" . _hx_string_rec($iter, "") . "' type='date' name='madate_" . _hx_string_rec($iter, "") . "' value='2012-12-11' />";
		return $str;
	}
	function __toString() { return 'microbe.form.elements.AjaxDate'; }
}
