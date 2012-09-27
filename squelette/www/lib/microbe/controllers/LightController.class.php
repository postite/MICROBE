<?php

class microbe_controllers_LightController implements haxe_rtti_Infos, haxigniter_server_Controller{
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
	static $__rtti = "<class path=\"microbe.controllers.LightController\" params=\"\">\x0A\x09<implements path=\"haxe.rtti.Infos\"/>\x0A\x09<implements path=\"haxigniter.server.Controller\"/>\x0A\x09<appConfig public=\"1\" line=\"61\" static=\"1\"><c path=\"config.Config\"/></appConfig>\x0A\x09<main public=\"1\" set=\"method\" line=\"93\" static=\"1\"><f a=\"\"><e path=\"Void\"/></f></main>\x0A\x09<requestHandler public=\"1\"><c path=\"haxigniter.server.request.RequestHandler\"/></requestHandler>\x0A\x09<contentHandler public=\"1\"><c path=\"haxigniter.server.content.ContentHandler\"/></contentHandler>\x0A\x09<configuration public=\"1\" set=\"null\"><c path=\"config.Config\"/></configuration>\x0A\x09<new public=\"1\" set=\"method\" line=\"122\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	static $appConfig;
	static function main() {
	}
	function __toString() { return 'microbe.controllers.LightController'; }
}
microbe_controllers_LightController::$appConfig = new config_Config(null);
