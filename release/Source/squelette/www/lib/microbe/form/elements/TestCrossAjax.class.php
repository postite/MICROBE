<?php

class microbe_form_elements_TestCrossAjax extends microbe_form_FormElement {
	public function __construct($name, $label, $value = null, $required = null, $validators = null, $attributes = null) {
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
	public function render($iter = null) {
		$n = $this->name;
		return "<div id='" . $n . "' microbe=" . Type::getClassName(_hx_qtype("microbe.form.elements.TestCrossAjax")) . "><img src='' id='preview" . _hx_string_rec($iter, "") . "' > <input type='file' name='fl" . _hx_string_rec($iter, "") . "' id='fileinput' enctype='multipart/form-data'/><input type='hidden' id='retour" . _hx_string_rec($iter, "") . "' value=''><iframe id='upload_target" . _hx_string_rec($iter, "") . "' name='upload_target" . _hx_string_rec($iter, "") . "' src='' style='width:0;height:0;border:0px solid #fff;'></iframe><input type='submit' value='Upload some data' id='uploadButton' /></div>";
	}
	public $id;
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
	function __toString() { return 'microbe.form.elements.TestCrossAjax'; }
}
