<?php

class microbe_controllers_LightController implements haxigniter_server_Controller{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->configuration = microbe_controllers_LightController::$appConfig;
	}}
	public $configuration;
	public $contentHandler;
	public $requestHandler;
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
	static $__rtti = "<class path=\"microbe.controllers.LightController\" params=\"\">\x0A\x09<implements path=\"haxigniter.server.Controller\"/>\x0A\x09<appConfig public=\"1\" line=\"62\" static=\"1\"><c path=\"config.Config\"/></appConfig>\x0A\x09<main public=\"1\" set=\"method\" line=\"94\" static=\"1\"><f a=\"\"><e path=\"Void\"/></f></main>\x0A\x09<requestHandler public=\"1\"><c path=\"haxigniter.server.request.RequestHandler\"/></requestHandler>\x0A\x09<contentHandler public=\"1\"><c path=\"haxigniter.server.content.ContentHandler\"/></contentHandler>\x0A\x09<configuration public=\"1\" set=\"null\"><c path=\"config.Config\"/></configuration>\x0A\x09<new public=\"1\" set=\"method\" line=\"123\">\x0A\x09\x09<f a=\"\"><e path=\"Void\"/></f>\x0A\x09\x09<haxe_doc>* The controllers are automatically created by haxigniter.server.Application.</haxe_doc>\x0A\x09</new>\x0A\x09<haxe_doc>* This class is the base controller, parent to all controllers in the application.\x0A * \x0A * It implements haxe.rtti.Infos because some request handlers (BasicHandler and RestHandler) \x0A * uses that info to typecast the web input from the web to the controller methods.\x0A * \x0A * NOTE: Controllers called by haXigniter can only have the starting character capitalized!\x0A *       MyController is never called, so it's excepted.</haxe_doc>\x0A\x09<meta><m n=\":rttiInfos\"/></meta>\x0A</class>";
	static $appConfig;
	static function main() {
	}
	function __toString() { return 'microbe.controllers.LightController'; }
}
microbe_controllers_LightController::$appConfig = new config_Config(null);
