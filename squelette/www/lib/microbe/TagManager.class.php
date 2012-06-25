<?php

class microbe_TagManager {
	public function __construct() { 
	}
	static $debug = 1;
	static function getSpodsbyTag($tag, $spod) {
		$liste = null;
		try {
			$liste = vo_Taxo::$manager->getSpodsByTag($tag, $spod);
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			if(is_string($msg = $_ex_)){
				haxe_Log::trace("Error occurred: " . $msg, _hx_anonymous(array("fileName" => "TagManager.hx", "lineNumber" => 34, "className" => "microbe.TagManager", "methodName" => "getSpodsbyTag")));
			} else throw $»e;;
		}
		return $liste;
	}
	static function getTags($spod, $spodId) {
		haxe_Log::trace("getTags", _hx_anonymous(array("fileName" => "TagManager.hx", "lineNumber" => 41, "className" => "microbe.TagManager", "methodName" => "getTags")));
		$liste = null;
		if($spodId !== null) {
			$liste = vo_Taxo::$manager->getTagsBySpodID($spod, $spodId);
		} else {
			$liste = vo_Taxo::$manager->getTags($spod);
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
	static function getTagsById($spod, $spodId) {
		haxe_Log::trace("getTags", _hx_anonymous(array("fileName" => "TagManager.hx", "lineNumber" => 60, "className" => "microbe.TagManager", "methodName" => "getTagsById")));
		$liste = vo_Taxo::$manager->getTagsBySpodID($spod, $spodId);
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
