<?php

class vo_ChildManager extends sys_db_Manager {
	public function __construct($classval) { if(!php_Boot::$skip_constructor) {
		parent::__construct($classval);
	}}
	public function make($a) {
		haxe_Log::trace("make", _hx_anonymous(array("fileName" => "ChildTest.hx", "lineNumber" => 45, "className" => "vo.ChildManager", "methodName" => "make")));
	}
	public function unmake($a) {
		haxe_Log::trace("unmake", _hx_anonymous(array("fileName" => "ChildTest.hx", "lineNumber" => 53, "className" => "vo.ChildManager", "methodName" => "unmake")));
	}
	static $__properties__ = array("set_cnx" => "setConnection");
	function __toString() { return 'vo.ChildManager'; }
}
