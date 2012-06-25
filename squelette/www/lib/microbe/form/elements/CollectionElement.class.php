<?php

class microbe_form_elements_CollectionElement extends microbe_form_FormElement {
	public function __construct($name, $label, $inside, $_pos, $_collItemId) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->name = $name;
		$this->label = $label;
		if($_collItemId !== null) {
			$this->collItemId = $_collItemId;
		}
		if($inside !== null) {
			$this->inside = $inside;
		}
		if($_pos !== null) {
			$this->pos = $_pos;
		}
	}}
	public $collItemId;
	public $pos;
	public $inside;
	public function render($_pos) {
		$n = $this->name;
		$str = "<div class='collection' name='" . $n . "' id='" . $n . $this->pos . "' pos='" . $this->pos . "' tri='id_" . $this->collItemId . "'>";
		$str .= "<span class='realpos'> realpos=" . $this->collItemId . "</span>";
		$str .= "<span class='pos'> pos=" . $this->pos . "</span>";
		$str .= "<button value='delete' type='BUTTON' id='delete" . $this->pos . "' class='deletecollection' >delete</button>";
		if(null == $this->inside) throw new HException('null iterable');
		$»it = $this->inside->iterator();
		while($»it->hasNext()) {
			$item = $»it->next();
			$item->form = $this->form;
			$str .= $item->value;
			$str .= "<div>";
			$str .= "<label for='" . $item->name . "'>" . $item->label . "</label>";
			$str .= $item->render($this->pos);
			$str .= "</div>";
		}
		$str .= "</div>";
		return $str;
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
	function __toString() { return 'microbe.form.elements.CollectionElement'; }
}
