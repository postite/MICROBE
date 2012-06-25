<?php

class haxigniter_server_request_ApiDecorator extends haxigniter_server_request_RequestHandlerDecorator {
	public function __construct($requestHandler, $_config, $restrictClass, $addToArguments) {
		if(!php_Boot::$skip_constructor) {
		if($addToArguments === null) {
			$addToArguments = false;
		}
		$this->config = $_config;
		parent::__construct($requestHandler);
		$this->api = new microbe_Api();
	}}
	public $api;
	public $config;
	public $getPostData;
	public $requestData;
	public function handleRequest($controller, $url, $method, $getPostData, $requestData) {
		$uriSegments = _hx_deref(new haxigniter_server_libraries_Url($this->config))->split($url->path, null);
		$controllerType = Type::getClass($controller);
		$controllerMethod = haxigniter_server_request_ApiDecorator_0($this, $controller, $controllerType, $getPostData, $method, $requestData, $uriSegments, $url);
		$callMethod = Reflect::field($this->api, $controllerMethod);
		if($callMethod === null) {
			throw new HException(new haxigniter_server_exceptions_NotFoundException(Type::getClassName(_hx_qtype("microbe.Api")) . " method \"" . $controllerMethod . "\" not found.", null, _hx_anonymous(array("fileName" => "ApiDecorator.hx", "lineNumber" => 39, "className" => "haxigniter.server.request.ApiDecorator", "methodName" => "handleRequest"))));
		}
		$arguments = haxigniter_common_types_TypeFactory::typecastArguments(_hx_qtype("microbe.Api"), $controllerMethod, $uriSegments->slice(2, null), null);
		$this->getPostData = $getPostData;
		$this->requestData = $requestData;
		$result = Reflect::callMethod($this->api, $callMethod, $arguments);
		return haxigniter_server_request_RequestResult::$noOutput;
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
	function __toString() { return 'haxigniter.server.request.ApiDecorator'; }
}
function haxigniter_server_request_ApiDecorator_0(&$»this, &$controller, &$controllerType, &$getPostData, &$method, &$requestData, &$uriSegments, &$url) {
	if($uriSegments[1] === null) {
		return $»this->config->defaultAction;
	} else {
		return $uriSegments[1];
	}
}
