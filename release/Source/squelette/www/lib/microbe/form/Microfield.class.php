<?php

class microbe_form_Microfield implements microbe_form_IMicrotype{
	public function __construct() {
		;
	}
	public function toString() {
		return "<div class='microfieldTrace'><p>MICROFIELD :<br/>type:" . Std::string($this->type) . "<br/>field:" . $this->field . ",<br/>voName:" . $this->voName . ",<br/>element:" . $this->element . ", <br/>elementId:" . $this->elementId . "<br/>value:" . $this->value . "</p></div>";
		return "";
	}
	public $type;
	public $value;
	public $elementId;
	public $element;
	public $field;
	public $voName;
	public $voId;
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
