<?php

class controllers_Upload implements haxigniter_server_Controller{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->config = new config_Config(null);
		$this->debug = controllers_Upload::$appDebug;
		$this->requestHandler = new haxigniter_server_request_FileUploadDecorator(new haxigniter_server_request_RestHandler($this->config, null), null, null);
		$url = new haxigniter_server_libraries_Url($this->config);
	}}
	public function trace($data, $debugLevel = null, $pos = null) {
		$this->debug->trace($data, $debugLevel, $pos);
	}
	public function create($posted, $files = null, $bytes = null) {
		controllers_Upload::$appDebug->log("bytes=" . _hx_string_rec($bytes, ""), null);
		if($bytes > 1024000) {
			php_Lib::hprint("tooBig");
			return;
		}
		$name = "";
		if(null == $files) throw new HException('null iterable');
		$»it = $files->iterator();
		while($»it->hasNext()) {
			$i = $»it->next();
			if(!($i->name === "")) {
				php_Lib::hprint($i->copyTo($this->config->imagesPath));
			}
		}
	}
	public function show($id) {
		$this->view->assign("id", $id);
	}
	public function index() {
	}
	public $debug;
	public $view;
	public $config;
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
	static $__rtti = "<class path=\"controllers.Upload\" params=\"\">\x0A\x09<implements path=\"haxigniter.server.Controller\"/>\x0A\x09<appConfig line=\"30\" static=\"1\"><c path=\"config.Config\"/></appConfig>\x0A\x09<appDebug line=\"33\" static=\"1\"><c path=\"haxigniter.server.libraries.Debug\"/></appDebug>\x0A\x09<main public=\"1\" set=\"method\" line=\"92\" static=\"1\"><f a=\"\"><e path=\"Void\"/></f></main>\x0A\x09<requestHandler public=\"1\"><c path=\"haxigniter.server.request.RequestHandler\"/></requestHandler>\x0A\x09<contentHandler public=\"1\"><c path=\"haxigniter.server.content.ContentHandler\"/></contentHandler>\x0A\x09<config public=\"1\" set=\"null\"><c path=\"config.Config\"/></config>\x0A\x09<view public=\"1\" set=\"null\"><c path=\"haxigniter.server.views.ViewEngine\"/></view>\x0A\x09<debug public=\"1\"><c path=\"haxigniter.server.libraries.Debug\"/></debug>\x0A\x09<index public=\"1\" set=\"method\" line=\"48\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<show public=\"1\" set=\"method\" line=\"53\"><f a=\"id\">\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></show>\x0A\x09<create public=\"1\" set=\"method\" line=\"59\"><f a=\"posted:?files:?bytes\">\x0A\x09<c path=\"Hash\"><c path=\"String\"/></c>\x0A\x09<c path=\"Hash\"><c path=\"haxigniter.server.request.FileInfo\"/></c>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></create>\x0A\x09<trace set=\"method\" line=\"87\"><f a=\"data:?debugLevel:?pos\">\x0A\x09<d/>\x0A\x09<e path=\"haxigniter.server.libraries.DebugLevel\"/>\x0A\x09<t path=\"haxe.PosInfos\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></trace>\x0A\x09<new public=\"1\" set=\"method\" line=\"37\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A\x09<meta><m n=\":rttiInfos\"/></meta>\x0A</class>";
	static $appConfig;
	static $appDebug;
	static function main() {
		haxigniter_server_Application::run(controllers_Upload::$appConfig, null);
	}
	function __toString() { return 'controllers.Upload'; }
}
controllers_Upload::$appConfig = new config_Config(null);
controllers_Upload::$appDebug = new haxigniter_server_libraries_Debug(controllers_Upload::$appConfig, null, null, null);
