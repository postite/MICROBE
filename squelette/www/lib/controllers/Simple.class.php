<?php

class controllers_Simple extends microbe_controllers_GenericController {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->test = "paf";
		parent::__construct();
		$this->log("new Simple", null);
		$url = new haxigniter_server_libraries_Url($this->configuration);
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
		$this->view->assign("application", "haXigniter");
		$this->view->assign("link", $url->siteUrl(null, null));
		$this->view->assign("id", null);
		$this->log("after new Simple", null);
	}}
	public $test;
	public function index() {
		$this->log("index", null);
	}
	public function show($id) {
		$this->view->assign("id", $id);
		$this->view->display("simple.html");
	}
	public function create($posted) {
		$this->trace($posted, null, _hx_anonymous(array("fileName" => "Simple.hx", "lineNumber" => 43, "className" => "controllers.Simple", "methodName" => "create")));
		$this->view->display("simple.html");
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->»dynamics[$m]) && is_callable($this->»dynamics[$m]))
			return call_user_func_array($this->»dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call «'.$m.'»');
	}
	static $__rtti = "<class path=\"controllers.Simple\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<test public=\"1\"><c path=\"String\"/></test>\x0A\x09<index public=\"1\" set=\"method\" line=\"27\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<show public=\"1\" set=\"method\" line=\"34\"><f a=\"id\">\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></show>\x0A\x09<create public=\"1\" set=\"method\" line=\"40\"><f a=\"posted\">\x0A\x09<c path=\"Hash\"><c path=\"String\"/></c>\x0A\x09<e path=\"Void\"/>\x0A</f></create>\x0A\x09<new public=\"1\" set=\"method\" line=\"8\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Simple'; }
}
