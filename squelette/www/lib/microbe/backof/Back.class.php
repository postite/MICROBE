<?php

class microbe_backof_Back extends microbe_controllers_GenericController {
	public function __construct($LoginPage) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->requestHandler = new haxigniter_server_request_AuthRequestDecorator(new haxigniter_server_request_BasicHandler($this->configuration), $LoginPage, $this->session, null, null);
		$this->url = new haxigniter_server_libraries_Url($this->configuration);
	}}
	public $url;
	public $chemins;
	public function index() {
		$this->view->assign("content", "popopopo");
		$this->view->display("simple.mtt");
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
	static $__rtti = "<class path=\"microbe.backof.Back\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<url public=\"1\"><c path=\"haxigniter.server.libraries.Url\"/></url>\x0A\x09<chemins><d/></chemins>\x0A\x09<index public=\"1\" set=\"method\" line=\"51\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<new public=\"1\" set=\"method\" line=\"15\"><f a=\"LoginPage\">\x0A\x09<c path=\"microbe.backof.Login\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></new>\x0A</class>";
	function __toString() { return 'microbe.backof.Back'; }
}
