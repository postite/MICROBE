<?php

class haxigniter_server_views_ErazorView extends haxigniter_server_views_ViewEngine {
	public function __construct($config, $macros, $optimized) {
		if(!php_Boot::$skip_constructor) {
		if($optimized === null) {
			$optimized = false;
		}
		$me = $this;
		parent::__construct($config);
		$this->templateExtension = "html";
		$this->wrappers = new HList();
		$this->templateVars = new haxigniter_server_views_ErazorVars();
		$this->assign("include", array(new _hx_lambda(array(&$config, &$macros, &$me, &$optimized), "haxigniter_server_views_ErazorView_0"), 'execute'));
		$this->assign("wrap", array(new _hx_lambda(array(&$config, &$macros, &$me, &$optimized), "haxigniter_server_views_ErazorView_1"), 'execute'));
	}}
	public $templateVars;
	public $macros;
	public $optimized;
	public $wrappers;
	public $tempo;
	public $_tempo;
	public function setTempo($val) {
		$me = $this;
		if($this->wrappers->length > 0) {
			$this->assign("wrap", null);
			$this->assign("layoutContent", $this->renderString($val));
			$this->tempo = $this->wrappers->pop()->execute($this->templateVars);
			$this->assign("wrap", array(new _hx_lambda(array(&$me, &$val), "haxigniter_server_views_ErazorView_2"), 'execute'));
		}
		$this->_tempo = $val;
		return $this->_tempo;
	}
	public function getTempo() {
		return $this->_tempo;
	}
	public function assign($name, $value) {
		$this->templateVars->{$name} = $value;
	}
	public function clearAssign($name) {
		return Reflect::deleteField($this->templateVars, $name);
	}
	public function wrap($outTemplate) {
		$t = null;
		$fileContent = sys_io_File::getContent($this->templatePath . $outTemplate);
		$t = new erazor_Template($fileContent);
		$this->wrappers->add($t);
	}
	public function renderString($t) {
		$t1 = new erazor_Template($t);
		return $t1->execute($this->templateVars);
	}
	public function inRender($inTemplate, $suppVar) {
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
	public function render($fileName) {
		$fileContent = sys_io_File::getContent($this->templatePath . $fileName);
		$t = new erazor_Template($fileContent);
		$this->setTempo($t->execute($this->templateVars));
		return $this->renderString($this->getTempo());
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
	static $__properties__ = array("set_tempo" => "setTempo","get_tempo" => "getTempo");
	function __toString() { return 'haxigniter.server.views.ErazorView'; }
}
function haxigniter_server_views_ErazorView_0(&$config, &$macros, &$me, &$optimized, $file, $suppVar) {
	{
		return $me->inRender($file, $suppVar);
	}
}
function haxigniter_server_views_ErazorView_1(&$config, &$macros, &$me, &$optimized, $file) {
	{
		$me->wrap($file);
	}
}
function haxigniter_server_views_ErazorView_2(&$me, &$val, $file) {
	{
		$me->wrap($file);
	}
}
