<?php

class microbe_form_elements_AjaxInput extends microbe_form_FormElement {
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
		$tType = (($this->password) ? "password" : "text");
		if($this->showLabelAsDefaultValue && _hx_equal($this->value, $this->label)) {
			$this->addValidator(new microbe_form_validators_BoolValidator(false, "Not valid"));
		}
		if((_hx_field($this, "value") === null || _hx_equal($this->value, "")) && $this->showLabelAsDefaultValue) {
			$this->value = $this->label;
		}
		$style = microbe_form_elements_AjaxInput_0($this, $iter, $n, $tType);
		$str = "<input " . $style . "\" type=\"" . $tType . "\" name=\"" . $n . "\" id=\"" . $n . "\" value=\"" . microbe_form_elements_AjaxInput_1($this, $iter, $n, $style, $tType) . "\"  " . $this->attributes . " />";
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
	function __toString() { return 'microbe.form.elements.AjaxInput'; }
}
function microbe_form_elements_AjaxInput_0(&$»this, &$iter, &$n, &$tType) {
	if($»this->useSizeValues) {
		return "style=\"width:" . $»this->width . "px\"";
	} else {
		return "";
	}
}
function microbe_form_elements_AjaxInput_1(&$»this, &$iter, &$n, &$style, &$tType) {
	{
		$s = $»this->value;
		if($s === null) {
			return "";
		} else {
			return _hx_explode("\"", StringTools::htmlEscape(Std::string($s)))->join("&quot;");
		}
		unset($s);
	}
}
