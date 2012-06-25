<?php

class vo_UserVo extends sys_db_Object implements microbe_vo_Spodable{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public $poz;
	public $id;
	public $mdp;
	public $nom;
	public function getFormule() {
		$formule = null;
		$formule = new Hash();
		$formule->set("nom", _hx_anonymous(array("classe" => "microbe.form.elements.Input", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->nom)));
		$formule->set("mdp", _hx_anonymous(array("classe" => "microbe.form.elements.Input", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->mdp)));
		return $formule;
	}
	public function getFields() {
		$liste = new HList();
		$liste->add("nom");
		$liste->add("mdp");
		return $liste;
	}
	public function getHash() {
		$h = new Hash();
		$h->set("nom", $this->nom);
		$h->set("mdp", $this->mdp);
		return $h;
	}
	public function getDefaultField() {
		return $this->nom;
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
	static function __meta__() { $»args = func_get_args(); return call_user_func_array(self::$__meta__, $»args); }
	static $__meta__;
	static $manager;
	function __toString() { return 'vo.UserVo'; }
}
vo_UserVo::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey4:usery7:indexesahy9:relationsahy7:hfieldsby2:idoR0R5y6:isNullfy1:tjy15:sys.db.SpodType:0:0gy3:mdpoR0R9R6fR7jR8:9:1i255gy3:nomoR0R10R6fR7jR8:9:1i255ghy3:keyaR5hy6:fieldsar4r6r8hg"))))));
vo_UserVo::$manager = new sys_db_Manager(_hx_qtype("vo.UserVo"));
