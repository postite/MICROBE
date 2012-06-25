<?php

class haxigniter_server_libraries_Url {
	public function __construct($config) {
		if(!php_Boot::$skip_constructor) {
		$this->config = $config;
	}}
	public $config;
	public $SSLInDevelopmentMode;
	public function segmentString($uri, $separator) {
		if($separator === null) {
			$separator = "/";
		}
		if($uri === null) {
			$uri = php_Web::getURI();
		}
		if($this->config->indexFile === "") {
			$modRewriteTest = new EReg("/[\\w-]+\\.[\\w-]+\$", "");
			if($modRewriteTest->match($uri)) {
				$uri = _hx_substr($uri, 0, strlen($uri) - strlen($modRewriteTest->matched(0)) + 1);
			}
		}
		$indexFile = $this->config->indexPath . $this->config->indexFile;
		if(StringTools::startsWith($uri, $indexFile)) {
			$uri = _hx_substr($uri, strlen($indexFile), null);
		}
		if(StringTools::startsWith($uri, $separator)) {
			$uri = _hx_substr($uri, 1, null);
		}
		if(StringTools::endsWith($uri, $separator)) {
			$uri = _hx_substr($uri, 0, strlen($uri) - 1);
		}
		return trim($uri);
	}
	public function split($uri, $glue) {
		if($glue === null) {
			$glue = "/";
		}
		$uri = $this->segmentString($uri, $glue);
		return ((strlen($uri) > 0) ? _hx_explode($glue, $uri) : new _hx_array(array()));
	}
	public function linkUrl() {
		return _hx_substr($this->config->indexPath, 0, strlen($this->config->indexPath) - 1);
	}
	public function siteUrl($request, $requestArray) {
		$url = $this->config->indexPath . $this->config->indexFile;
		if($requestArray === null) {
			$requestArray = new _hx_array(array());
		}
		if($request !== null) {
			$requestArray->unshift($request);
		}
		$requestArray->unshift(((StringTools::endsWith($url, "/")) ? _hx_substr($url, 0, strlen($url) - 1) : $url));
		return $requestArray->join("/");
	}
	public function uriString() {
		$output = php_Web::getURI();
		return haxigniter_server_libraries_Url_0($this, $output);
	}
	public function testValidUri($uri) {
		if($this->config->permittedUriChars === null) {
			return;
		}
		$regexp = "^[/" . haxigniter_common_libraries_ERegTools::quoteMeta($this->config->permittedUriChars) . "]*\$";
		$validUrl = new EReg($regexp, "i");
		if(!$validUrl->match($uri)) {
			throw new HException(new haxigniter_common_exceptions_Exception("URI submitted with disallowed characters: " . $uri, null, _hx_anonymous(array("fileName" => "Url.hx", "lineNumber" => 142, "className" => "haxigniter.server.libraries.Url", "methodName" => "testValidUri"))));
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
	static function join($segments, $glue) {
		if($glue === null) {
			$glue = "/";
		}
		if($segments->length === 0) {
			return "";
		}
		if($segments->length === 1) {
			return $segments[0];
		}
		$last = $segments->length - 1;
		$output = new HList();
		$output->add(haxigniter_server_libraries_Url_1($glue, $last, $output, $segments));
		$reg = new EReg("^/?(.*)/?\$", "");
		{
			$_g = 1;
			while($_g < $last) {
				$i = $_g++;
				$output->add($reg->replace($segments[$i], "\$1"));
				unset($i);
			}
		}
		$output->add(haxigniter_server_libraries_Url_2($glue, $last, $output, $reg, $segments));
		return $output->join($glue);
	}
	function __toString() { return 'haxigniter.server.libraries.Url'; }
}
function haxigniter_server_libraries_Url_0(&$»this, &$output) {
	if(StringTools::startsWith($output, "/")) {
		return $output;
	} else {
		return "/" . $output;
	}
}
function haxigniter_server_libraries_Url_1(&$glue, &$last, &$output, &$segments) {
	if(StringTools::endsWith($segments[0], $glue)) {
		return _hx_substr($segments[0], 0, strlen($segments[0]) - 1);
	} else {
		return $segments[0];
	}
}
function haxigniter_server_libraries_Url_2(&$glue, &$last, &$output, &$reg, &$segments) {
	if(StringTools::startsWith($segments[$last], $glue)) {
		return _hx_substr($segments[$last], 1, null);
	} else {
		return $segments[$last];
	}
}
