<?php

class controllers_Gap extends microbe_controllers_GenericController {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->requestHandler = new haxigniter_server_request_ApiDecorator(new haxigniter_server_request_BasicHandler($this->configuration), $this->configuration, null, null);
	}}
	public function index($d) {
		$this->view->assign("content", _hx_string_call($d, "toString", array()));
		$this->view->display("simple.mtt");
	}
	static $__rtti = "<class path=\"controllers.Gap\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<index set=\"method\" line=\"21\"><f a=\"d\">\x0A\x09<d/>\x0A\x09<e path=\"Void\"/>\x0A</f></index>\x0A\x09<new public=\"1\" set=\"method\" line=\"15\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Gap'; }
}
