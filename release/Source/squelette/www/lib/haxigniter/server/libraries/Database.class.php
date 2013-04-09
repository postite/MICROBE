<?php

class haxigniter_server_libraries_Database {
	public function __construct(){}
	public function sendCollationQuery() {
		$stringTest = $this->charSet . (haxigniter_server_libraries_Database_0($this));
		if(!_hx_deref(new EReg("^\\w+\$", ""))->match($stringTest)) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Charset/collation settings must be alphanumeric.", null, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 354, "className" => "haxigniter.server.libraries.Database", "methodName" => "sendCollationQuery"))));
		}
		if($this->collation !== null) {
			$this->getConnection()->request("SET NAMES '" . $this->charSet . "' COLLATE '" . $this->collation . "'");
		} else {
			$this->getConnection()->request("SET CHARACTER SET " . $this->charSet);
		}
	}
	public function request($query, $pos = null) {
		if($this->traceQueries !== null && $this->debug !== null) {
			$this->debug->log("[Executing SQL] " . $query, $this->traceQueries);
		}
		try {
			$this->lastQuery = $query;
			return $this->getConnection()->request($query);
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			$e = $_ex_;
			{
				if($this->debug !== null) {
					$this->debug->log("[SQL Error] " . $query, haxigniter_server_libraries_DebugLevel::$error);
				}
				throw new HException($e);
			}
		}
	}
	public function queryParams($query, $params) {
		$parameter = haxigniter_server_libraries_Database_1($this, $params, $query);
		if(null == $params) throw new HException('null iterable');
		$»it = $params->iterator();
		while($»it->hasNext()) {
			$param = $»it->next();
			$pos = _hx_index_of($query, $parameter, null);
			if($pos === -1) {
				throw new HException(new haxigniter_server_libraries_DatabaseException("Not enough parameters in query.", $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 301, "className" => "haxigniter.server.libraries.Database", "methodName" => "queryParams"))));
			}
			if($param !== null) {
				$param = $this->getConnection()->quote(Std::string($param));
			} else {
				$param = "NULL";
			}
			$query = _hx_substr($query, 0, $pos) . $param . _hx_substr($query, $pos + 1, null);
			unset($pos);
		}
		return $query;
	}
	public function testAlphaNumeric($value) {
		if($value === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($value)) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $value, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
		}
	}
	public function lastInsertId() {
		return $this->getConnection()->lastInsertId();
	}
	public function delete($table, $where = null, $limit = null, $pos = null) {
		if($table === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($table)) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $table, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
		}
		$whereStr = "";
		if($where !== null) {
			$whereHash = $this->makeHash($where, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 254, "className" => "haxigniter.server.libraries.Database", "methodName" => "delete")));
			if(null == $whereHash) throw new HException('null iterable');
			$»it = $whereHash->keys();
			while($»it->hasNext()) {
				$key = $»it->next();
				if($key === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($key)) {
					throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $key, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
				}
				$value = $whereHash->get($key);
				$whereStr .= " AND " . $key . "=" . ((($value === null) ? "NULL" : $this->getConnection()->quote(Std::string($value))));
				unset($value);
			}
		}
		$query = "DELETE FROM " . $table;
		if($where !== null) {
			$query .= " WHERE " . _hx_substr($whereStr, 5, null);
		}
		if($limit !== null) {
			$query .= " LIMIT " . _hx_string_rec($limit, "");
		}
		$result = $this->request($query, $pos);
		return $result->getLength();
	}
	public function update($table, $data, $where = null, $limit = null, $pos = null) {
		if($table === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($table)) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $table, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
		}
		$hash = $this->makeHash($data, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 208, "className" => "haxigniter.server.libraries.Database", "methodName" => "update")));
		$set = "";
		$whereStr = "";
		if(null == $hash) throw new HException('null iterable');
		$»it = $hash->keys();
		while($»it->hasNext()) {
			$key = $»it->next();
			if($key === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($key)) {
				throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $key, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
			}
			$value = $hash->get($key);
			$set .= ", " . $key . "=" . ((($value === null) ? "NULL" : $this->getConnection()->quote(Std::string($value))));
			unset($value);
		}
		if($where !== null) {
			$whereHash = $this->makeHash($where, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 222, "className" => "haxigniter.server.libraries.Database", "methodName" => "update")));
			if(null == $whereHash) throw new HException('null iterable');
			$»it = $whereHash->keys();
			while($»it->hasNext()) {
				$key = $»it->next();
				if($key === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($key)) {
					throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $key, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
				}
				$value = $whereHash->get($key);
				$whereStr .= " AND " . $key . "=" . ((($value === null) ? "NULL" : $this->getConnection()->quote(Std::string($value))));
				unset($value);
			}
		}
		$query = "UPDATE " . $table . " SET " . _hx_substr($set, 2, null);
		if($where !== null) {
			$query .= " WHERE " . _hx_substr($whereStr, 5, null);
		}
		if($limit !== null) {
			$query .= " LIMIT " . _hx_string_rec($limit, "");
		}
		$result = $this->request($query, $pos);
		return $result->getLength();
	}
	public function replace($table, $data) {
		return $this->insert($table, $data, true, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 201, "className" => "haxigniter.server.libraries.Database", "methodName" => "replace")));
	}
	public function insert($table, $data, $replace = null, $pos = null) {
		if($replace === null) {
			$replace = false;
		}
		if($table === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($table)) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $table, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
		}
		$hash = $this->makeHash($data, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 180, "className" => "haxigniter.server.libraries.Database", "methodName" => "insert")));
		$keys = "";
		$values = "";
		if(null == $hash) throw new HException('null iterable');
		$»it = $hash->keys();
		while($»it->hasNext()) {
			$key = $»it->next();
			if($key === null || !haxigniter_server_libraries_Database::$alphaRegexp->match($key)) {
				throw new HException(new haxigniter_server_libraries_DatabaseException("Invalid parameter: " . $key, $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 288, "className" => "haxigniter.server.libraries.Database", "methodName" => "testAlphaNumeric"))));
			}
			$keys .= ", " . $key;
			$value = $hash->get($key);
			$values .= ", " . ((($value === null) ? "NULL" : $this->getConnection()->quote(Std::string($value))));
			unset($value);
		}
		$query = ((($replace) ? "REPLACE" : "INSERT")) . " INTO " . $table . " (" . _hx_substr($keys, 2, null) . ") VALUES (" . _hx_substr($values, 2, null) . ")";
		$result = $this->request($query, $pos);
		return $result->getLength();
	}
	public function makeHash($data, $pos = null) {
		if(Std::is($data, _hx_qtype("Hash"))) {
			return $data;
		}
		$output = new Hash();
		{
			$_g = 0; $_g1 = Reflect::fields($data);
			while($_g < $_g1->length) {
				$field = $_g1[$_g];
				++$_g;
				$output->set($field, Reflect::field($data, $field));
				unset($field);
			}
		}
		return $output;
	}
	public function queryString($query, $params = null, $pos = null) {
		$result = $this->query($query, $params, $pos);
		return (($result->hasNext()) ? $result->getResult(0) : null);
	}
	public function queryFloat($query, $params = null, $pos = null) {
		$result = $this->query($query, $params, $pos);
		return (($result->hasNext()) ? $result->getFloatResult(0) : null);
	}
	public function queryInt($query, $params = null, $pos = null) {
		$result = $this->query($query, $params, $pos);
		return (($result->hasNext()) ? $result->getIntResult(0) : null);
	}
	public function queryRow($query, $params = null, $pos = null) {
		$result = $this->query($query, $params, $pos);
		return (($result->hasNext()) ? $result->next() : null);
	}
	public function query($query, $params = null, $pos = null) {
		if($params !== null) {
			$query = $this->queryParams($query, $params);
		}
		return $this->request($query, $pos);
	}
	public function close() {
		if($this->myConnection !== null) {
			$this->myConnection->close();
			$this->myConnection = null;
		}
	}
	public function open() {
		if($this->myConnection !== null) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Connection is already open.", $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 112, "className" => "haxigniter.server.libraries.Database", "methodName" => "open"))));
		}
		$this->getConnection();
	}
	public $lastQuery;
	public $parameterString;
	public $traceQueries;
	public function setConnection($value) {
		if($value === null) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Cannot set database connection to null.", $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 85, "className" => "haxigniter.server.libraries.Database", "methodName" => "setConnection"))));
		}
		if($this->myConnection !== null) {
			throw new HException(new haxigniter_server_libraries_DatabaseException("Cannot change database connection after setting it.", $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 88, "className" => "haxigniter.server.libraries.Database", "methodName" => "setConnection"))));
		}
		$this->myConnection = $value;
		return $this->myConnection;
	}
	public function getConnection() {
		if($this->myConnection === null) {
			$»t = ($this->driver);
			switch($»t->index) {
			case 0:
			{
				$this->myConnection = sys_db_Mysql::connect($this);
				if($this->charSet !== null) {
					$stringTest = $this->charSet . (haxigniter_server_libraries_Database_2($this));
					if(!_hx_deref(new EReg("^\\w+\$", ""))->match($stringTest)) {
						throw new HException(new haxigniter_server_libraries_DatabaseException("Charset/collation settings must be alphanumeric.", null, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 354, "className" => "haxigniter.server.libraries.Database", "methodName" => "sendCollationQuery"))));
					}
					if($this->collation !== null) {
						$this->getConnection()->request("SET NAMES '" . $this->charSet . "' COLLATE '" . $this->collation . "'");
					} else {
						$this->getConnection()->request("SET CHARACTER SET " . $this->charSet);
					}
				}
			}break;
			case 1:
			{
			}break;
			case 2:
			{
				throw new HException(new haxigniter_server_libraries_DatabaseException("No database connection specified.", $this, _hx_anonymous(array("fileName" => "Database.hx", "lineNumber" => 76, "className" => "haxigniter.server.libraries.Database", "methodName" => "getConnection"))));
			}break;
			}
		}
		return $this->myConnection;
	}
	public $myConnection;
	public $connection;
	public $debug;
	public $collation;
	public $charSet;
	public $driver;
	public $socket;
	public $database;
	public $pass;
	public $user;
	public $port;
	public $host;
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
	static $alphaRegexp;
	static $__properties__ = array("set_connection" => "setConnection","get_connection" => "getConnection");
	function __toString() { return 'haxigniter.server.libraries.Database'; }
}
haxigniter_server_libraries_Database::$alphaRegexp = new EReg("^\\w+\$", "");
function haxigniter_server_libraries_Database_0(&$»this) {
	if($»this->collation !== null) {
		return $»this->collation;
	} else {
		return "";
	}
}
function haxigniter_server_libraries_Database_1(&$»this, &$params, &$query) {
	if($»this->parameterString === null) {
		return "?";
	} else {
		return $»this->parameterString;
	}
}
function haxigniter_server_libraries_Database_2(&$»this) {
	if($»this->collation !== null) {
		return $»this->collation;
	} else {
		return "";
	}
}
