<?php

class microbe_backof_Navigation {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->items = new HList();
		$this->items->add(_hx_anonymous(array("label" => "edito", "data" => 1, "vo" => "New")));
	}}
	public $items;
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
	function __toString() { return 'microbe.backof.Navigation'; }
}
