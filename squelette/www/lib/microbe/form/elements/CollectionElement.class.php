<?php

class microbe_form_elements_CollectionElement extends microbe_form_FormElement {
	public function __construct($name, $label, $inside = null, $_pos = null, $_collItemId = null) {
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
	public function render($_pos = null) {
		$n = $this->name;
		$str = "<div class='collection' name='" . $n . "' id='" . $n . _hx_string_rec($this->pos, "") . "' pos='" . _hx_string_rec($this->pos, "") . "' tri='id_" . _hx_string_rec($this->collItemId, "") . "'>";
		$str .= "<button value='delete' type='BUTTON' id='delete" . _hx_string_rec($this->pos, "") . "' class='deletecollection' >delete</button>";
		if(null == $this->inside) throw new HException('null iterable');
		$»it = $this->inside->iterator();
		while($»it->hasNext()) {
			$item = $»it->next();
			$item->form = $this->form;
			$str .= "<div>";
			$str .= "<label for='" . $item->name . "'>" . $item->label . "</label>";
			$str .= $item->render($this->pos);
			$str .= "</div>";
		}
		$str .= "</div>";
		return $str;
	}
	public $inside;
	public $pos;
	public $collItemId;
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
