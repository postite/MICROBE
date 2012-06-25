<?php

class haxigniter_server_views_ViewEngine {
	public function __construct($config) {
		if(!php_Boot::$skip_constructor) {
		$this->templatePath = $config->viewPath;
		$this->compiledPath = $config->cachePath;
	}}
	public $templatePath;
	public $compiledPath;
	public $templateExtension;
	public function assign($name, $value) {
		throw new HException("Assign() must be implemented in an inherited class.");
	}
	public function clearAssign($name) {
		throw new HException("ClearAssign() must be implemented in an inherited class.");
		return null;
	}
	public function render($fileName) {
		throw new HException("Render() must be implemented in an inherited class.");
		return null;
	}
	public function display($fileName) {
		php_Lib::hprint($this->render($fileName));
	}
	public function displayDefault($pos) {
		$className = strtolower(_hx_substr($pos->className, _hx_last_index_of($pos->className, ".", null) + 1, null));
		$this->display($className . "/" . $pos->methodName . "." . $this->templateExtension);
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
	function __toString() { return 'haxigniter.server.views.ViewEngine'; }
}
