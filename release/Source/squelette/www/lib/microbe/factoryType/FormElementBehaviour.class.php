<?php

class microbe_factoryType_FormElementBehaviour implements microbe_factoryType_IBehaviour{
	public function __construct() {
		;
	}
	public function delete($voName, $id) {
	}
	public function creeAjaxFormElement($formulaire, $microfield, $graine = null) {
		if($graine === null) {
			$graine = "";
		}
		$microbeFormElement = Type::createInstance(Type::resolveClass($microfield->element), new _hx_array(array($microfield->elementId, $microfield->field, $microfield->value, null, null, null)));
		$microbeFormElement->cssClass = "generatorClass";
		return $microbeFormElement;
	}
	public function creeMicroFieldListElement($field, $element, $voName, $formulaire = null) {
		$brickElement = new microbe_form_Microfield();
		$brickElement->voName = $voName;
		$brickElement->field = $field;
		$brickElement->element = $element->classe;
		$brickElement->elementId = $voName . "_" . $field;
		$brickElement->type = $element->type;
		$val = Reflect::field($this->data, $field);
		if(Std::is($val, _hx_qtype("Date"))) {
			$val = _hx_string_call($val, "toString", array());
		}
		$brickElement->value = $val;
		return $brickElement;
	}
	public function record($source, $data) {
		haxe_Log::trace("FormElementBehaviour" . $source->field . "--" . $source->value, _hx_anonymous(array("fileName" => "FormElementBehaviour.hx", "lineNumber" => 36, "className" => "microbe.factoryType.FormElementBehaviour", "methodName" => "record")));
		$data->{$source->field} = $source->value;
		return $data;
	}
	public function create($voName, $element, $field, $formulaire = null) {
		haxe_Log::trace($voName . "it s a formElement >" . Std::string($element), _hx_anonymous(array("fileName" => "FormElementBehaviour.hx", "lineNumber" => 23, "className" => "microbe.factoryType.FormElementBehaviour", "methodName" => "create")));
		$fieldClass = Type::resolveClass($element->classe);
		$micro = $this->creeMicroFieldListElement($field, $element, $voName, $formulaire);
		if($formulaire !== null) {
			$formel = $this->creeAjaxFormElement($formulaire, $micro, null);
			$formulaire->addElement($formel, null);
		}
		return $micro;
	}
	public function parse($source) {
		$source->value = $source->value . "___modif";
		return "im a dataElement" . $source->voName;
	}
	public $data;
	public $form;
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
	function __toString() { return 'microbe.factoryType.FormElementBehaviour'; }
}
