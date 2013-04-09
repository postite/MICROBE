<?php

class microbe_TypeFactory {
	public function __construct() { 
	}
	public function create($type) {
		$»t = ($type);
		switch($»t->index) {
		case 2:
		{
			return Type::createInstance(_hx_qtype("microbe.factoryType.SpodableBehaviour"), new _hx_array(array()));
		}break;
		case 0:
		{
			return Type::createInstance(_hx_qtype("microbe.factoryType.FormElementBehaviour"), new _hx_array(array()));
		}break;
		case 1:
		{
			return Type::createInstance(_hx_qtype("microbe.factoryType.CollectionBehaviour"), new _hx_array(array()));
		}break;
		case 3:
		{
			return Type::createInstance(_hx_qtype("microbe.factoryType.DataElementBehaviour"), new _hx_array(array()));
		}break;
		}
	}
	function __toString() { return 'microbe.TypeFactory'; }
}
