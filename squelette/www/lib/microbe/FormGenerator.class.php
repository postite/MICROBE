<?php

class microbe_FormGenerator {
	public function __construct() {
		;
		"microbe.form.elements";
	}
	public $spodForm;
	public $formulaire;
	public $classMap;
	public $compressedClassMap;
	public $arborescence;
	public $cloud;
	public function render() {
		return $this->formulaire . $this->cloud;
	}
	public function generateComplexClassMapForm($nomVo, $data) {
		$spodvo = null;
		$_classMap = new microbe_ClassMap();
		$stringVo = microbe_FormGenerator::$voPackage . $nomVo;
		if($data === null) {
			$spodvo = Type::createInstance(Type::resolveClass($stringVo), new _hx_array(array()));
		} else {
			$spodvo = $data;
			$_classMap->id = $spodvo->id;
		}
		$formule = $spodvo->getFormule();
		$_classMap->voClass = $nomVo;
		$_formulaire = new microbe_form_Form("form", null, microbe_form_FormMethod::$POST);
		$elementValue = null;
		$fields = new microbe_form_MicroFieldList();
		$fields = $this->populateBrickField($nomVo, $spodvo, $_formulaire, null, null, null, null);
		$fields->taggable = false;
		if(Std::is($spodvo, _hx_qtype("microbe.vo.Taggable"))) {
			$fields->taggable = true;
			$this->cloud = _hx_deref(new microbe_form_elements_TagView("pif", "paf", null, null))->render(null);
		}
		$_classMap->fields = $fields;
		$submit = new microbe_form_elements_Button("submit", "enregistrer", "enregistrer", microbe_form_elements_ButtonType::$BUTTON, null);
		$submit->cssClass = "submitor";
		$delete = new microbe_form_elements_DeleteButton($nomVo . "_" . $_formulaire->name . "_effacer", "effacer !");
		$_formulaire->setSubmitButton($submit);
		$_formulaire->setDeleteButton($delete);
		$_classMap->submit = $_formulaire->name . "_" . "submit";
		$this->formulaire = $_formulaire;
		$this->classMap = $_classMap;
	}
	public function recurMaptrace($iter, $indent) {
		if(null == $iter) throw new HException('null iterable');
		$»it = $iter->iterator();
		while($»it->hasNext()) {
			$chps = $»it->next();
			if(Std::is($chps, _hx_qtype("microbe.form.MicroFieldList"))) {
				$indent .= "-";
				$this->recurMaptrace($chps, $indent);
			} else {
			}
		}
	}
	public function populateData() {
	}
	public function creeMicroFieldListElement($field, $element, $voName, $form) {
		$brickElement = new microbe_form_Microfield();
		$brickElement->voName = $voName;
		$brickElement->field = $field;
		$brickElement->element = $element->classe;
		$brickElement->elementId = $form->name . "_" . $voName . "_" . $field;
		$brickElement->type = $element->type;
		return $brickElement;
	}
	public function creeAjaxFormElement($microfield, $graine) {
		if($graine === null) {
			$graine = "";
		}
		$microbeFormElement = Type::createInstance(Type::resolveClass($microfield->element), new _hx_array(array($microfield->voName . "_" . $microfield->field . $graine, $microfield->field, null, null, null, null)));
		$microbeFormElement->cssClass = "generatorClass";
		return $microbeFormElement;
	}
	public function populateBrickField($voName, $voInstance, $form, $voRef, $voInstanceRef, $superfield, $recur) {
		if($recur === null) {
			$recur = true;
		}
		$liste = new microbe_form_MicroFieldList();
		$liste->voName = $voName;
		$liste->type = microbe_form_InstanceType::$spodable;
		$liste->id = $voInstance->id;
		$formule = $voInstance->getFormule();
		$creator = new microbe_MicroCreator();
		$creator->data = $voInstance;
		$creator->generate($voName, $formule, $liste, $form);
		return $creator->result;
	}
	public function getCollectionField($formule) {
		if(null == $formule) throw new HException('null iterable');
		$»it = $formule->iterator();
		while($»it->hasNext()) {
			$f = $»it->next();
			if($f->type == microbe_form_InstanceType::$collection) {
				return $f->champs;
			}
		}
		return null;
	}
	public function getStringId($element) {
		$id = $element->form->name . "_" . $element->name;
		return $id;
	}
	public function compressedArborescence() {
		return haxe_Serializer::run($this->arborescence);
	}
	public function getCompressedClassMap() {
		return haxe_Serializer::run($this->classMap);
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
	static $voPackage;
	static $__properties__ = array("get_compressedClassMap" => "getCompressedClassMap");
	function __toString() { return 'microbe.FormGenerator'; }
}
