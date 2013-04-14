<?php

class microbe_ERROR {
	public function __construct($type, $message = null, $forfield = null) {
		if(!php_Boot::$skip_constructor) {
		$this->message = $message;
		$this->type = $type;
		$this->forfield = $forfield;
	}}
	public $forfield;
	public $type;
	public $message;
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
	function __toString() { return 'microbe.ERROR'; }
}
