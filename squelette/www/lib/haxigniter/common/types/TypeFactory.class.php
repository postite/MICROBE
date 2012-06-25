<?php

class haxigniter_common_types_TypeFactory {
	public function __construct(){}
	static $arrayDelimiter = "-";
	static function typecastArguments($classType, $classMethod, $arguments, $offset) {
		if($offset === null) {
			$offset = 0;
		}
		$output = new _hx_array(array());
		$c = 0;
		if(null == haxigniter_common_rtti_RttiUtil::getMethod($classMethod, $classType)) throw new HException('null iterable');
		$»it = haxigniter_common_rtti_RttiUtil::getMethod($classMethod, $classType)->iterator();
		while($»it->hasNext()) {
			$method = $»it->next();
			if($offset > 0) {
				--$offset;
				continue;
			}
			if($method->opt && ($arguments[$c] === "" || $arguments[$c] === null)) {
				++$c;
				$output->push(null);
			} else {
				$output->push(haxigniter_common_types_TypeFactory::createType($method->type, $arguments[$c++]));
			}
		}
		return $output;
	}
	static function createType($typeString, $value) {
		$output = null;
		$typeParam = haxigniter_common_types_TypeFactory::splitType($typeString);
		switch($typeParam[0]) {
		case "Int":{
			$output = Std::parseInt($value);
		}break;
		case "Float":{
			$output = Std::parseFloat($value);
		}break;
		case "String":case "Dynamic":{
			$output = $value;
		}break;
		case "Array":case "List":{
			$output = Type::createInstance(Type::resolveClass($typeParam[0]), new _hx_array(array()));
			$isArray = $typeParam[0] === "Array";
			{
				$_g = 0; $_g1 = _hx_explode(haxigniter_common_types_TypeFactory::$arrayDelimiter, $value);
				while($_g < $_g1->length) {
					$val = $_g1[$_g];
					++$_g;
					$newType = haxigniter_common_types_TypeFactory::createType($typeParam[1], $val);
					if($isArray) {
						$output->push($newType);
					} else {
						$output->add($newType);
					}
					unset($val,$newType);
				}
			}
		}break;
		case "Bool":{
			$output = (($value === "" || $value === "0" || $value === "false" || $value === "null") ? false : true);
		}break;
		default:{
			$classType = Type::resolveClass($typeString);
			if($classType === null) {
				throw new HException(new haxigniter_common_exceptions_Exception("[WebTypeFactory] Type not found: " . $typeString, null, _hx_anonymous(array("fileName" => "TypeFactory.hx", "lineNumber" => 120, "className" => "haxigniter.common.types.TypeFactory", "methodName" => "createType"))));
			}
			$output = Type::createInstance($classType, new _hx_array(array($value)));
		}break;
		}
		if($output === null) {
			throw new HException(new haxigniter_common_types_TypeException($typeString, $value, _hx_anonymous(array("fileName" => "TypeFactory.hx", "lineNumber" => 126, "className" => "haxigniter.common.types.TypeFactory", "methodName" => "createType"))));
		}
		return $output;
	}
	static function splitType($typeString) {
		$typeParam = _hx_index_of($typeString, "<", null);
		if($typeParam === -1) {
			return new _hx_array(array($typeString, null));
		}
		$mainType = _hx_substr($typeString, 0, $typeParam);
		$typeParameter = _hx_substr($typeString, _hx_index_of($typeString, "<", null) + 1, null);
		$typeParameter = _hx_substr($typeParameter, 0, strlen($typeParameter) - 1);
		return new _hx_array(array($mainType, $typeParameter));
	}
	function __toString() { return 'haxigniter.common.types.TypeFactory'; }
}
