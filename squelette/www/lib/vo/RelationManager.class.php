<?php

class vo_RelationManager extends sys_db_Manager {
	public function __construct($classval) { if(!php_Boot::$skip_constructor) {
		parent::__construct($classval);
	}}
	public function make($a) {
		haxe_Log::trace("make", _hx_anonymous(array("fileName" => "RelationTest.hx", "lineNumber" => 44, "className" => "vo.RelationManager", "methodName" => "make")));
		$a->childListe = vo_ChildTest::$manager->unsafeObjects("SELECT * FROM child WHERE (rid = " . sys_db_Manager::quoteAny($a->id) . ") ORDER BY poz", null);
	}
	public function unmake($a) {
		haxe_Log::trace("unmake", _hx_anonymous(array("fileName" => "RelationTest.hx", "lineNumber" => 52, "className" => "vo.RelationManager", "methodName" => "unmake")));
		$a->childListe = vo_ChildTest::$manager->unsafeObjects("SELECT * FROM child WHERE (rid = " . sys_db_Manager::quoteAny($a->id) . ") ORDER BY poz", null);
	}
	static $__properties__ = array("set_cnx" => "setConnection");
	function __toString() { return 'vo.RelationManager'; }
}
