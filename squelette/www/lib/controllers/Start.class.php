<?php

class controllers_Start extends microbe_controllers_GenericController {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$url = new haxigniter_server_libraries_Url($this->configuration);
		$this->view->assign("application", "haXigniter");
		$this->view->assign("link", $url->siteUrl(null, null));
		$this->view->assign("id", null);
	}}
	public function index() {
		$this->view->displayDefault(_hx_anonymous(array("fileName" => "Simple.hx", "lineNumber" => 25, "className" => "controllers.Start", "methodName" => "index")));
	}
	public function show($id) {
		$this->view->assign("id", $id);
		$this->view->display("simple.html");
	}
	public function create($posted) {
		$this->trace($posted, null, _hx_anonymous(array("fileName" => "Simple.hx", "lineNumber" => 37, "className" => "controllers.Start", "methodName" => "create")));
		$this->view->display("simple.html");
	}
	static $__rtti = "<class path=\"controllers.Start\" params=\"\" module=\"controllers.Simple\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<index public=\"1\" set=\"method\" line=\"22\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<show public=\"1\" set=\"method\" line=\"28\"><f a=\"id\">\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></show>\x0A\x09<create public=\"1\" set=\"method\" line=\"34\"><f a=\"posted\">\x0A\x09<c path=\"Hash\"><c path=\"String\"/></c>\x0A\x09<e path=\"Void\"/>\x0A</f></create>\x0A\x09<new public=\"1\" set=\"method\" line=\"5\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Start'; }
}
