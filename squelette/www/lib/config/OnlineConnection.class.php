<?php

class config_OnlineConnection extends haxigniter_server_libraries_Database {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		$this->host = "localhost";
		$this->user = "root";
		$this->pass = "root";
		$this->database = "microbe";
		$this->driver = haxigniter_server_libraries_DatabaseDriver::$mysql;
		$this->debug = null;
		$this->port = null;
		$this->socket = null;
	}}
	static $__properties__ = array("set_connection" => "setConnection","get_connection" => "getConnection");
	function __toString() { return 'config.OnlineConnection'; }
}
