<?php

class microbe_TagManager {
	public function __construct() { 
	}
	static $currentspod;
	static $voPackage = "vo.";
	static $debug = 1;
	static $currentInstance;
	static function getSpodsByTag($tag, $spodstring = null) {
		microbe_TagManager::$currentspod = microbe_TagManager::firstUpperCase($spodstring);
		$tag_id = microbe_TagManager::getTaxo($tag, strtolower($spodstring))->taxo_id;
		$spodTable = microbe_TagManager::getSpodTable($spodstring);
		$resultSet = sys_db_Manager::$cnx->request("\x0A\x09SELECT  DISTINCT B.* from  " . $spodTable . " AS B\x0A\x09LEFT JOIN `tagSpod` AS TS ON TS.`spod_id`=B.id \x0A\x09LEFT JOIN  `taxo` AS TX ON TX.`taxo_id`= TS.`tag_id`  \x0A\x09WHERE TX.taxo_id=" . _hx_string_rec($tag_id, ""));
		$maped = $resultSet->results()->map((isset(microbe_TagManager::$maptoSpod) ? microbe_TagManager::$maptoSpod: array("microbe_TagManager", "maptoSpod")));
		return $maped;
	}
	static function getTags($spod, $spodId = null) {
		$liste = null;
		if($spodId !== null) {
			$liste = microbe_TagManager::getTaxoBySpodID($spod, $spodId);
		} else {
			$liste = microbe_TagManager::getTaxos($spod);
		}
		$tags = new HList();
		if(null == $liste) throw new HException('null iterable');
		$»it = $liste->iterator();
		while($»it->hasNext()) {
			$tax = $»it->next();
			$tag = new microbe_Tag();
			$tag->id = $tax->taxo_id;
			$tag->tag = $tax->tag;
			$tags->add($tag);
			unset($tag);
		}
		return $tags;
	}
	static function getTaxo($tag, $spod = null) {
		return vo_Taxo::$manager->unsafeObjects("SELECT * FROM taxo WHERE (tag = " . sys_db_Manager::quoteAny($tag) . (" AND spodtype = " . sys_db_Manager::quoteAny($spod)) . ")", null)->first();
	}
	static function getTaxos($spod) {
		$spodTable = microbe_TagManager::getSpodTable($spod);
		$resultSet = sys_db_Manager::$cnx->request("\x0A\x09\x09SELECT distinct TX.* from taxo AS TX\x0A\x09\x09JOIN tagSpod AS TS ON TS.tag_id=TX.taxo_id\x0A\x09\x09JOIN " . $spodTable . " AS SP ON SP.id=TS.spod_id\x0A\x09\x09WHERE TX.spodtype='" . strtolower($spod) . "'");
		return $resultSet->results();
	}
	static function getTaxoBySpodID($spod, $spod_id) {
		$spodTable = microbe_TagManager::getSpodTable($spod);
		$cap = microbe_TagManager::firstUpperCase($spod);
		$spodable = Type::resolveClass(microbe_TagManager::$voPackage . $cap);
		$resultSet = sys_db_Manager::$cnx->request("\x0A\x09SELECT DISTINCT TX.taxo_id , TX.tag from `taxo` AS TX\x0A\x09LEFT JOIN `tagSpod` AS TS ON TS.`tag_id`=TX.`taxo_id`\x0A\x09LEFT JOIN " . $spodTable . " AS B ON TS.`spod_id`= B.`id`\x0A\x09WHERE B.id=" . _hx_string_rec($spod_id, "") . " AND TX.spodtype='" . $spod . "'");
		return $resultSet->results();
	}
	static function getTagsById($spod, $spodId) {
		$liste = microbe_TagManager::getTaxoBySpodID($spod, $spodId);
		$tags = new HList();
		if(null == $liste) throw new HException('null iterable');
		$»it = $liste->iterator();
		while($»it->hasNext()) {
			$tax = $»it->next();
			$tag = new microbe_Tag();
			$tag->id = $tax->taxo_id;
			$tag->tag = $tax->tag;
			$tags->add($tag);
			unset($tag);
		}
		return $tags;
	}
	static function getIDS($tag, $spod) {
		$result = sys_db_Manager::$cnx->request("Select spod_id \x0Afrom tagSpod \x0Awhere tag_id \x0Ain (\x0ASelect taxo_id \x0Afrom taxo \x0Awhere tag='" . $tag . "' and spodtype='" . $spod . "')");
		$map = new HList();
		while($result->hasNext()) {
			$map->add($result->next()->spod_id);
		}
		return $map;
	}
	static function specialcount($tag, $spod, $_search) {
		$table = microbe_TagManager::getSpodTable($spod);
		microbe_TagManager::$currentspod = microbe_TagManager::firstUpperCase($spod);
		$str = new StringBuf();
		$str->add("Select count(*) from " . $table);
		$str->add(" ");
		$str->add(" Where ");
		if($_search !== null) {
			$first = true;
			{
				$_g = 0; $_g1 = Reflect::fields($_search);
				while($_g < $_g1->length) {
					$key = $_g1[$_g];
					++$_g;
					$value = Reflect::field($_search, $key);
					if(Std::is($value, _hx_qtype("String"))) {
						$str->add($key . "='" . $value . "'");
					} else {
						$str->add($key . "=" . $value);
					}
					$first = false;
					$str->add(" AND ");
					unset($value,$key);
				}
			}
			$str->add(" ");
		}
		$str->add(" id in (Select `spod_id` \x0Afrom tagSpod \x0Awhere tag_id \x0Ain (\x0ASelect taxo_id \x0Afrom taxo \x0Awhere tag='" . $tag . "' and spodtype='" . strtolower($spod) . "')) ");
		$result = sys_db_Manager::$cnx->request($str->b);
		php_Lib::hprint($result->getIntResult(0));
		return $result->getIntResult(0);
	}
	static function specialsearch($tag, $spod, $_search, $tri, $generateSpods = null) {
		if($generateSpods === null) {
			$generateSpods = true;
		}
		$table = microbe_TagManager::getSpodTable($spod);
		microbe_TagManager::$currentspod = microbe_TagManager::firstUpperCase($spod);
		$str = new StringBuf();
		$str->add("Select * from " . $table);
		$str->add(" ");
		$str->add(" Where ");
		if($_search !== null) {
			$first = true;
			{
				$_g = 0; $_g1 = Reflect::fields($_search);
				while($_g < $_g1->length) {
					$key = $_g1[$_g];
					++$_g;
					$value = Reflect::field($_search, $key);
					if(Std::is($value, _hx_qtype("String"))) {
						$str->add($key . "='" . $value . "'");
					} else {
						$str->add($key . "=" . $value);
					}
					$first = false;
					$str->add(" AND ");
					unset($value,$key);
				}
			}
			$str->add(" ");
		}
		$str->add(" id in (Select `spod_id` \x0Afrom tagSpod \x0Awhere tag_id \x0Ain (\x0ASelect taxo_id \x0Afrom taxo \x0Awhere tag='" . $tag . "' and spodtype='" . strtolower($spod) . "')) ");
		if($tri !== null) {
			if($tri->orderBy !== null) {
				$str->add(" ORDER BY " . $tri->orderBy->join(","));
			}
			if($tri->limit !== null) {
				$str->add(" LIMIT " . $tri->limit->join(","));
			}
		}
		$result = sys_db_Manager::$cnx->request($str->b);
		if($generateSpods) {
			return $result->results()->map((isset(microbe_TagManager::$maptoSpod) ? microbe_TagManager::$maptoSpod: array("microbe_TagManager", "maptoSpod")));
		}
		return $result->results();
	}
	static function associate($tag, $spod, $spodId) {
		$id = microbe_TagManager::getTaxo($tag, $spod)->taxo_id;
		sys_db_Manager::$cnx->request("insert into tagSpod (tag_id,spod_id) VALUES (" . _hx_string_rec($id, "") . "," . _hx_string_rec($spodId, "") . ") ");
	}
	static function dissociate($tag, $spod, $spodId) {
		$id = microbe_TagManager::getTaxo($tag, $spod)->taxo_id;
		sys_db_Manager::$cnx->request("DELETE  FROM tagSpod  WHERE tag_id=" . _hx_string_rec($id, "") . " and spod_id=" . _hx_string_rec($spodId, ""));
	}
	static function maptoSpod($res) {
		$spod = Type::createInstance(Type::resolveClass("vo." . microbe_TagManager::$currentspod), new _hx_array(array()));
		$formule = $spod->getFormule();
		$spod->{"id"} = Reflect::field($res, "id");
		if(null == $formule) throw new HException('null iterable');
		$»it = $formule->keys();
		while($»it->hasNext()) {
			$key = $»it->next();
			$spod->{$key} = Reflect::field($res, $key);
		}
		return $spod;
	}
	static function getSpodTable($spod) {
		$voPackage = "vo.";
		$cap = microbe_TagManager::firstUpperCase($spod);
		$spodable = Type::resolveClass($voPackage . $cap);
		microbe_TagManager::$currentInstance = $spodable;
		$manager = Reflect::field($spodable, "manager");
		$spodinfos = $manager->dbInfos();
		return $spodinfos->name;
	}
	static function firstUpperCase($str) {
		$firstChar = _hx_substr($str, 0, 1);
		$restOfString = _hx_substr($str, 1, strlen($str));
		return strtoupper($firstChar) . strtolower($restOfString);
	}
	static function recTag($s) {
		return $s;
	}
	static function recTags($listTag) {
	}
	static function getSpodName($spod) {
		return _hx_explode(".", Type::getClassName($spod))->slice(-1, null)->toString();
	}
	function __toString() { return 'microbe.TagManager'; }
}
