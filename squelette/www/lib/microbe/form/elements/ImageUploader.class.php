<?php

class microbe_form_elements_ImageUploader extends microbe_form_elements_IframeUploader {
	public function __construct($name, $label, $value = null, $required = null, $validators = null, $attributes = null) { if(!php_Boot::$skip_constructor) {
		if($attributes === null) {
			$attributes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct($name,$label,$value,$required,$validators,$attributes);
	}}
	public function render($iter = null) {
		$n = $this->name;
		$str = "";
		$str .= "<div class='imageuploader' id=" . $n . ">";
		$str .= "<img src='/microbe/css/assets/blankframe.png' id='preview' >";
		$str .= "<a class='file_input_button'>choisir</a>";
		$str .= "<input type='file' class='hiddenfileinput' name='" . $this->name . "fl' id='fileinput' enctype='multipart/form-data'/>";
		$str .= "<input type='hidden' id='retour' value=''>";
		$str .= "<a id='uploadButton' ></a>";
		$str .= "<a id='cancel'>rien</a>";
		$str .= "</div>";
		return $str;
	}
	static $composantName = "ImageUploader";
	function __toString() { return 'microbe.form.elements.ImageUploader'; }
}
