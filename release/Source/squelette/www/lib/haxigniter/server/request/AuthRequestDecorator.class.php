<?php

class haxigniter_server_request_AuthRequestDecorator extends haxigniter_server_request_RequestHandlerDecorator {
	public function __construct($requestHandler, $loginPage, $session, $restrictClass = null, $addToArguments = null) {
		if(!php_Boot::$skip_constructor) {
		if($addToArguments === null) {
			$addToArguments = false;
		}
		parent::__construct($requestHandler);
		$this->session = $session;
		$this->loginPage = $loginPage;
	}}
	public function handleRequest($controller, $url, $method, $getPostData, $requestData) {
		$result = null;
		if($this->session->user !== null) {
			$result = $this->requestHandler->handleRequest($controller, $url, $method, $getPostData, $requestData);
			return $result;
		} else {
			haxe_Log::trace("pas identifiÃ©", _hx_anonymous(array("fileName" => "AuthRequestDecorator.hx", "lineNumber" => 39, "className" => "haxigniter.server.request.AuthRequestDecorator", "methodName" => "handleRequest")));
			$result = $this->requestHandler->handleRequest($this->loginPage, $url, $method, $getPostData, $requestData);
			return $result;
		}
		return haxigniter_server_request_RequestResult::$noOutput;
	}
	public $loginPage;
	public $session;
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
	function __toString() { return 'haxigniter.server.request.AuthRequestDecorator'; }
}
