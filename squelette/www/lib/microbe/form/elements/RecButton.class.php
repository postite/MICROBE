<?php

class microbe_form_elements_RecButton extends microbe_form_elements_Button {
	public function __construct($name, $label, $value = null, $type = null, $link = null) { if(!php_Boot::$skip_constructor) {
		parent::__construct($name,$label,$value,$type,$link);
		$this->name = $name;
		$this->label = $label;
	}}
	public function render($iter = null) {
		$_onClick = "";
		if($this->link !== null) {
			$_onClick = " onclick=" . $this->link;
		}
		return "<button type=\"" . Std::string($this->type) . "\" class=\"" . $this->getClasses() . "\" name=\"" . $this->form->name . "_" . $this->name . "\" id=\"" . $this->form->name . "_" . $this->name . "\" value=\"" . Std::string($this->value) . "\" " . $_onClick . " >" . $this->label . "</button>";
	}
	function __toString() { return 'microbe.form.elements.RecButton'; }
}
