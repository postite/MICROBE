<?php

class php_db__PDO_DBNativeStrategy extends php_db__PDO_PHPNativeStrategy {
	public function __construct($dbname) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->dbname = strtolower($dbname);
		$this->key = $dbname . ":decl_type";
	}}
	public $dbname;
	public $key;
	public function map($data) {
		if(!isset($data[$this->key])) {
			return parent::map($data);
		}
		$type = $data[$this->key];
		$type = strtolower($type);
		switch($type) {
		case "real":{
			return "float";
		}break;
		case "integer":{
			return "int";
		}break;
		default:{
			return "string";
		}break;
		}
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
	static $SUFFIX = ":decl_type";
	function __toString() { return 'php.db._PDO.DBNativeStrategy'; }
}
