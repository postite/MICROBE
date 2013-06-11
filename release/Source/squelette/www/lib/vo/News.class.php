<?php

class vo_News extends sys_db_Object implements microbe_vo_Traductable, microbe_vo_Taggable, microbe_vo_Spodable{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->lang = "fr";
	}}
	public function getDefaultField() {
		return $this->titre;
	}
	public function getFormule() {
		$formule = null;
		$formule = new Hash();
		$formule->set("titre", _hx_anonymous(array("classe" => "microbe.form.elements.AjaxInput", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->titre)));
		$formule->set("date", _hx_anonymous(array("classe" => "microbe.form.elements.AjaxDate", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->date)));
		$formule->set("datelitterale", _hx_anonymous(array("classe" => "microbe.form.elements.AjaxInput", "type" => microbe_form_InstanceType::$formElement, "champs" => $this->datelitterale)));
		$formule->set("contenu", _hx_anonymous(array("type" => microbe_form_InstanceType::$formElement, "classe" => "microbe.form.elements.AjaxEditor", "champs" => $this->contenu)));
		$formule->set("image", _hx_anonymous(array("type" => microbe_form_InstanceType::$formElement, "classe" => "microbe.form.elements.ImageUploader", "champs" => $this->image)));
		$formule->set("en_ligne", _hx_anonymous(array("type" => microbe_form_InstanceType::$formElement, "classe" => "microbe.form.elements.CheckBox", "champs" => $this->en_ligne)));
		$formule->set("lang", _hx_anonymous(array("type" => microbe_form_InstanceType::$dataElement, "classe" => null, "champs" => $this->lang)));
		$formule->set("id_ref", _hx_anonymous(array("type" => microbe_form_InstanceType::$dataElement, "classe" => null, "champs" => $this->id_ref)));
		return $formule;
	}
	public function getTrad($lang) {
		try {
			return vo_News::$manager->unsafeObjects("SELECT * FROM actu WHERE (id_ref = " . sys_db_Manager::quoteAny($this->id) . (" AND lang = " . sys_db_Manager::quoteAny($lang)) . ")", null)->first()->id;
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			if(is_string($e = $_ex_)){
				return 0;
			} else throw $»e;;
		}
	}
	public function getTags() {
		return new HList();
	}
	public $id_ref;
	public $lang;
	public $en_ligne;
	public $datelitterale;
	public $image;
	public $contenu;
	public $date;
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
	function __toString() { return 'vo.News'; }
}
vo_News::$__meta__ = _hx_anonymous(array("obj" => _hx_anonymous(array("rtti" => new _hx_array(array("oy4:namey4:actuy7:indexesaoy4:keysay5:titrehy6:uniquetghy9:relationsahy7:hfieldsby7:contenuoR0R8y6:isNullfy1:tjy15:sys.db.SpodType:15:0gR4oR0R4R9fR10jR11:9:1i255gy13:datelitteraleoR0R12R9fR10jR11:9:1i255gy8:en_ligneoR0R13R9fR10jR11:9:1i255gy3:pozoR0R14R9fR10jR11:1:0gy4:dateoR0R15R9fR10jR11:10:0gy6:id_refoR0R16R9fR10r15gy5:imageoR0R17R9fR10jR11:9:1i255gy4:langoR0R18R9fR10jR11:9:1i11gy2:idoR0R19R9fR10jR11:0:0ghy3:keyaR19hy6:fieldsar14r23r8r16r6r19r10r12r21r18hg"))))));
vo_News::$manager = new sys_db_Manager(_hx_qtype("vo.News"));
