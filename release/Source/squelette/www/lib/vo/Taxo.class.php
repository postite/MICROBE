<?php

class vo_Taxo extends sys_db_Object {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public $spodtype;
	public $tag;
	public $taxo_id;
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
	static function __meta__() { $»args = func_get_args(); return call_user_func_array(self::$__meta__, $»args); }
	static $__meta__;
	static $manager;
	function __toString() { return 'vo.Taxo'; }
}
vo_Taxo::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey4:taxoy7:indexesahy9:relationsahy7:hfieldsby7:taxo_idoR0R5y6:isNullfy1:tjy15:sys.db.SpodType:0:0gy8:spodtypeoR0R9R6fR7jR8:9:1i250gy3:tagoR0R10R6fR7jR8:9:1i250ghy3:keyaR5hy6:fieldsar4r8r6hg"))))));
vo_Taxo::$manager = new vo_TaxoManager();
