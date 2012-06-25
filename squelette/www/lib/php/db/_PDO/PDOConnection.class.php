<?php

class php_db__PDO_PDOConnection implements sys_db_Connection{
	public function __construct($dsn, $user, $password, $options) {
		if(!php_Boot::$skip_constructor) {
		if(null === $options) {
			$this->pdo = new PDO($dsn, $user, $password);
		} else {
			$arr = array();
			{
				$_g = 0; $_g1 = Reflect::fields($options);
				while($_g < $_g1->length) {
					$key = $_g1[$_g];
					++$_g;
					$arr[$key] = Reflect::field($options, $key);
					unset($key);
				}
			}
			$this->pdo = new PDO($dsn, $user, $password, $arr);
		}
		$this->dbname = _hx_explode(":", $dsn)->shift();
	}}
	public $pdo;
	public $dbname;
	public function close() {
		$this->pdo = null;
		unset($this->pdo);
	}
	public function request($s) {
		$result = $this->pdo->query($s, PDO::PARAM_STR);
		if(($result === false)) {
			$info = new _hx_array($this->pdo->errorInfo());
			throw new HException("Error while executing " . $s . " (" . $info[2] . ")");
		}
		$db = strtolower($this->dbname);
		switch($db) {
		case "sqlite":{
			return new php_db__PDO_AllResultSet($result, new php_db__PDO_DBNativeStrategy($db));
		}break;
		default:{
			return new php_db__PDO_PDOResultSet($result, new php_db__PDO_PHPNativeStrategy());
		}break;
		}
	}
	public function escape($s) {
		$output = $this->pdo->quote($s, null);
		return ((strlen($output) > 2) ? _hx_substr($output, 1, strlen($output) - 2) : $output);
	}
	public function quote($s) {
		if(_hx_index_of($s, "\x00", null) >= 0) {
			return "x'" . $this->base16_encode($s) . "'";
		}
		return $this->pdo->quote($s, null);
	}
	public function addValue($s, $v) {
		if(is_int($v) || is_null($v)) {
			$x = $v;
			if(is_null($x)) {
				$x = "null";
			} else {
				if(is_bool($x)) {
					$x = (($x) ? "true" : "false");
				}
			}
			$s->b .= $x;
		} else {
			if(is_bool($v)) {
				$x = (($v) ? 1 : 0);
				if(is_null($x)) {
					$x = "null";
				} else {
					if(is_bool($x)) {
						$x = (($x) ? "true" : "false");
					}
				}
				$s->b .= $x;
			} else {
				$x = $this->quote(Std::string($v));
				if(is_null($x)) {
					$x = "null";
				} else {
					if(is_bool($x)) {
						$x = (($x) ? "true" : "false");
					}
				}
				$s->b .= $x;
			}
		}
	}
	public function lastInsertId() {
		return Std::parseInt($this->pdo->lastInsertId(null));
	}
	public function dbName() {
		return $this->dbname;
	}
	public function startTransaction() {
		$this->pdo->beginTransaction();
	}
	public function commit() {
		$this->pdo->commit();
	}
	public function rollback() {
		$this->pdo->rollBack();
	}
	public function base16_encode($str) {
		$str = unpack("H" . 2 * strlen($str), $str);
		$str = chunk_split($str[1]);
		return $str;
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
	function __toString() { return 'php.db._PDO.PDOConnection'; }
}
