<?php

class microbe_form_elements_AjaxUploader extends microbe_form_FormElement {
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
		$str .= "<div id='" . $n . "' microbe=" . microbe_form_elements_AjaxUploader::$composantName . ">";
		$str .= "<img src='/microbe/css/assets/blankframe.png' id='" . microbe_form_elements_AjaxUploader::$composantName . "preview" . $iter . "' >";
		$str .= "<input type='file' name='" . microbe_form_elements_AjaxUploader::$composantName . "fl" . $iter . "' id='" . microbe_form_elements_AjaxUploader::$composantName . "fileinput' enctype='multipart/form-data'/>";
		$str .= "<input type='hidden' id='" . microbe_form_elements_AjaxUploader::$composantName . "retour" . $iter . "' value=''>";
		$str .= "<iframe id='" . microbe_form_elements_AjaxUploader::$composantName . "upload_target" . $iter . "' name='popo' src='' style='width:0;height:0;border:0px solid #fff;'></iframe>";
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
	static $composantName = "AjaxUploader";
	function __toString() { return 'microbe.form.elements.AjaxUploader'; }
}
