<?php

class php_db__PDO_TypeStrategy {
	public function __construct() { 
	}
	public function map($data) {
		php_db__PDO_TypeStrategy_0($this, $data);
	}
	static function convert($v, $type) {
		if($v === null) {
			return $v;
		}
		switch($type) {
		case "bool":{
			return (bool)($v);
		}break;
		case "int":{
			return intval($v);
		}break;
		case "float":{
			return floatval($v);
		}break;
		case "date":{
			return Date::fromString($v);
		}break;
		default:{
			return $v;
		}break;
		}
	}
	function __toString() { return 'php.db._PDO.TypeStrategy'; }
}
function php_db__PDO_TypeStrategy_0(&$»this, &$data) {
	throw new HException("must override");
}
