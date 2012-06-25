<?php

class haxigniter_server_Config {
	public function __construct($debug) {
		if(!php_Boot::$skip_constructor) {
		$env = Sys::environment();
		if($this->applicationPath === null) {
			$this->applicationPath = dirname($_SERVER["SCRIPT_FILENAME"]) . "/";
		}
		if($this->indexFile === null) {
			if($env->exists("SCRIPT_NAME")) {
				$this->indexFile = haxigniter_server_libraries_Server::basename($env->get("SCRIPT_NAME"), null);
			} else {
				throw new HException("indexFile cannot be auto-detected. Please set it in \"application/config/Config.hx\".");
			}
		}
		if($this->indexPath === null) {
			if($env->exists("SCRIPT_NAME")) {
				$script = $env->get("SCRIPT_NAME");
				$this->indexPath = _hx_substr($script, 0, _hx_last_index_of($script, "/", null) + 1);
			} else {
				throw new HException("indexPath cannot be auto-detected. Please set it in \"application/config/Config.hx\".");
			}
		}
		if($this->viewPath === null) {
			$this->viewPath = $this->applicationPath . "views/";
		}
		if($this->externalPath === null) {
			$this->externalPath = $this->applicationPath . "external/";
		}
		if($this->runtimePath === null) {
			$this->runtimePath = $this->applicationPath . "runtime/";
		}
		if($this->cachePath === null) {
			$this->cachePath = $this->runtimePath . "cache/";
		}
		if($this->logPath === null) {
			$this->logPath = $this->runtimePath . "logs/";
		}
		if($this->sessionPath === null) {
			$this->sessionPath = $this->runtimePath . "session/";
		}
		if($this->defaultController === null) {
			$this->defaultController = "start";
		}
		if($this->defaultAction === null) {
			$this->defaultAction = "index";
		}
		if($this->router === null) {
			$this->router = new haxigniter_server_routing_DefaultRouter();
		}
		if($debug !== null) {
			$this->dumpEnvironment($debug);
		}
	}}
	public $development;
	public $controllerPackage;
	public $indexFile;
	public $indexPath;
	public $applicationPath;
	public $viewPath;
	public $externalPath;
	public $runtimePath;
	public $logPath;
	public $cachePath;
	public $sessionPath;
	public $permittedUriChars;
	public $logLevel;
	public $logDateFormat;
	public $errorPage;
	public $error404Page;
	public $language;
	public $encryptionKey;
	public $defaultController;
	public $defaultAction;
	public $router;
	public $view;
	public function dumpEnvironment($logFile) {
		$date = DateTools::format(Date::now(), "%Y-%m-%d %H:%M:%S");
		$output = "";
		$output .= "*** [" . $date . "] Start of dump\x0A";
		$output .= "\x0AhaXigniter configuration:\x0A\x0A";
		{
			$_g = 0; $_g1 = Reflect::fields($this);
			while($_g < $_g1->length) {
				$field = $_g1[$_g];
				++$_g;
				if($field === "encryptionKey") {
					continue;
				}
				$output .= $field . ": '" . Reflect::field($this, $field) . "'\x0A";
				unset($field);
			}
		}
		$output .= "\x0AhaXe web environment ";
		$output .= "(PHP)";
		$output .= ":\x0A\x0A";
		$output .= "getCwd(): '" . (dirname($_SERVER["SCRIPT_FILENAME"]) . "/") . "'\x0A";
		$output .= "getHostName(): '" . $_SERVER['SERVER_NAME'] . "'\x0A";
		$output .= "getURI(): '" . php_Web::getURI() . "'\x0A";
		$output .= "getParamsString(): '" . php_Web::getParamsString() . "'\x0A";
		$output .= "\x0AServer environment:\x0A\x0A";
		if(null == Sys::environment()) throw new HException('null iterable');
		$»it = Sys::environment()->keys();
		while($»it->hasNext()) {
			$field = $»it->next();
			$output .= $field . ": '" . Sys::environment()->get($field) . "'\x0A";
		}
		$output .= "\x0APHP environment:\x0A\x0A";
		ob_start();
		foreach($_SERVER as $_dk => $_dv) echo "$_dk: '$_dv'
";;
		$output .= ob_get_clean();
		$output .= "\x0A*** End of dump";
		if(!Std::is($logFile, _hx_qtype("String"))) {
			$output = "<hr><pre>" . $output . "</pre><hr>";
			php_Lib::hprint($output);
		} else {
			if(!file_exists($logFile)) {
				sys_io_File::saveContent($logFile, $output);
			}
		}
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
	function __toString() { return 'haxigniter.server.Config'; }
}
