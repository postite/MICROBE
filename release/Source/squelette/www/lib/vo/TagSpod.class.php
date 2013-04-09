<?php

class vo_TagSpod extends sys_db_Object {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public $spod_id;
	public $tag_id;
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
	function __toString() { return 'vo.TagSpod'; }
}
vo_TagSpod::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey7:tagSpody7:indexesahy9:relationsahy7:hfieldsby6:tag_idoR0R5y6:isNullfy1:tjy15:sys.db.SpodType:0:0gy7:spod_idoR0R9R6fR7jR8:1:0ghy3:keyaR5R9hy6:fieldsar4r6hg"))))));
vo_TagSpod::$manager = new sys_db_Manager(_hx_qtype("vo.TagSpod"));
