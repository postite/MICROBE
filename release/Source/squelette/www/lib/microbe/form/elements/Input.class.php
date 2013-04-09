<?php

class microbe_form_elements_Input extends microbe_form_FormElement {
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
		$this->required = $required;
		$this->attributes = $attributes;
		$this->password = false;
		$this->showLabelAsDefaultValue = false;
		$this->useSizeValues = false;
		$this->printRequired = false;
		$this->width = 180;
	}}
	public function toString() {
		return $this->render(null);
	}
	public function render($iter = null) {
		$n = $this->form->name . "_" . $this->name;
		$tType = (($this->password) ? "password" : "text");
		if($this->showLabelAsDefaultValue && _hx_equal($this->value, $this->label)) {
			$this->addValidator(new microbe_form_validators_BoolValidator(false, "Not valid"));
		}
		if((_hx_field($this, "value") === null || _hx_equal($this->value, "")) && $this->showLabelAsDefaultValue) {
			$this->value = $this->label;
		}
		$style = microbe_form_elements_Input_0($this, $iter, $n, $tType);
		return "<input " . $style . " class=\"" . $this->getClasses() . "\" type=\"" . $tType . "\" name=\"" . $n . "\" id=\"" . $n . "\" value=\"" . microbe_form_elements_Input_1($this, $iter, $n, $style, $tType) . "\"  " . $this->attributes . " />" . ((($this->required && $this->form->isSubmitted() && $this->printRequired) ? " required" : null));
	}
	public $formatter;
	public $printRequired;
	public $useSizeValues;
	public $showLabelAsDefaultValue;
	public $width;
	public $password;
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
	function __toString() { return $this->toString(); }
}
function microbe_form_elements_Input_0(&$»this, &$iter, &$n, &$tType) {
	if($»this->useSizeValues) {
		return "style=\"width:" . _hx_string_rec($»this->width, "") . "px\"";
	} else {
		return "";
	}
}
function microbe_form_elements_Input_1(&$»this, &$iter, &$n, &$style, &$tType) {
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
