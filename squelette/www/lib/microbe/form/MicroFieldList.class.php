<?php

class microbe_form_MicroFieldList implements microbe_form_IMicrotype{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->fields = new HList();
	}}
	public $field;
	public $voName;
	public $value;
	public $id;
	public $elementId;
	public $type;
	public $fields;
	public $indent;
	public $length;
	public $pos;
	public $taggable;
	public function getLength() {
		return $this->fields->length;
	}
	public function add($item) {
		$this->fields->add($item);
		return $item;
	}
	public function iterator() {
		return $this->fields->iterator();
	}
	public function first() {
		return $this->fields->first();
	}
	public function last() {
		return $this->fields->last();
	}
	public function next() {
		return $this->fields->iterator()->next();
	}
	public function remove($v) {
		return $this->fields->remove($v);
	}
	public function filter($f) {
		return $this->fields->filter($f);
	}
	public function map($f) {
		return $this->fields->map($f);
	}
	public function toString() {
		$this->indent++;
		return "<div class='indent" . $this->indent . "'><div class='microtrace'><p>MICROFIELDLIST: " . $this->voName . "</p><p>-" . ", TYPE:" . $this->type . " TAGGABLE=" . $this->taggable . "  POS:" . $this->pos . ", FIELD:" . $this->field . "  ID:" . $this->id . "ElementId:" . $this->elementId . ", VALUE:" . $this->value . "</p><p>" . $this->fields->toString() . "</p></div></div>";
		return "";
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
	static $__properties__ = array("get_length" => "getLength");
	function __toString() { return $this->toString(); }
}
