<?php

class controllers_Install extends microbe_controllers_GenericController {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
		sys_db_Manager::cleanup();
		sys_db_Manager::setConnection($this->db->getConnection());
		sys_db_Manager::initialize();
	}}
	public function index() {
	}
	static $__rtti = "<class path=\"controllers.Install\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<index set=\"method\" line=\"27\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<new set=\"method\" line=\"17\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Install'; }
}
