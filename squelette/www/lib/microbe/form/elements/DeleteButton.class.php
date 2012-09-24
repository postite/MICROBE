<?php

class microbe_form_elements_DeleteButton extends microbe_form_FormElement {
	public function __construct($name, $label) { if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->name = $name;
		$this->label = $label;
	}}
	public function render($iter = null) {
		return "<button type='BUTTON' class='deletebutton'  id='" . $this->name . "' ><span>" . $this->label . "</span></button>";
	}
	function __toString() { return 'microbe.form.elements.DeleteButton'; }
}
