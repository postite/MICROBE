<?php

class vo_TaxoManager extends sys_db_Manager {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct(_hx_qtype("vo.Taxo"));
	}}
	static $__properties__ = array("set_cnx" => "setConnection");
	function __toString() { return 'vo.TaxoManager'; }
}
