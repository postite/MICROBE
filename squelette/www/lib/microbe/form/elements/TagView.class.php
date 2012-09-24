<?php

class microbe_form_elements_TagView extends microbe_form_FormElement {
	public function __construct($name, $label = null, $tags = null, $tagsbyId = null) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->spodTags = new HList();
		$this->contextTags = new HList();
		$this->name = $name;
	}}
	public function render($iter = null) {
		$str = "<div id='tagSelector'>";
		$str .= "<div id='instantag'>";
		$str .= "<input type=text id='pute'></input>";
		$str .= "<SELECT SIZE='10' id='results'>";
		$str .= "</SELECT >";
		$str .= "<a id='addTag'>+ TAG</a>";
		$str .= "</div>";
		$str .= "</div>";
		return $str;
	}
	public $contextTags;
	public $spodTags;
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
	function __toString() { return 'microbe.form.elements.TagView'; }
}
