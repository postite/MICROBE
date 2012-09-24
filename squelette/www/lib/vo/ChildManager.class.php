<?php

class vo_ChildManager extends sys_db_Manager {
	public function __construct($classval) { if(!php_Boot::$skip_constructor) {
		parent::__construct($classval);
	}}
	public function unmake($a) {
		null;
	}
	public function make($a) {
		null;
	}
	static $__properties__ = array("set_cnx" => "setConnection");
	function __toString() { return 'vo.ChildManager'; }
}
