<?php

class microbe_form_elements_Hidden extends microbe_form_FormElement {
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
		$this->required = $required;
		$this->attributes = $attributes;
		$this->password = false;
		$this->showLabelAsDefaultValue = false;
		$this->useSizeValues = false;
		$this->printRequired = false;
		$this->width = 180;
	}}
	public $password;
	public $width;
	public $showLabelAsDefaultValue;
	public $useSizeValues;
	public $printRequired;
	public $formatter;
	public function render($iter) {
		$n = $this->name;
		$str = "<input   type='hidden' name=\"" . $n . "\" id=\"" . $n . "\" value=\"\"  " . $this->attributes . " />";
		$str .= (($this->required && $this->form->isSubmitted() && $this->printRequired) ? " required" : null);
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
	function __toString() { return 'microbe.form.elements.Hidden'; }
}
