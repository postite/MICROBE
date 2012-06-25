<?php

class haxigniter_server_Application {
	public function __construct(){}
	static function run($config, $errorHandler) {
		$controller = null;
		try {
			$method = php_Web::getMethod();
			$requestData = (($method === "GET") ? null : haxigniter_server_libraries_Server::requestContentFromWeb());
			$controller = _hx_deref(new haxigniter_server_libraries_Request($config))->execute(haxigniter_server_Application_0($config, $controller, $errorHandler, $method, $requestData), $method, php_Web::getParams(), $requestData, (isset(haxigniter_server_libraries_Server::$outputContentToWeb) ? haxigniter_server_libraries_Server::$outputContentToWeb: array("haxigniter_server_libraries_Server", "outputContentToWeb")));
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			$e = $_ex_;
			{
				if($errorHandler !== null) {
					call_user_func_array($errorHandler, array($e));
				} else {
					if($config->development) {
						php_Lib::rethrow($e);
					} else {
						if(Std::is($e, _hx_qtype("haxigniter.server.exceptions.NotFoundException"))) {
							$server = new haxigniter_server_libraries_Server($config, null, null);
							$server->error404(null, null, null);
						} else {
							if(Std::is($e, _hx_qtype("haxigniter.common.exceptions.Exception"))) {
								$fullClass = Type::getClassName(Type::getClass($e));
								haxigniter_server_Application::logError($config, "[" . _hx_substr($fullClass, _hx_last_index_of($fullClass, ".", null) + 1, null) . "] " . $e->message, $e);
							} else {
								haxigniter_server_Application::logError($config, Std::string($e), $e);
							}
						}
					}
				}
			}
		}
		return $controller;
	}
	static function logError($config, $message, $e) {
		$server = new haxigniter_server_libraries_Server($config, null, null);
		$debug = new haxigniter_server_libraries_Debug($config, null, null, null);
		$error = haxigniter_server_Application::genericError($e);
		$debug->log($message, haxigniter_server_libraries_DebugLevel::$error);
		$server->error($error->title, $error->header, $error->message, null);
	}
	static function genericError($e) { return call_user_func_array(self::$genericError, array($e)); }
	public static $genericError = null;
	static function requestUrl() {
		$url = $_SERVER['SERVER_NAME'] . php_Web::getURI();
		$params = php_Web::getParamsString();
		if($params !== null && strlen($params) > 0) {
			$url .= "?" . $params;
		}
		return $url;
	}
	function __toString() { return 'haxigniter.server.Application'; }
}
haxigniter_server_Application::$genericError = array(new _hx_lambda(array(), "haxigniter_server_Application_1"), 'execute');
function haxigniter_server_Application_0(&$config, &$controller, &$errorHandler, &$method, &$requestData) {
	{
		$url = $_SERVER['SERVER_NAME'] . php_Web::getURI();
		$params = php_Web::getParamsString();
		if($params !== null && strlen($params) > 0) {
			$url .= "?" . $params;
		}
		return $url;
	}
}
function haxigniter_server_Application_1($e) {
	{
		return _hx_anonymous(array("title" => "Page error", "header" => "Page error", "message" => "Something went wrong during server processing."));
	}
}
