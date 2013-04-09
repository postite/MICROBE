<?php

class haxigniter_server_libraries_Request {
	public function __construct($config) {
		if(!php_Boot::$skip_constructor) {
		$this->config = $config;
	}}
	public function testUrl($url) {
		$parsedUrl = new haxigniter_common_libraries_ParsedUrl($url);
		_hx_deref(new haxigniter_server_libraries_Url($this->config))->testValidUri($parsedUrl->path);
		return $parsedUrl;
	}
	public function requestResultOutput($result) {
		$»t = ($result);
		switch($»t->index) {
		case 1:
		$value = $»t->params[0];
		{
			return $value;
		}break;
		case 2:
		$arguments = $»t->params[2]; $method = $»t->params[1]; $object = $»t->params[0];
		{
			return Reflect::callMethod($object, $method, $arguments);
		}break;
		case 0:
		{
			return null;
		}break;
		}
	}
	public function execute($url, $method = null, $getPostData = null, $requestContent = null, $outputFunction = null) {
		if($method === null) {
			$method = "GET";
		}
		$parsedUrl = haxigniter_server_libraries_Request_0($this, $getPostData, $method, $outputFunction, $requestContent, $url);
		$controller = $this->config->router->createController($this->config, $parsedUrl);
		$requestData = null;
		if($requestContent !== null && $method !== "GET") {
			if($controller->contentHandler !== null) {
				$requestData = $controller->contentHandler->input($requestContent);
			} else {
				$requestData = $requestContent->data;
			}
		}
		if($controller->requestHandler === null) {
			$controller->requestHandler = new haxigniter_server_request_BasicHandler($this->config);
		}
		$result = $controller->requestHandler->handleRequest($controller, $parsedUrl, $method, $getPostData, $requestData);
		$output = $this->requestResultOutput($result);
		if($output !== null && $outputFunction !== null && $controller->contentHandler !== null) {
			$outContent = $controller->contentHandler->output($output);
			if($outContent !== null) {
				call_user_func_array($outputFunction, array($outContent));
			}
		}
		return $controller;
	}
	public function internal($request, $method = null, $getPostData = null, $requestData = null) {
		if($method === null) {
			$method = "GET";
		}
		if(!StringTools::startsWith($request, "/")) {
			$request = "/" . $request;
		}
		$parsedUrl = haxigniter_server_libraries_Request_1($this, $getPostData, $method, $request, $requestData);
		$controller = $this->config->router->createController($this->config, $parsedUrl);
		if($controller->requestHandler === null) {
			$controller->requestHandler = new haxigniter_server_request_BasicHandler($this->config);
		}
		$result = $controller->requestHandler->handleRequest($controller, $parsedUrl, $method, $getPostData, $requestData);
		return $this->requestResultOutput($result);
	}
	public function createController($controllerName, $controllerArgs = null) {
		$controllerClass = haxigniter_server_libraries_Request_2($this, $controllerArgs, $controllerName);
		$controllerClass = $this->config->controllerPackage . "." . strtoupper(_hx_substr($controllerClass, 0, 1)) . _hx_substr($controllerClass, 1, null);
		$classType = Type::resolveClass($controllerClass);
		if($classType === null) {
			throw new HException(new haxigniter_server_exceptions_NotFoundException($controllerClass . " not found. (Is it defined in Config.hx and has only the first character Capitalized?)", null, _hx_anonymous(array("fileName" => "Request.hx", "lineNumber" => 38, "className" => "haxigniter.server.libraries.Request", "methodName" => "createController"))));
		}
		return Type::createInstance($classType, (($controllerArgs === null) ? new _hx_array(array()) : $controllerArgs));
	}
	public $config;
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
	function __toString() { return 'haxigniter.server.libraries.Request'; }
}
function haxigniter_server_libraries_Request_0(&$»this, &$getPostData, &$method, &$outputFunction, &$requestContent, &$url) {
	{
		$parsedUrl = new haxigniter_common_libraries_ParsedUrl($url);
		_hx_deref(new haxigniter_server_libraries_Url($»this->config))->testValidUri($parsedUrl->path);
		return $parsedUrl;
	}
}
function haxigniter_server_libraries_Request_1(&$»this, &$getPostData, &$method, &$request, &$requestData) {
	{
		$parsedUrl = new haxigniter_common_libraries_ParsedUrl($request);
		_hx_deref(new haxigniter_server_libraries_Url($»this->config))->testValidUri($parsedUrl->path);
		return $parsedUrl;
	}
}
function haxigniter_server_libraries_Request_2(&$»this, &$controllerArgs, &$controllerName) {
	if($controllerName === null || $controllerName === "") {
		return $»this->config->defaultController;
	} else {
		return $controllerName;
	}
}
