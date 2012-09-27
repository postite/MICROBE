<?php

class microbe_factoryType_DataElementBehaviour implements microbe_factoryType_IBehaviour{
	public function __construct(){}
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
	public function delete($voName, $id) {
	}
	public function record($source, $data) {
		$data->{$source->field} = $source->value;
		return $data;
	}
	public function create($voName, $element, $field, $formulaire = null) {
		$micro = $this->creeMicroFieldListElement($field, $element, $voName, $formulaire);
		return $micro;
	}
	public function parse($source) {
		$source->value = $source->value . "___modif";
		return "dataOnly";
	}
	public $data;
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
	function __toString() { return 'microbe.factoryType.DataElementBehaviour'; }
}
