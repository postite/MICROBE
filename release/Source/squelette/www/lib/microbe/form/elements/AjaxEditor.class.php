<?php

class microbe_form_elements_AjaxEditor extends microbe_form_FormElement {
	public function __construct($name, $label, $value = null, $required = null, $attibutes = null) {
		if(!php_Boot::$skip_constructor) {
		if($attibutes === null) {
			$attibutes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
		$this->label = $label;
		$this->value = $value;
		$this->required = $required;
		$this->attributes = $attibutes;
		$this->width = 500;
		$this->height = 300;
		$this->allowImages = true;
		$this->allowTables = false;
		$this->editorStyles = "";
		$this->containersItems = "";
		$this->classesItems = "";
	}}
	public function toString() {
		return $this->render(null);
	}
	public function render($iter = null) {
		$n = $this->name;
		$str = new StringBuf();
		$str->add("\x0A <textarea name=\"" . $n . "\" trans='pop' id=\"" . $n . "\" class=\"editor\">" . Std::string($this->value) . "</textarea>");
		return $str->b;
	}
	public $classesItems;
	public $containersItems;
	public $editorStyles;
	public $allowTables;
	public $allowImages;
	public $height;
	public $width;
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
