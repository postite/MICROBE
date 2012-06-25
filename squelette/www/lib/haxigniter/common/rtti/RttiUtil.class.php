<?php

class haxigniter_common_rtti_RttiUtil {
	public function __construct(){}
	static function getMethod($name, $classType) {
		$methods = haxigniter_common_rtti_RttiUtil::getMethods($classType, $name);
		if(!$methods->keys()->hasNext()) {
			return null;
		}
		return $methods->get($name);
	}
	static function getMethods($classType, $methodName) {
		$output = new Hash();
		$»t = (haxigniter_common_rtti_RttiUtil::getTypeTree($classType));
		switch($»t->index) {
		case 1:
		$cl = $»t->params[0];
		{
			if(null == $cl->fields) throw new HException('null iterable');
			$»it = $cl->fields->iterator();
			while($»it->hasNext()) {
				$f = $»it->next();
				if($methodName !== null && $f->name !== $methodName) {
					continue;
				}
				$»t2 = ($f->type);
				switch($»t2->index) {
				case 4:
				$ret = $»t2->params[1]; $args = $»t2->params[0];
				{
					$argList = new HList();
					if(null == $args) throw new HException('null iterable');
					$»it2 = $args->iterator();
					while($»it2->hasNext()) {
						$arg = $»it2->next();
						$typeName = haxigniter_common_rtti_RttiUtil::typeName($arg->t, false);
						$argList->add(_hx_anonymous(array("type" => $typeName, "opt" => $arg->opt, "name" => $arg->name)));
						unset($typeName);
					}
					$output->set($f->name, $argList);
				}break;
				default:{
				}break;
				}
			}
		}break;
		default:{
			throw new HException("No RTTI class information found in " . $classType);
		}break;
		}
		return $output;
	}
	static function typeName($type, $opt) {
		$»t = ($type);
		switch($»t->index) {
		case 4:
		{
			return (($opt) ? "Null<function>" : "function");
		}break;
		case 0:
		{
			return (($opt) ? "Null<unknown>" : "unknown");
		}break;
		case 5:
		case 6:
		{
			return (($opt) ? "Null<Dynamic>" : "Dynamic");
		}break;
		case 1:
		case 2:
		case 3:
		$params = $»t->params[1]; $name = $»t->params[0];
		{
			$t = $name;
			if($params !== null && $params->length > 0) {
				$types = new HList();
				if(null == $params) throw new HException('null iterable');
				$»it = $params->iterator();
				while($»it->hasNext()) {
					$p = $»it->next();
					$types->add(haxigniter_common_rtti_RttiUtil::typeName($p, false));
				}
				$t .= "<" . $types->join(",") . ">";
			}
			return haxigniter_common_rtti_RttiUtil_0($name, $opt, $params, $t, $type);
		}break;
		}
	}
	static function getTypeTree($classType) {
		$root = Xml::parse(haxigniter_common_rtti_RttiUtil::getRtti($classType))->firstElement();
		return _hx_deref(new haxe_rtti_XmlParser())->processElement($root);
	}
	static function getRtti($classType) {
		$rtti = $classType->__rtti;
		if($rtti === null) {
			throw new HException("No RTTI information found in " . $classType . " (class must implement haxe.rtti.Infos)");
		}
		return $rtti;
	}
	function __toString() { return 'haxigniter.common.rtti.RttiUtil'; }
}
function haxigniter_common_rtti_RttiUtil_0(&$name, &$opt, &$params, &$t, &$type) {
	if($name !== "Null" && $opt) {
		return "Null<" . $t . ">";
	} else {
		return $t;
	}
}
