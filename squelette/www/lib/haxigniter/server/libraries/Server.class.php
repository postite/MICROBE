<?php

class haxigniter_server_libraries_Server {
	public function __construct($config, $session, $SSLInDevelopmentMode) {
		if(!php_Boot::$skip_constructor) {
		if($SSLInDevelopmentMode === null) {
			$SSLInDevelopmentMode = false;
		}
		$this->config = $config;
		$this->session = $session;
		$this->SSLInDevelopmentMode = $SSLInDevelopmentMode;
	}}
	public $config;
	public $session;
	public $SSLInDevelopmentMode;
	public function requireExternal($path) {
		require_once($this->config->externalPath . $path);
	}
	public function error404($title, $header, $message) {
		if($title === null) {
			$title = "404 not found";
		}
		if($header === null) {
			$header = $title;
		}
		if($message === null) {
			$message = "The page you requested was not found.";
		}
		$this->error($title, $header, $message, 404);
	}
	public function error($title, $header, $message, $returnCode) {
		$errorPage = haxigniter_server_libraries_Server_0($this, $header, $message, $returnCode, $title);
		if($returnCode !== null) {
			php_Web::setReturnCode($returnCode);
		}
		if($errorPage === null) {
			$content = sys_io_File::getContent($this->config->viewPath . "error.html");
			$content = str_replace("::TITLE::", $title, $content);
			$content = str_replace("::HEADER::", $header, $content);
			$content = str_replace("::MESSAGE::", $message, $content);
			php_Lib::hprint($content);
		} else {
			$request = new haxigniter_server_libraries_Request($this->config);
			$request->execute($errorPage, null, null, null, null);
		}
	}
	public function redirect($url, $flashMessage, $https, $responseCode) {
		if($flashMessage !== null && $this->session !== null) {
			$this->session->setFlash($flashMessage);
		}
		if($responseCode !== null) {
			php_Web::setReturnCode($responseCode);
		}
		$urlLib = new haxigniter_server_libraries_Url($this->config);
		if($url === null) {
			$url = $urlLib->siteUrl($urlLib->uriString(), null);
		} else {
			if(!StringTools::startsWith($url, "/") && _hx_index_of($url, "://", null) === -1) {
				$url = $urlLib->siteUrl($url, null);
			}
		}
		if($https !== null) {
			$url = ((($https) ? "https" : "http")) . _hx_substr($url, _hx_index_of($url, ":", null), null);
		}
		if($this->config->development && !$this->SSLInDevelopmentMode) {
			$url = str_replace("https://", "http://", $url);
		}
		php_Web::redirect($url);
	}
	public function forceSsl($ssl, $sslActive) {
		if($ssl === null) {
			$ssl = true;
		}
		if($this->config->development && !$this->SSLInDevelopmentMode) {
			return;
		}
		if($sslActive === null) {
			$sslActive = Sys::environment()->exists("HTTPS") && Sys::environment()->get("HTTPS") === "on";
		}
		if($sslActive && $ssl || !($sslActive || $ssl)) {
			return;
		}
		$this->redirect(null, haxigniter_server_libraries_Server_1($this, $ssl, $sslActive), $ssl, null);
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
	static function param($parameter) {
		try {
			return $_SERVER[$parameter];
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			if(is_string($e = $_ex_)){
				return null;
			} else throw $»e;;
		}
	}
	static function outputContentToWeb($content) {
		if($content === null) {
			return;
		}
		$header = new _hx_array(array());
		if($content->mimeType !== null) {
			$header->push($content->mimeType);
		}
		if($content->charSet !== null) {
			$header->push("charset=" . $content->charSet);
		}
		if($header->length > 0) {
			header("Content-Type" . ": " . $header->join("; "));
		}
		if($content->encoding !== null) {
			header("Content-Encoding" . ": " . $content->encoding);
		}
		php_Lib::hprint($content->data);
	}
	static function requestContentFromWeb() {
		$contentData = php_Web::getPostData();
		$contentType = php_Web::getClientHeader("content-type");
		$contentEncoding = php_Web::getClientHeader("content-encoding");
		return haxigniter_server_libraries_Server::requestContent($contentData, (($contentType === null) ? null : trim($contentType)), (($contentEncoding === null) ? null : trim($contentEncoding)));
	}
	static $charsetRegexp;
	static function requestContent($contentData, $contentType, $contentEncoding) {
		$output = _hx_anonymous(array("mimeType" => null, "charSet" => null, "encoding" => $contentEncoding, "data" => $contentData));
		if($contentType !== null) {
			$splitPos = _hx_index_of($contentType, ";", null);
			$output->mimeType = trim((($splitPos === -1) ? $contentType : _hx_substr($contentType, 0, $splitPos)));
			if(haxigniter_server_libraries_Server::$charsetRegexp->match($contentType)) {
				$output->charSet = haxigniter_server_libraries_Server::$charsetRegexp->matched(1);
			}
		}
		return $output;
	}
	static function dirname($path) {
		return haxe_io_Path::directory($path);
	}
	static function basename($path, $suffix) {
		$output = haxe_io_Path::withoutDirectory($path);
		if($suffix === null) {
			return $output;
		} else {
			return ((StringTools::endsWith($output, $suffix)) ? _hx_substr($output, 0, strlen($output) - strlen($suffix)) : $output);
		}
	}
	function __toString() { return 'haxigniter.server.libraries.Server'; }
}
haxigniter_server_libraries_Server::$charsetRegexp = new EReg("\\bcharset=([\\w-]+)", "");
function haxigniter_server_libraries_Server_0(&$»this, &$header, &$message, &$returnCode, &$title) {
	if($returnCode === 404) {
		return $»this->config->error404Page;
	} else {
		return $»this->config->errorPage;
	}
}
function haxigniter_server_libraries_Server_1(&$»this, &$ssl, &$sslActive) {
	if($»this->session !== null) {
		return $»this->session->flashVar;
	}
}
