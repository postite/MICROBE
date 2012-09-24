<?php

class microbe_form_elements_CollectionWrapper extends microbe_form_FormElement {
	public function __construct($_field) {
		if(!php_Boot::$skip_constructor) {
		$this->field = $_field;
		parent::__construct();
		$this->label = $_field;
		$this->wrapped = new HList();
		null;
	}}
	public function removeElement($collecItem) {
		$this->wrapped->remove($collecItem);
	}
	public function addElement($collecItem) {
		$collecItem->form = $this->form;
		$this->wrapped->add($collecItem);
	}
	public function render($iter = null) {
		$str = "<div class='collectionWrapper' spod='" . $this->field . "'>";
		if(null == $this->wrapped) throw new HException('null iterable');
		$»it = $this->wrapped->iterator();
		while($»it->hasNext()) {
			$item = $»it->next();
			$str .= $item->render(null);
		}
		$str .= "</div>";
		return $str;
	}
	public $field;
	public $wrapped;
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
	function __toString() { return 'microbe.form.elements.CollectionWrapper'; }
}
