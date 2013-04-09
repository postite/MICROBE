<?php

class microbe_form_BrickField {
	public function __construct() {
		;
	}
	public function toString() {
		$str = "voName:" . $this->voName;
		$str .= "<br/>";
		$str .= "field:" . $this->field;
		$str .= "<br/>";
		return $str;
	}
	public $valeur;
	public $relation;
	public $voRel;
	public $id;
	public $element;
	public $enfants;
	public $field;
	public $voName;
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
