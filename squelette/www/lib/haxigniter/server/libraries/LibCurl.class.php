<?php

class haxigniter_server_libraries_LibCurl {
	public function __construct($url, $returnHeader, $verifySSL) {
		if(!php_Boot::$skip_constructor) {
		if($verifySSL === null) {
			$verifySSL = false;
		}
		if($returnHeader === null) {
			$returnHeader = false;
		}
		if($url !== null) {
			$this->handle = curl_init($url);
		} else {
			$this->handle = curl_init();
		}
		$this->setOpt(haxigniter_server_libraries_CurlOpt::$RETURNTRANSFER, true);
		$this->returnTransfer = true;
		$this->setOpt(haxigniter_server_libraries_CurlOpt::$HEADER, $returnHeader);
		if(!$verifySSL) {
			$this->setOpt(haxigniter_server_libraries_CurlOpt::$SSL_VERIFYHOST, false);
			$this->setOpt(haxigniter_server_libraries_CurlOpt::$SSL_VERIFYPEER, false);
		}
	}}
	public $handle;
	public $returnTransfer;
	public function setOpt($option, $value) {
		if($option === haxigniter_server_libraries_CurlOpt::$RETURNTRANSFER) {
			$this->returnTransfer = empty($value);
		}
		return curl_setopt($this->handle, $option, $value);
	}
	public function close() {
		curl_close();
	}
	public function copyHandle() {
		$output = Type::createEmptyInstance(_hx_qtype("haxigniter.server.libraries.LibCurl"));
		$output->{"handle"} = curl_copy_handle($this->handle);
		$output->{"returnTransfer"} = $this->returnTransfer;
		return $output;
	}
	public function errNo() {
		return curl_errno($this->handle);
	}
	public function error() {
		return curl_error($this->handle);
	}
	public function exec() {
		$output = curl_exec($this->handle);
		if(!$this->returnTransfer || ($output === false)) {
			return null;
		} else {
			return $output;
		}
	}
	public function getInfo($opt) {
		return php_Lib::hashOfAssociativeArray(curl_getinfo($this->handle, $opt));
	}
	public function version() {
		return php_Lib::hashOfAssociativeArray(curl_version($opt));
	}
	public function get($url, $data) {
		$this->setOpt(haxigniter_server_libraries_CurlOpt::$POST, false);
		return $this->sendRequest($url, $data, null);
	}
	public function post($url, $data) {
		$this->setOpt(haxigniter_server_libraries_CurlOpt::$POST, true);
		return $this->sendRequest($url, $data, null);
	}
	public function put($url, $data) {
		return $this->sendRequest($url, $data, "PUT");
	}
	public function delete($url, $data) {
		return $this->sendRequest($url, $data, "DELETE");
	}
	public function sendRequest($url, $data, $method) {
		$this->setOpt(haxigniter_server_libraries_CurlOpt::$URL, $url);
		if($data !== null) {
			if(!Std::is($data, _hx_qtype("String"))) {
				$data = $this->toQueryString($data);
			}
			$this->setOpt(haxigniter_server_libraries_CurlOpt::$POSTFIELDS, $data);
		}
		if($method !== null) {
			$this->setOpt(haxigniter_server_libraries_CurlOpt::$POST, false);
			$this->setOpt(haxigniter_server_libraries_CurlOpt::$CUSTOMREQUEST, $method);
		}
		return $this->exec();
	}
	public function toQueryString($data) {
		if($data === null) {
			return "";
		}
		$fieldNames = null;
		$valueOf = null;
		if(Std::is($data, _hx_qtype("String"))) {
			return $data;
		}
		if(Std::is($data, _hx_qtype("Hash"))) {
			$hash = $data;
			$fieldNames = $hash->keys();
			$valueOf = array(new _hx_lambda(array(&$data, &$fieldNames, &$hash, &$valueOf), "haxigniter_server_libraries_LibCurl_0"), 'execute');
		} else {
			$fieldNames = Reflect::fields($data)->iterator();
			$valueOf = array(new _hx_lambda(array(&$data, &$fieldNames, &$valueOf), "haxigniter_server_libraries_LibCurl_1"), 'execute');
		}
		$buf = new StringBuf();
		$isFirst = true;
		$»it = $fieldNames;
		while($»it->hasNext()) {
			$fieldName = $»it->next();
			$fieldValue = call_user_func_array($valueOf, array($fieldName));
			if($isFirst) {
				$isFirst = false;
			} else {
				$x = "&";
				if(is_null($x)) {
					$x = "null";
				} else {
					if(is_bool($x)) {
						$x = (($x) ? "true" : "false");
					}
				}
				$buf->b .= $x;
				unset($x);
			}
			{
				$x = $fieldName;
				if(is_null($x)) {
					$x = "null";
				} else {
					if(is_bool($x)) {
						$x = (($x) ? "true" : "false");
					}
				}
				$buf->b .= $x;
				unset($x);
			}
			{
				$x = "=";
				if(is_null($x)) {
					$x = "null";
				} else {
					if(is_bool($x)) {
						$x = (($x) ? "true" : "false");
					}
				}
				$buf->b .= $x;
				unset($x);
			}
			{
				$x = rawurlencode(Std::string($fieldValue));
				if(is_null($x)) {
					$x = "null";
				} else {
					if(is_bool($x)) {
						$x = (($x) ? "true" : "false");
					}
				}
				$buf->b .= $x;
				unset($x);
			}
			unset($fieldValue);
		}
		return $buf->b;
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
	static function isAvailable() {
		return extension_loaded("curl");
	}
	function __toString() { return 'haxigniter.server.libraries.LibCurl'; }
}
function haxigniter_server_libraries_LibCurl_0(&$data, &$fieldNames, &$hash, &$valueOf, $fieldName) {
	{
		return Std::string($hash->get($fieldName));
	}
}
function haxigniter_server_libraries_LibCurl_1(&$data, &$fieldNames, &$valueOf, $fieldName) {
	{
		return Reflect::field($data, $fieldName);
	}
}
