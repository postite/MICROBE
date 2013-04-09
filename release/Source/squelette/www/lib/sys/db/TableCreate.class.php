<?php

class sys_db_TableCreate {
	public function __construct(){}
	static function autoInc($dbName) {
		return (($dbName === "SQLite") ? "PRIMARY KEY AUTOINCREMENT" : "AUTO_INCREMENT");
	}
	static function getTypeSQL($t, $dbName) {
		return sys_db_TableCreate_0($dbName, $t);
	}
	static function create($manager, $engine = null) {
		$quote = array(new _hx_lambda(array(&$engine, &$manager), "sys_db_TableCreate_1"), 'execute');
		$cnx = $manager->getCnx();
		if($cnx === null) {
			throw new HException("SQL Connection not initialized on Manager");
		}
		$dbName = $cnx->dbName();
		$infos = $manager->dbInfos();
		$sql = "CREATE TABLE " . call_user_func_array($quote, array($infos->name)) . " (";
		$decls = new _hx_array(array());
		$hasID = false;
		{
			$_g = 0; $_g1 = $infos->fields;
			while($_g < $_g1->length) {
				$f = $_g1[$_g];
				++$_g;
				$»t = ($f->t);
				switch($»t->index) {
				case 0:
				{
					$hasID = true;
				}break;
				case 2:
				case 4:
				{
					$hasID = true;
					if($dbName === "SQLite") {
						throw new HException("S" . _hx_substr(Std::string($f->t), 1, null) . " is not supported by " . $dbName . " : use SId instead");
					}
				}break;
				default:{
				}break;
				}
				$decls->push(call_user_func_array($quote, array($f->name)) . " " . sys_db_TableCreate::getTypeSQL($f->t, $dbName) . ((($f->isNull) ? "" : " NOT NULL")));
				unset($f);
			}
		}
		if($dbName !== "SQLite" || !$hasID) {
			$decls->push("PRIMARY KEY (" . Lambda::map($infos->key, $quote)->join(",") . ")");
		}
		$sql .= $decls->join(",");
		$sql .= ")";
		if($engine !== null) {
			$sql .= "ENGINE=" . $engine;
		}
		$cnx->request($sql);
	}
	static function exists($manager) {
		$cnx = $manager->getCnx();
		if($cnx === null) {
			throw new HException("SQL Connection not initialized on Manager");
		}
		try {
			$cnx->request("SELECT * FROM `" . $manager->dbInfos()->name . "` LIMIT 1");
			return true;
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			$e = $_ex_;
			{
				return false;
			}
		}
	}
	function __toString() { return 'sys.db.TableCreate'; }
}
function sys_db_TableCreate_0(&$dbName, &$t) {
	$»t = ($t);
	switch($»t->index) {
	case 0:
	{
		return "INTEGER " . sys_db_TableCreate::autoInc($dbName);
	}break;
	case 2:
	{
		return "INTEGER UNSIGNED " . sys_db_TableCreate::autoInc($dbName);
	}break;
	case 1:
	case 20:
	{
		return "INTEGER";
	}break;
	case 3:
	{
		return "INTEGER UNSIGNED";
	}break;
	case 24:
	{
		return "TINYINT";
	}break;
	case 25:
	{
		return "TINYINT UNSIGNED";
	}break;
	case 26:
	{
		return "SMALLINT";
	}break;
	case 27:
	{
		return "SMALLINT UNSIGNED";
	}break;
	case 28:
	{
		return "MEDIUMINT";
	}break;
	case 29:
	{
		return "MEDIUMINT UNSIGNED";
	}break;
	case 6:
	{
		return "FLOAT";
	}break;
	case 7:
	{
		return "DOUBLE";
	}break;
	case 8:
	{
		return "TINYINT(1)";
	}break;
	case 9:
	$n = $»t->params[0];
	{
		return "VARCHAR(" . _hx_string_rec($n, "") . ")";
	}break;
	case 10:
	{
		return "DATE";
	}break;
	case 11:
	{
		return "DATETIME";
	}break;
	case 12:
	{
		return "TIMESTAMP DEFAULT 0";
	}break;
	case 13:
	{
		return "TINYTEXT";
	}break;
	case 14:
	{
		return "TEXT";
	}break;
	case 15:
	case 21:
	{
		return "MEDIUMTEXT";
	}break;
	case 16:
	{
		return "BLOB";
	}break;
	case 18:
	case 22:
	{
		return "MEDIUMBLOB";
	}break;
	case 17:
	{
		return "LONGBLOB";
	}break;
	case 5:
	{
		return "BIGINT";
	}break;
	case 4:
	{
		return "BIGINT " . sys_db_TableCreate::autoInc($dbName);
	}break;
	case 19:
	$n = $»t->params[0];
	{
		return "BINARY(" . _hx_string_rec($n, "") . ")";
	}break;
	case 23:
	$auto = $»t->params[1]; $fl = $»t->params[0];
	{
		return sys_db_TableCreate::getTypeSQL((($auto) ? (($fl->length <= 8) ? sys_db_SpodType::$DTinyUInt : (($fl->length <= 16) ? sys_db_SpodType::$DSmallUInt : (($fl->length <= 24) ? sys_db_SpodType::$DMediumUInt : sys_db_SpodType::$DInt))) : sys_db_SpodType::$DInt), $dbName);
	}break;
	case 31:
	case 30:
	{
		throw new HException("assert");
	}break;
	}
}
function sys_db_TableCreate_1(&$engine, &$manager, $v) {
	{
		return $manager->quoteField($v);
	}
}
