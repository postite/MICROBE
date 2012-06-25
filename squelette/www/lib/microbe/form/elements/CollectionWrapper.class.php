<?php

class microbe_form_elements_CollectionWrapper extends microbe_form_FormElement {
	public function __construct($_field) {
		if(!php_Boot::$skip_constructor) {
		haxe_Log::trace("new Collection Wrapper" . $_field, _hx_anonymous(array("fileName" => "CollectionWrapper.hx", "lineNumber" => 13, "className" => "microbe.form.elements.CollectionWrapper", "methodName" => "new")));
		$this->field = $_field;
		parent::__construct();
		$this->label = $_field;
		$this->wrapped = new HList();
		haxe_Log::trace("after new Collection Wrapper" . $_field, _hx_anonymous(array("fileName" => "CollectionWrapper.hx", "lineNumber" => 18, "className" => "microbe.form.elements.CollectionWrapper", "methodName" => "new")));
	}}
	public $wrapped;
	public $field;
	public function render($iter) {
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
	public function addElement($collecItem) {
		haxe_Log::trace("addElement" . $collecItem, _hx_anonymous(array("fileName" => "CollectionWrapper.hx", "lineNumber" => 35, "className" => "microbe.form.elements.CollectionWrapper", "methodName" => "addElement")));
		$collecItem->form = $this->form;
		$this->wrapped->add($collecItem);
	}
	public function removeElement($collecItem) {
		$this->wrapped->remove($collecItem);
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
	function __toString() { return 'microbe.form.elements.CollectionWrapper'; }
}
