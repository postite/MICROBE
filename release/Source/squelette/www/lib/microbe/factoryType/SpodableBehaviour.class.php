<?php

class microbe_factoryType_SpodableBehaviour implements microbe_factoryType_IBehaviour{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		microbe_tools_Mytrace::setRedirection();
	}}
	public function delete($voName, $id) {
	}
	public function record($source, $data) {
		haxe_Log::trace("spodable", _hx_anonymous(array("fileName" => "SpodableBehaviour.hx", "lineNumber" => 52, "className" => "microbe.factoryType.SpodableBehaviour", "methodName" => "record")));
		$voInstance = null;
		$castedsource = $source;
		if($data->id === null) {
			$voInstance = Type::createInstance(Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $castedsource->voName), new _hx_array(array()));
		} else {
			$voInstance = Reflect::callMethod($data, Reflect::field($data, "get_" . $source->field), new _hx_array(array($voInstance)));
		}
		$parser = new microbe_MicroCreator();
		$parser->source = $castedsource;
		$parser->data = $voInstance;
		$child = $parser->record();
		if(_hx_field($child, "id") === null) {
			$child->insert();
		} else {
			$child->update();
		}
		Reflect::callMethod($data, Reflect::field($data, "set_" . $source->field), new _hx_array(array($voInstance)));
		return $data;
	}
	public function create($voName, $element, $field, $formulaire = null) {
		haxe_Log::trace("im'a spod", _hx_anonymous(array("fileName" => "SpodableBehaviour.hx", "lineNumber" => 36, "className" => "microbe.factoryType.SpodableBehaviour", "methodName" => "create")));
		$liste = new microbe_form_MicroFieldList();
		$fieldClass = Type::resolveClass($element->classe);
		$instanceClass = Type::createInstance($fieldClass, new _hx_array(array()));
		$sousVoName = Lambda::hlist(_hx_explode(".", $element->classe))->last();
		$liste->field = $field;
		$liste->type = microbe_form_InstanceType::$spodable;
		$liste->voName = $sousVoName;
		$creator = new microbe_MicroCreator();
		$creator->data = Reflect::callMethod($this->data, "get_" . $field, new _hx_array(array()));
		$creator->generate($sousVoName, $instanceClass->getFormule(), $liste, $formulaire);
		return $liste;
	}
	public function parse($source) {
		$castedsource = $source;
		if(null == $castedsource) throw new HException('null iterable');
		$»it = $castedsource->iterator();
		while($»it->hasNext()) {
			$a = $»it->next();
			$parser = new microbe_MicroParser($a);
			$parser->parse();
			unset($parser);
		}
		return "i'm a spod" . $source->voName;
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
	function __toString() { return 'microbe.factoryType.SpodableBehaviour'; }
}
