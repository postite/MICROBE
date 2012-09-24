<?php

class vo_SubChild extends sys_db_Object implements microbe_vo_Spodable{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function set_rel($_v) {
		return vo_RelationTest::$manager->h__set($this, "rel", "rid", $_v);
	}
	public function get_rel() {
		return vo_RelationTest::$manager->h__get($this, "rel", "rid", false);
	}
	public function getDefaultField() {
		return $this->titre;
	}
	public function getFormule() {
		$formule = null;
		$formule = new Hash();
		$formule->set("titre", _hx_anonymous(array("classe" => "microbe.form.elements.AjaxInput", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->titre)));
		$formule->set("image", _hx_anonymous(array("classe" => "microbe.form.elements.ImageUploader", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->image)));
		return $formule;
	}
	public $rel;
	public $modele;
	public $image;
	public $titre;
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
	static $__properties__ = array("set_rel" => "set_rel","get_rel" => "get_rel");
	function __toString() { return 'vo.SubChild'; }
}
vo_SubChild::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey8:subchildy7:indexesahy9:relationsaoy4:lockfy4:propy3:rely4:typey15:vo.RelationTesty7:cascadefy6:isNullfy3:keyy3:ridghy7:hfieldsby5:imageoR0R14R10fy1:tjy15:sys.db.SpodType:9:1i255gy2:idoR0R17R10fR15jR16:0:0gR12oR0R12R10fR15jR16:1:0gy3:pozoR0R18R10fR15r10gy5:titreoR0R19R10fR15jR16:9:1i255gy6:modeleoR0R20R10fR15jR16:9:1i255ghR11aR17hy6:fieldsar11r7r12r5r14r9hg"))))));
vo_SubChild::$manager = new sys_db_Manager(_hx_qtype("vo.SubChild"));
