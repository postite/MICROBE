<?php

class microbe_form_elements_Button extends microbe_form_FormElement {
	public function __construct($name, $label, $value = null, $type = null, $link = null) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->name = $name;
		$this->label = $label;
		$this->value = $value;
		$this->link = $link;
		$this->type = (($type === null) ? microbe_form_elements_ButtonType::$SUBMIT : $type);
	}}
	public function populate() {
		parent::populate();
		$n = $this->form->name . "_" . $this->name;
	}
	public function getPreview() {
		return "<tr><td></td><td>" . $this->render(null) . "<td></tr>";
	}
	public function getLabel() {
		$n = $this->form->name . "_" . $this->name;
		return "<label for=\"" . $n . "\" ></label>";
	}
	public function toString() {
		return $this->render(null);
	}
	public function render($iter = null) {
		$_onClick = "";
		if($this->link !== null) {
			$_onClick = " onclick=" . $this->link;
		}
		return "<button type=\"" . Std::string($this->type) . "\" class=\"" . $this->getClasses() . "\" name=\"" . $this->form->name . "_" . $this->name . "\" id=\"" . $this->form->name . "_" . $this->name . "\" value=\"" . Std::string($this->value) . "\" " . $_onClick . " >" . $this->label . "</button>";
	}
	public function isValid() {
		return true;
	}
	public $link;
	public $type;
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->�dynamics[$m]) && is_callable($this->�dynamics[$m]))
			return call_user_func_array($this->�dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call �'.$m.'�');
	}
	function __toString() { return $this->toString(); }
}
