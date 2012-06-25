<?php

class microbe_form_FieldSet {
	public function __construct($name, $label, $visible) {
		if(!php_Boot::$skip_constructor) {
		if($visible === null) {
			$visible = true;
		}
		if($label === null) {
			$label = "";
		}
		if($name === null) {
			$name = "";
		}
		$this->name = $name;
		$this->label = $label;
		$this->visible = $visible;
		$this->elements = new HList();
	}}
	public $name;
	public $form;
	public $label;
	public $visible;
	public $elements;
	public function getOpenTag() {
		return "<fieldset id=\"" . $this->form->name . "_" . $this->name . "\" name=\"" . $this->form->name . "_" . $this->name . "\" class=\"" . ((($this->visible) ? "" : "fieldsetNoDisplay")) . "\" ><legend>" . $this->label . "</legend>";
	}
	public function getCloseTag() {
		return "</fieldset>";
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
	function __toString() { return 'microbe.form.FieldSet'; }
}
