<?php

class vo_RelationTest extends sys_db_Object implements microbe_vo_Spodable{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function getDefaultField() {
		return $this->titre;
	}
	public function getFormule() {
		$formule = null;
		$formule = new Hash();
		$formule->set("titre", _hx_anonymous(array("classe" => "microbe.form.elements.AjaxInput", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->titre)));
		$formule->set("childListe", _hx_anonymous(array("classe" => "vo.ChildTest", "type" => microbe_form_InstanceType::$collection, "champs" => $this->childListe)));
		return $formule;
	}
	public $subchildListe;
	public $childListe;
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
	function __toString() { return 'vo.RelationTest'; }
}
vo_RelationTest::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey12:relationtesty7:indexesahy9:relationsahy7:hfieldsby2:idoR0R5y6:isNullfy1:tjy15:sys.db.SpodType:0:0gy3:pozoR0R9R6fR7jR8:1:0gy5:titreoR0R10R6fR7jR8:9:1i255ghy3:keyaR5hy6:fieldsar6r4r8hg"))))));
vo_RelationTest::$manager = new vo_RelationManager(_hx_qtype("vo.RelationTest"));
