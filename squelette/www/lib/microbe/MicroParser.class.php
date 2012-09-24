<?php

class microbe_MicroParser {
	public function __construct($_source) {
		if(!php_Boot::$skip_constructor) {
		$this->source = $_source;
	}}
	public function parse() {
		$factory = new microbe_TypeFactory();
		$behaviour = $factory->create($this->source->type);
		null;
	}
	public $source;
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
	function __toString() { return 'microbe.MicroParser'; }
}
