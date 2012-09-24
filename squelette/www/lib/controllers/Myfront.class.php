<?php

class controllers_Myfront extends microbe_controllers_GenericController {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
		$this->api = new microbe_Api();
		$this->jsLib = new HList();
		$this->url = new haxigniter_server_libraries_Url($this->configuration);
	}}
	public function index() {
		$this->view->assign("link", $this->url->siteUrl(null, null));
		$this->view->assign("jsScript", $this->jsScript);
		$this->view->assign("jsLib", $this->jsLib);
		$this->view->assign("scope", $this);
		$this->view->assign("side", null);
		$this->view->assign("content", null);
		$this->view->display("front/frontest.html");
	}
	public $url;
	public $api;
	public $jsLib;
	public $jsScript;
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
	static $__rtti = "<class path=\"controllers.Myfront\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<jsScript public=\"1\"><c path=\"List\"><c path=\"String\"/></c></jsScript>\x0A\x09<jsLib public=\"1\"><c path=\"List\"><c path=\"String\"/></c></jsLib>\x0A\x09<api public=\"1\"><c path=\"microbe.Api\"/></api>\x0A\x09<url public=\"1\"><c path=\"haxigniter.server.libraries.Url\"/></url>\x0A\x09<index set=\"method\" line=\"31\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<new public=\"1\" set=\"method\" line=\"22\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Myfront'; }
}
