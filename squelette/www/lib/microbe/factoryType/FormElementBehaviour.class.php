<?php

class microbe_factoryType_FormElementBehaviour implements microbe_factoryType_IBehaviour{
	public function __construct() {
		;
	}
	public $form;
	public $data;
	public function parse($source) {
		$source->value = $source->value . "___modif";
		return "im a formElement" . $source->voName;
	}
	public function create($voName, $element, $field, $formulaire) {
		haxe_Log::trace($voName . "it s a formElement >" . $element, _hx_anonymous(array("fileName" => "FormElementBehaviour.hx", "lineNumber" => 23, "className" => "microbe.factoryType.FormElementBehaviour", "methodName" => "create")));
		$fieldClass = Type::resolveClass($element->classe);
		$micro = $this->creeMicroFieldListElement($field, $element, $voName, $formulaire);
		if($formulaire !== null) {
			$formel = $this->creeAjaxFormElement($formulaire, $micro, null);
			$formulaire->addElement($formel, null);
		}
		return $micro;
	}
	public function record($source, $data) {
		haxe_Log::trace("elementVAlue=" . $data, _hx_anonymous(array("fileName" => "FormElementBehaviour.hx", "lineNumber" => 35, "className" => "microbe.factoryType.FormElementBehaviour", "methodName" => "record")));
		$data->{$source->field} = $source->value;
		haxe_Log::trace("afterReflect" . Reflect::field($data, $source->field), _hx_anonymous(array("fileName" => "FormElementBehaviour.hx", "lineNumber" => 37, "className" => "microbe.factoryType.FormElementBehaviour", "methodName" => "record")));
		haxe_Log::trace("titre value=" . Reflect::field($data, "titre"), _hx_anonymous(array("fileName" => "FormElementBehaviour.hx", "lineNumber" => 38, "className" => "microbe.factoryType.FormElementBehaviour", "methodName" => "record")));
		return $data;
	}
	public function creeMicroFieldListElement($field, $element, $voName, $formulaire) {
		$brickElement = new microbe_form_Microfield();
		$brickElement->voName = $voName;
		$brickElement->field = $field;
		$brickElement->element = $element->classe;
		$brickElement->elementId = $voName . "_" . $field;
		$brickElement->type = $element->type;
		$brickElement->value = Reflect::field($this->data, $field);
		return $brickElement;
	}
	public function creeAjaxFormElement($formulaire, $microfield, $graine) {
		if($graine === null) {
			$graine = "";
		}
		$microbeFormElement = Type::createInstance(Type::resolveClass($microfield->element), new _hx_array(array($microfield->elementId, $microfield->field, null, null, null, null)));
		$microbeFormElement->cssClass = "generatorClass";
		return $microbeFormElement;
	}
	public function delete($voName, $id) {
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
	function __toString() { return 'microbe.factoryType.FormElementBehaviour'; }
}
