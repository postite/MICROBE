<?php

class controllers_Terazor extends microbe_controllers_GenericController {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
	}}
	public function index() {
		$liste = new HList();
		$liste->add(_hx_anonymous(array("label" => "UN", "data" => "one")));
		$liste->add(_hx_anonymous(array("label" => "DEUX", "data" => "two")));
		$liste->add(_hx_anonymous(array("label" => "TROIS", "data" => "three")));
		$this->view->assign("test", "heelo world");
		$this->view->assign("liste", $liste);
		$this->view->display("test/ErazorTest.html");
	}
	static $__rtti = "<class path=\"controllers.Terazor\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<index public=\"1\" set=\"method\" line=\"17\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<new public=\"1\" set=\"method\" line=\"11\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Terazor'; }
}
