<?php

class haxigniter_server_views_ErazorView extends haxigniter_server_views_ViewEngine {
	public function __construct($config, $macros = null, $optimized = null) {
		if(!php_Boot::$skip_constructor) {
		if($optimized === null) {
			$optimized = false;
		}
		$_g = $this;
		parent::__construct($config);
		$this->templateExtension = "html";
		$this->wrappers = new HList();
		$this->templateVars = new haxigniter_server_views_ErazorVars();
		$this->assign("include", array(new _hx_lambda(array(&$_g, &$config, &$macros, &$optimized), "haxigniter_server_views_ErazorView_0"), 'execute'));
		$this->assign("wrap", array(new _hx_lambda(array(&$_g, &$config, &$macros, &$optimized), "haxigniter_server_views_ErazorView_1"), 'execute'));
	}}
	public function render($fileName) {
		$fileContent = sys_io_File::getContent($this->templatePath . $fileName);
		$t = new erazor_Template($fileContent);
		$this->setTempo($t->execute($this->templateVars));
		return $this->renderString($this->getTempo());
	}
	public function inRender($inTemplate, $suppVar = null) {
		if($suppVar !== null) {
			if(null == $suppVar) throw new HException('null iterable');
			$»it = $suppVar->keys();
			while($»it->hasNext()) {
				$supp = $»it->next();
				$this->assign($supp, $suppVar->get($supp));
			}
		}
		$t = null;
		$fileContent = sys_io_File::getContent($this->templatePath . $inTemplate);
		$t = new erazor_Template($fileContent);
		return $t->execute($this->templateVars);
	}
	public function renderString($t) {
		$t1 = new erazor_Template($t);
		return $t1->execute($this->templateVars);
	}
	public function wrap($outTemplate) {
		$t = null;
		$fileContent = sys_io_File::getContent($this->templatePath . $outTemplate);
		$t = new erazor_Template($fileContent);
		$this->wrappers->add($t);
	}
	public function clearAssign($name) {
		return Reflect::deleteField($this->templateVars, $name);
	}
	public function assign($name, $value) {
		$this->templateVars->{$name} = $value;
	}
	public function getTempo() {
		return $this->_tempo;
	}
	public function setTempo($val) {
		$_g = $this;
		if($this->wrappers->length > 0) {
			$this->assign("wrap", null);
			$this->assign("layoutContent", $this->renderString($val));
			$this->tempo = $this->wrappers->pop()->execute($this->templateVars);
			$this->assign("wrap", array(new _hx_lambda(array(&$_g, &$val), "haxigniter_server_views_ErazorView_2"), 'execute'));
		}
		$this->_tempo = $val;
		return $this->_tempo;
	}
	public $_tempo;
	public $tempo;
	public $wrappers;
	public $optimized;
	public $macros;
	public $templateVars;
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
	static $__properties__ = array("set_tempo" => "setTempo","get_tempo" => "getTempo");
	function __toString() { return 'haxigniter.server.views.ErazorView'; }
}
function haxigniter_server_views_ErazorView_0(&$_g, &$config, &$macros, &$optimized, $file, $suppVar) {
	{
		return $_g->inRender($file, $suppVar);
	}
}
function haxigniter_server_views_ErazorView_1(&$_g, &$config, &$macros, &$optimized, $file) {
	{
		$_g->wrap($file);
	}
}
function haxigniter_server_views_ErazorView_2(&$_g, &$val, $file) {
	{
		$_g->wrap($file);
	}
}
