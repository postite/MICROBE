<?php

class php_db__PDO_BaseResultSet implements sys_db_ResultSet{
	public function __construct($pdo, $typeStrategy) {
		if(!php_Boot::$skip_constructor) {
		$this->pdo = $pdo;
		$this->typeStrategy = $typeStrategy;
		$this->_fields = $pdo->columnCount();
		$this->_columnNames = new _hx_array(array());
		$this->_columnTypes = new _hx_array(array());
		$this->feedColumns();
	}}
	public $pdo;
	public $typeStrategy;
	public $_fields;
	public $_columnNames;
	public $_columnTypes;
	public $length;
	public $nfields;
	public function feedColumns() {
		$_g1 = 0; $_g = $this->_fields;
		while($_g1 < $_g) {
			$i = $_g1++;
			$data = $this->pdo->getColumnMeta($i);
			$this->_columnNames->push($data["name"]);
			$this->_columnTypes->push($this->typeStrategy->map($data));
			unset($i,$data);
		}
	}
	public function getFloatResult($index) {
		return floatval($this->getResult($index));
	}
	public function getIntResult($index) {
		return intval($this->getResult($index));
	}
	public function getResult($index) {
		php_db__PDO_BaseResultSet_0($this, $index);
	}
	public function hasNext() {
		php_db__PDO_BaseResultSet_1($this);
	}
	public function getLength() {
		php_db__PDO_BaseResultSet_2($this);
	}
	public function nextRow() {
		php_db__PDO_BaseResultSet_3($this);
	}
	public function next() {
		$row = $this->nextRow();
		$o = _hx_anonymous(array());
		{
			$_g1 = 0; $_g = $this->_fields;
			while($_g1 < $_g) {
				$i = $_g1++;
				$o->{$this->_columnNames[$i]} = php_db__PDO_TypeStrategy::convert($row[$i], $this->_columnTypes[$i]);
				unset($i);
			}
		}
		return $o;
	}
	public function getNFields() {
		return $this->_fields;
	}
	public function results() {
		$list = new HList();
		while($this->hasNext()) {
			$list->add($this->next());
		}
		return $list;
	}
	public function getFieldsNames() {
		php_db__PDO_BaseResultSet_4($this);
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
	function __toString() { return 'php.db._PDO.BaseResultSet'; }
}
function php_db__PDO_BaseResultSet_0(&$»this, &$index) {
	throw new HException("must override");
}
function php_db__PDO_BaseResultSet_1(&$»this) {
	throw new HException("must override");
}
function php_db__PDO_BaseResultSet_2(&$»this) {
	throw new HException("must override");
}
function php_db__PDO_BaseResultSet_3(&$»this) {
	throw new HException("must override");
}
function php_db__PDO_BaseResultSet_4(&$»this) {
	throw new HException("Not implemented");
}
