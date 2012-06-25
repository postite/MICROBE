<?php

class haxigniter_server_request_BasicHandler implements haxigniter_server_request_RequestHandler{
	public function __construct($config) {
		if(!php_Boot::$skip_constructor) {
		$this->config = $config;
	}}
	public $config;
	public $getPostData;
	public $requestData;
	public function handleRequest($controller, $url, $method, $getPostData, $requestData) {
		microbe_controllers_GenericController::$appDebug->log("handlerequest", null);
		$uriSegments = _hx_deref(new haxigniter_server_libraries_Url($this->config))->split($url->path, null);
		$controllerType = Type::getClass($controller);
		$controllerMethod = haxigniter_server_request_BasicHandler_0($this, $controller, $controllerType, $getPostData, $method, $requestData, $uriSegments, $url);
		microbe_controllers_GenericController::$appDebug->log("handlerequestend1" . Std::string($controllerType), null);
		$callMethod = Reflect::field($controller, $controllerMethod);
		microbe_controllers_GenericController::$appDebug->log("handlerequestend1.5" . Std::string($callMethod), null);
		if($callMethod === null) {
			throw new HException(new haxigniter_server_exceptions_NotFoundException(Type::getClassName($controllerType) . " method \"" . $controllerMethod . "\" not found.", null, _hx_anonymous(array("fileName" => "BasicHandler.hx", "lineNumber" => 36, "className" => "haxigniter.server.request.BasicHandler", "methodName" => "handleRequest"))));
		}
		microbe_controllers_GenericController::$appDebug->log("handlerequestend2", null);
		$arguments = haxigniter_common_types_TypeFactory::typecastArguments($controllerType, $controllerMethod, $uriSegments->slice(2, null), null);
		microbe_controllers_GenericController::$appDebug->log("handlerequestend3", null);
		$this->getPostData = $getPostData;
		$this->requestData = $requestData;
		microbe_controllers_GenericController::$appDebug->log("handlerequestend", null);
		return haxigniter_server_request_RequestResult::methodCall($controller, $callMethod, $arguments);
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
	function __toString() { return 'haxigniter.server.request.BasicHandler'; }
}
function haxigniter_server_request_BasicHandler_0(&$»this, &$controller, &$controllerType, &$getPostData, &$method, &$requestData, &$uriSegments, &$url) {
	if($uriSegments[1] === null) {
		return $»this->config->defaultAction;
	} else {
		return $uriSegments[1];
	}
}
