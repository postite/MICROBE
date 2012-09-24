<?php

class vo_Edito extends sys_db_Object implements microbe_vo_Spodable{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function getDefaultField() {
		return $this->date->toString();
	}
	public function getFormule() {
		$formule = null;
		$formule = new Hash();
		$formule->set("contenu", _hx_anonymous(array("classe" => "microbe.form.elements.AjaxArea", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->contenu)));
		return $formule;
	}
	public $date;
	public $contenu;
	public $id;
	public $poz;
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
	function __toString() { return 'vo.Edito'; }
}
vo_Edito::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey5:editoy7:indexesahy9:relationsahy7:hfieldsby2:idoR0R5y6:isNullfy1:tjy15:sys.db.SpodType:0:0gy7:contenuoR0R9R6fR7jR8:9:1i255gy3:pozoR0R10R6fR7jR8:1:0gy4:dateoR0R11R6fR7jR8:10:0ghy3:keyaR5hy6:fieldsar8r4r6r10hg"))))));
vo_Edito::$manager = new sys_db_Manager(_hx_qtype("vo.Edito"));
