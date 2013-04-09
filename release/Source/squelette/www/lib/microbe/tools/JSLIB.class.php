<?php

class microbe_tools_JSLIB {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->liste = new HList();
	}}
	public function remove($v) {
		return $this->liste->remove($v);
	}
	public function last() {
		return $this->liste->last();
	}
	public function first() {
		return $this->liste->first();
	}
	public function iterator() {
		return $this->liste->iterator();
	}
	public function addOnce($s) {
		if(Lambda::has($this->liste, $s, null) === true) {
			return;
		}
		$this->add($s);
	}
	public function add($s) {
		$this->liste->add($s);
	}
	public $liste;
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
	function __toString() { return 'microbe.tools.JSLIB'; }
}
