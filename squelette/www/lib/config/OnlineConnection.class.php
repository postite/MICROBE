<?php

class config_OnlineConnection extends haxigniter_server_libraries_Database {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		$this->host = "mysql.alwaysdata.com";
		$this->user = "postite";
		$this->pass = "paglop";
		$this->database = "postite_tambour";
		$this->driver = haxigniter_server_libraries_DatabaseDriver::$mysql;
		$this->debug = null;
		$this->port = null;
		$this->socket = null;
	}}
	static $__properties__ = array("set_connection" => "setConnection","get_connection" => "getConnection");
	function __toString() { return 'config.OnlineConnection'; }
}
