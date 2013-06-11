<?php

class config_Config extends haxigniter_server_Config {
	public function __construct($dumpEnv = null) {
		if(!php_Boot::$skip_constructor) {
		microbe_tools_Debug::$debug = false;
		$this->development = $_SERVER['SERVER_NAME'] === "localhost" || $_SERVER['SERVER_NAME'] === "127.0.0.1";
		$this->controllerPackage = "controllers";
		$this->defaultController = "myfront";
		$this->defaultAction = "index";
		$this->indexFile = null;
		$this->indexPath = null;
		$this->applicationPath = null;
		$this->viewPath = null;
		$this->externalPath = null;
		$this->runtimePath = null;
		$this->logPath = null;
		$this->cachePath = null;
		$this->sessionPath = null;
		$this->router = null;
		$this->permittedUriChars = "a-z 0-9~%.:_-";
		$this->logLevel = (($this->development) ? haxigniter_server_libraries_DebugLevel::$info : haxigniter_server_libraries_DebugLevel::$warning);
		$this->logDateFormat = "%Y-%m-%d %H:%M:%S";
		$this->errorPage = null;
		$this->error404Page = null;
		$this->language = "english";
		$this->encryptionKey = null;
		$this->jsPath = "/microbe/js/";
		$this->cssPath = "/microbe/css/";
		$this->backjs = "backjs.js";
		$this->voPackage = "vo.";
		$this->uploadsPath = $this->applicationPath . "/uploads/";
		$this->imagesPath = $this->uploadsPath . "images/";
		$this->frontjsPath = "/js/";
		$this->frontcssPath = "/css/";
		parent::__construct($dumpEnv);
	}}
	public $frontcssPath;
	public $frontjsPath;
	public $backjs;
	public $imagesPath;
	public $uploadsPath;
	public $voPackage;
	public $cssPath;
	public $jsPath;
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
	static $backPage = "pipo";
	static $traductable = true;
	static $hclone = false;
	function __toString() { return 'config.Config'; }
}
