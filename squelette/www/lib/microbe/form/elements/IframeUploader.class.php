<?php

class microbe_form_elements_IframeUploader extends microbe_form_FormElement {
	public function __construct($name, $label, $value, $required, $validators, $attributes) {
		if(!php_Boot::$skip_constructor) {
		if($attributes === null) {
			$attributes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
		$this->label = $label;
		$this->value = $value;
	}}
	public $id;
	public function render($iter) {
		$n = $this->name;
		$str = "";
		$str .= "<div id='" . $n . "' microbe=''>";
		$str .= "<img src='/microbe/css/assets/blankframe.png' id='preview' >";
		$str .= "<input type='file' name='" . $n . "fl' id='fileinput' enctype='multipart/form-data'/>";
		$str .= "<input type='hidden' id='retour' value=''>";
		$str .= "<input type='submit' value='Upload some data' id='uploadButton' />";
		$str .= "</div>";
		return $str;
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
	function __toString() { return 'microbe.form.elements.IframeUploader'; }
}
