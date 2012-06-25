<?php

class microbe_form_elements_TailleSelector extends microbe_form_FormElement {
	public function __construct($name, $label, $value, $required, $validators, $attributes) { if(!php_Boot::$skip_constructor) {
		if($attributes === null) {
			$attributes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
	}}
	public function render($iter) {
		$n = $this->name;
		$str = "<div id=" . $n . " class='tailleSelector'>";
		$incr = 0;
		$boule = false;
		$checked = "";
		{
			$_g = 0; $_g1 = microbe_form_elements_TailleSelector::$tailles;
			while($_g < $_g1->length) {
				$a = $_g1[$_g];
				++$_g;
				$str .= "<label for=\"pipo" . $incr . "_" . $iter . "\">" . $a . "</label>";
				$str .= "<input id=\"pipo" . $incr . "_" . $iter . "\" name=\"pipo\" class=\"taillebox" . $iter . "\" value=\"" . $a . "\" " . $checked . " type=\"checkbox\"  /> ";
				$incr++;
				$boule = !$boule;
				unset($a);
			}
		}
		$str .= "</div>";
		return $str;
	}
	static $tailles;
	function __toString() { return 'microbe.form.elements.TailleSelector'; }
}
microbe_form_elements_TailleSelector::$tailles = new _hx_array(array(34, 35, 36, 38, 40, 42, 44, 46));
