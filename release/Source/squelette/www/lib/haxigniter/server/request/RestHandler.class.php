<?php

class haxigniter_server_request_RestHandler implements haxigniter_server_request_RequestHandler{
	public function __construct($config, $passRequestData = null) {
		if(!php_Boot::$skip_constructor) {
		if($passRequestData === null) {
			$passRequestData = false;
		}
		$this->config = $config;
		$this->passRequestData = $passRequestData;
	}}
	public function handleRequest($controller, $url, $method, $getPostData, $requestData) {
		$action = null;
		$args = new _hx_array(array());
		$typecastId = false;
		$controllerType = Type::getClass($controller);
		$callMethod = null;
		$uriSegments = _hx_deref(new haxigniter_server_libraries_Url($this->config))->split($url->path, null);
		if($method === "GET") {
			$extraArgsPos = null;
			$argOffset = null;
			if($uriSegments->length <= 1) {
				$action = "index";
			} else {
				if($uriSegments[1] === "new") {
					$action = "make";
					$extraArgsPos = 2;
					$argOffset = 0;
				} else {
					if($uriSegments[2] === "edit") {
						$action = "edit";
						$extraArgsPos = 3;
					} else {
						$action = "show";
						$extraArgsPos = 2;
					}
					$args->push($uriSegments[1]);
					$argOffset = 1;
					$typecastId = true;
				}
			}
			$callMethod = Reflect::field($controller, $action);
			if($callMethod === null) {
				throw new HException(new haxigniter_server_exceptions_NotFoundException(Std::string($controllerType) . " REST-action \"" . $action . "\" not found.", null, _hx_anonymous(array("fileName" => "RestHandler.hx", "lineNumber" => 105, "className" => "haxigniter.server.request.RestHandler", "methodName" => "handleRequest"))));
			}
			if($extraArgsPos !== null) {
				$extraArguments = haxigniter_common_types_TypeFactory::typecastArguments(Type::getClass($controller), $action, $uriSegments->slice($extraArgsPos, null), $argOffset);
				$args = $args->concat($extraArguments);
			}
		} else {
			if($method === "POST") {
				$query = null;
				if($this->passRequestData) {
					$query = $requestData;
				} else {
					if($getPostData !== null) {
						$query = $getPostData;
					} else {
						$query = new Hash();
					}
				}
				if($uriSegments->length <= 1) {
					$action = "create";
					$args->push($query);
				} else {
					$action = (($uriSegments[2] === "delete") ? "destroy" : "update");
					$args->push($uriSegments[1]);
					$args->push($query);
					$typecastId = true;
				}
				$callMethod = Reflect::field($controller, $action);
				if($callMethod === null) {
					throw new HException(new haxigniter_server_exceptions_NotFoundException(Std::string($controllerType) . " REST-action \"" . $action . "\" not found.", null, _hx_anonymous(array("fileName" => "RestHandler.hx", "lineNumber" => 143, "className" => "haxigniter.server.request.RestHandler", "methodName" => "handleRequest"))));
				}
			} else {
				throw new HException(new haxigniter_common_exceptions_Exception("Unsupported HTTP method: " . $method, null, _hx_anonymous(array("fileName" => "RestHandler.hx", "lineNumber" => 147, "className" => "haxigniter.server.request.RestHandler", "methodName" => "handleRequest"))));
			}
		}
		if($typecastId) {
			$methodArgs = haxigniter_common_rtti_RttiUtil::getMethod($action, $controllerType);
			$args[0] = haxigniter_common_types_TypeFactory::createType($methodArgs->first()->type, $args[0]);
		}
		return haxigniter_server_request_RequestResult::methodCall($controller, $callMethod, $args);
	}
	public $passRequestData;
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
	function __toString() { return 'haxigniter.server.request.RestHandler'; }
}
