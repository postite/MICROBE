<?php

class haxigniter_server_views_Templo extends haxigniter_server_views_ViewEngine {
	public function __construct($config, $macros, $optimized) {
		if(!php_Boot::$skip_constructor) {
		if($optimized === null) {
			$optimized = false;
		}
		parent::__construct($config);
		$this->templateExtension = "mtt";
		$this->macros = $macros;
		$this->optimized = $optimized;
		$this->templateVars = new haxigniter_server_views_TemploVars();
	}}
	public $templateVars;
	public $macros;
	public $optimized;
	public function assign($name, $value) {
		$this->templateVars->{$name} = $value;
	}
	public function clearAssign($name) {
		return Reflect::deleteField($this->templateVars, $name);
	}
	public function render($fileName) {
		templo_Loader::$BASE_DIR = $this->templatePath;
		templo_Loader::$TMP_DIR = $this->compiledPath;
		templo_Loader::$MACROS = $this->macros;
		templo_Loader::$OPTIMIZED = $this->optimized;
		$t = new templo_Loader($fileName);
		return $t->execute($this->templateVars);
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
	function __toString() { return 'haxigniter.server.views.Templo'; }
}
