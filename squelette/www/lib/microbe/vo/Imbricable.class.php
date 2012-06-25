<?php

class microbe_vo_Imbricable extends sys_db_Object {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		microbe_tools_Debug::Alerte("new", _hx_anonymous(array("fileName" => "Imbricable.hx", "lineNumber" => 21, "className" => "microbe.vo.Imbricable", "methodName" => "new")));
		parent::__construct();
	}}
	public $positions;
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
	static $manager;
	function __toString() { return 'microbe.vo.Imbricable'; }
}
microbe_vo_Imbricable::$manager = new sys_db_Manager(_hx_qtype("microbe.vo.Imbricable"));
