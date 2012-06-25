<?php

class vo_TagManager extends sys_db_Manager {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct(_hx_qtype("vo.Taxo"));
	}}
	public $currentspod;
	public function getTags($spod) {
		haxe_Log::trace("Taxo.manager from microbe" . $spod, _hx_anonymous(array("fileName" => "Taxo.hx", "lineNumber" => 42, "className" => "vo.TagManager", "methodName" => "getTags")));
		$spodTable = $this->getSpodTable($spod);
		haxe_Log::trace("spodTAble=" . $spodTable, _hx_anonymous(array("fileName" => "Taxo.hx", "lineNumber" => 44, "className" => "vo.TagManager", "methodName" => "getTags")));
		$resultSet = sys_db_Manager::$cnx->request("\x0A\x09\x09SELECT distinct TX.* from taxo AS TX\x0A\x09\x09JOIN tagSpod AS TS ON TS.tag_id=TX.taxo_id\x0A\x09\x09JOIN " . $spodTable . " AS SP ON SP.id=TS.spod_id\x0A\x09\x09WHERE TX.spodtype='" . strtolower($spod) . "'");
		haxe_Log::trace("resultSet=" . $resultSet . "spodTAble=" . $spodTable, _hx_anonymous(array("fileName" => "Taxo.hx", "lineNumber" => 52, "className" => "vo.TagManager", "methodName" => "getTags")));
		return $resultSet->results();
	}
	public function getTag($tag, $spod) {
		return $this->unsafeObjects("SELECT * FROM taxo WHERE (tag = " . sys_db_Manager::quoteAny($tag) . (" AND spodtype = " . sys_db_Manager::quoteAny($spod)) . ")", null)->first();
	}
	public function getSpodsByTag($tag, $spodstring) {
		$this->currentspod = $this->firstUpperCase($spodstring);
		$tag_id = $this->getTag($tag, strtolower($spodstring))->taxo_id;
		$spodTable = $this->getSpodTable($spodstring);
		$resultSet = sys_db_Manager::$cnx->request("\x0A\x09SELECT  DISTINCT B.* from  " . $spodTable . " AS B\x0A\x09LEFT JOIN `tagSpod` AS TS ON TS.`spod_id`=B.id \x0A\x09LEFT JOIN  `taxo` AS TX ON TX.`taxo_id`= TS.`tag_id`  \x0A\x09WHERE TX.taxo_id=" . $tag_id);
		$maped = $resultSet->results()->map((isset($this->maptoSpod) ? $this->maptoSpod: array($this, "maptoSpod")));
		return $maped;
	}
	public function maptoSpod($res) {
		$spod = Type::createInstance(Type::resolveClass("vo." . $this->currentspod), new _hx_array(array()));
		$formule = $spod->getFormule();
		$spod->{"id"} = Reflect::field($res, "id");
		if(null == $formule) throw new HException('null iterable');
		$»it = $formule->keys();
		while($»it->hasNext()) {
			$key = $»it->next();
			haxe_Log::trace("key=" . $key, _hx_anonymous(array("fileName" => "Taxo.hx", "lineNumber" => 98, "className" => "vo.TagManager", "methodName" => "maptoSpod")));
			$spod->{$key} = Reflect::field($res, $key);
		}
		return $spod;
	}
	public function getTagsBySpodID($spod, $spod_id) {
		$spodTable = $this->getSpodTable($spod);
		$resultSet = sys_db_Manager::$cnx->request("\x0A\x09SELECT DISTINCT TX.taxo_id , TX.tag from `taxo` AS TX\x0A\x09LEFT JOIN `tagSpod` AS TS ON TS.`tag_id`=TX.`taxo_id`\x0A\x09LEFT JOIN " . $spodTable . " AS B ON TS.`spod_id`= B.`id`\x0A\x09WHERE B.id=" . $spod_id . " AND TX.spodtype='" . $spod . "'");
		return $resultSet->results();
	}
	public function associate($tag, $spod, $spodId) {
		$id = $this->getTag($tag, $spod)->taxo_id;
		sys_db_Manager::$cnx->request("insert into tagSpod (tag_id,spod_id) VALUES (" . $id . "," . $spodId . ") ");
	}
	public function dissociate($tag, $spod, $spodId) {
		$id = $this->getTag($tag, $spod)->taxo_id;
		sys_db_Manager::$cnx->request("DELETE  FROM tagSpod  WHERE tag_id=" . $id . " and spod_id=" . $spodId);
	}
	public function getSpodTable($spod) {
		haxe_Log::trace("getSpoTable" . $spod, _hx_anonymous(array("fileName" => "Taxo.hx", "lineNumber" => 129, "className" => "vo.TagManager", "methodName" => "getSpodTable")));
		$voPackage = "vo.";
		$cap = $this->firstUpperCase($spod);
		$spodable = Type::resolveClass($voPackage . $cap);
		haxe_Log::trace("spodable" . $spodable, _hx_anonymous(array("fileName" => "Taxo.hx", "lineNumber" => 134, "className" => "vo.TagManager", "methodName" => "getSpodTable")));
		$manager = Reflect::field($spodable, "manager");
		haxe_Log::trace("manager" . $manager, _hx_anonymous(array("fileName" => "Taxo.hx", "lineNumber" => 136, "className" => "vo.TagManager", "methodName" => "getSpodTable")));
		$spodinfos = $manager->dbInfos();
		return $spodinfos->name;
	}
	public function firstUpperCase($str) {
		$firstChar = _hx_substr($str, 0, 1);
		$restOfString = _hx_substr($str, 1, strlen($str));
		return strtoupper($firstChar) . strtolower($restOfString);
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
	static $__properties__ = array("set_cnx" => "setConnection");
	function __toString() { return 'vo.TagManager'; }
}
