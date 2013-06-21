<?php

class microbe_Api {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		microbe_tools_Mytrace::setRedirection();
		$this->cnx = sys_db_Manager::setConnection(microbe_controllers_GenericController::$appDb->getConnection());
		sys_db_Manager::initialize();
		$this->voPackage = microbe_controllers_GenericController::$appConfig->voPackage;
	}}
	public function createInstance($_vo) {
		return Type::createInstance(Type::resolveClass($_vo), new _hx_array(array()));
	}
	public function getManager($_vo) {
		$stringVo = $this->voPackage . $_vo;
		return Reflect::field(Type::resolveClass($stringVo), "manager");
	}
	public function delete($voName, $id) {
		$spodadelete = $this->getManager($voName)->unsafeGet($id, null);
		$spodadelete->delete();
	}
	public function recClassMap() {
		haxe_Log::trace("record" . _hx_string_rec($this->map->id, ""), _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 340, "className" => "microbe.Api", "methodName" => "recClassMap")));
		$voInstance = null;
		if($this->map->id !== null) {
			haxe_Log::trace("map.id!=null", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 343, "className" => "microbe.Api", "methodName" => "recClassMap")));
			$voInstance = $this->getOne($this->map->voClass, $this->map->id);
		} else {
			$voInstance = Type::createInstance(Type::resolveClass($this->voPackage . $this->map->voClass), new _hx_array(array()));
			$manager = Reflect::field(Type::resolveClass($this->voPackage . $this->map->voClass), "manager");
			$dbInfos = $manager->dbInfos();
			haxe_Log::trace("DBINFOS" . Std::string($dbInfos), _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 350, "className" => "microbe.Api", "methodName" => "recClassMap")));
			$indexes = $dbInfos->indexes;
			{
				$_g = 0; $_g1 = $dbInfos->indexes;
				while($_g < $_g1->length) {
					$index = $_g1[$_g];
					++$_g;
					if($index->unique) {
						$_g2 = 0; $_g3 = $index->keys;
						while($_g2 < $_g3->length) {
							$key = $_g3[$_g2];
							++$_g2;
							haxe_Log::trace("unique=" . $key, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 355, "className" => "microbe.Api", "methodName" => "recClassMap")));
							if(null == $this->map->fields) throw new HException('null iterable');
							$»it = $this->map->fields->iterator();
							while($»it->hasNext()) {
								$f = $»it->next();
								if($f->field === $key) {
									haxe_Log::trace("found unique KEY", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 359, "className" => "microbe.Api", "methodName" => "recClassMap")));
									$value = addslashes($f->value);
									$pip = $manager->unsafeExecute("Select * from " . $dbInfos->name . " where " . $key . "='" . $value . "'");
									haxe_Log::trace("pip=" . _hx_string_rec($pip->getLength(), ""), _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 362, "className" => "microbe.Api", "methodName" => "recClassMap")));
									if($pip->getLength() > 0) {
										return new microbe_ERROR(microbe_ERROR_TYPE::$DOUBLON, null, $key);
									}
									unset($value,$pip);
								}
							}
							unset($key);
						}
						unset($_g3,$_g2);
					}
					unset($index);
				}
			}
			try {
				$voInstance->insert();
			}catch(Exception $»e) {
				$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
				if(is_string($err = $_ex_)){
					return new microbe_ERROR(microbe_ERROR_TYPE::$FATAL, null, null);
				} else throw $»e;;
			}
			$voInstance->id = microbe_controllers_GenericController::$appDb->getConnection()->lastInsertId();
		}
		haxe_Log::trace("after", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 381, "className" => "microbe.Api", "methodName" => "recClassMap")));
		$creator = new microbe_MicroCreator();
		$creator->source = $this->map->fields;
		$creator->data = $voInstance;
		$fullSpod = $creator->record();
		if(_hx_field($fullSpod, "date") === null) {
			$fullSpod->date = Date::now();
		}
		if(_hx_field($fullSpod, "id") === null) {
			try {
				$fullSpod->insert();
			}catch(Exception $»e) {
				$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
				if(is_string($msg = $_ex_)){
					throw new HException("erreur " . $msg);
				} else throw $»e;;
			}
		} else {
			$fullSpod->update();
		}
		haxe_Log::trace("fullSpod" . Std::string($fullSpod), _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 401, "className" => "microbe.Api", "methodName" => "recClassMap")));
		return $fullSpod;
	}
	public function microRec() {
		$cmap = php_Web::getParams()->get("micromap");
		$micromap = haxe_Unserializer::run($cmap);
		$voInstance = $this->getOne($micromap->voName, $micromap->voId);
		$voInstance->{$micromap->field} = $micromap->value;
		_hx_deref(($voInstance))->update();
		return $voInstance;
	}
	public function rec() {
		$this->getClassMap();
		return $this->recClassMap();
	}
	public function getPages($vo, $offset) {
	}
	public function getAll($_vo) {
		$stringVo = $this->voPackage . $_vo;
		$manager = Reflect::field(Type::resolveClass($stringVo), "manager");
		$liste = $manager->all(true);
		return $liste;
	}
	public function getSearch($_vo, $search) {
		$stringVo = $this->voPackage . $_vo;
		$liste = new HList();
		$manager = Reflect::field(Type::resolveClass($stringVo), "manager");
		$table = $manager->dbInfos()->name;
		{
			$_g = 0; $_g1 = Type::getClassFields(Type::resolveClass($stringVo));
			while($_g < $_g1->length) {
				$a = $_g1[$_g];
				++$_g;
				if($a === "getAllorded") {
					$liste = Reflect::callMethod(Type::resolveClass($stringVo), "getAllorded", new _hx_array(array()));
					return $liste;
				}
				unset($a);
			}
		}
		$liste = $manager->dynamicSearch($search, null);
		return $liste;
	}
	public function getAllorded($_vo, $arg = null) {
		$stringVo = $this->voPackage . $_vo;
		$liste = new HList();
		$manager = Reflect::field(Type::resolveClass($stringVo), "manager");
		$table = $manager->dbInfos()->name;
		{
			$_g = 0; $_g1 = Type::getClassFields(Type::resolveClass($stringVo));
			while($_g < $_g1->length) {
				$a = $_g1[$_g];
				++$_g;
				if($a === "getAllorded") {
					$liste = Reflect::callMethod(Type::resolveClass($stringVo), "getAllorded", $arg);
					return $liste;
				}
				unset($a);
			}
		}
		$liste = $manager->unsafeObjects("SELECT * FROM " . $table . " ORDER BY poz", true);
		return $liste;
	}
	public function getOneH($_vo, $id) {
		$spod = $this->getOne($_vo, $id);
		$out = new microbe_Output($spod, null);
		$compressed = haxe_Serializer::run($out->render());
		return $compressed;
	}
	public function getLast($_vo, $search = null) {
		$all = null;
		try {
			if($search !== null) {
				$all = $this->getManager($_vo)->dynamicSearch($search, null);
			} else {
				$all = $this->getManager($_vo)->all(null);
			}
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			if(is_string($msg = $_ex_)){
				php_Lib::hprint($msg);
			} else throw $»e;;
		}
		if(_hx_len($all) > 0) {
			haxe_Log::trace("micrabeLast", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 230, "className" => "microbe.Api", "methodName" => "getLast")));
			return $all->last();
		} else {
			haxe_Log::trace("null", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 233, "className" => "microbe.Api", "methodName" => "getLast")));
			return null;
		}
	}
	public function getOne($_vo, $id) {
		return $this->getManager($_vo)->unsafeGet($id, null);
	}
	public function read($_vo, $id = null, $offset = null) {
		php_Lib::hprint("pop" . $_vo);
	}
	public function getClassMap() {
		$cmap = php_Web::getParams()->get("map");
		$this->map = haxe_Unserializer::run($cmap);
		haxe_Log::trace("map=" . Std::string($this->map), _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 191, "className" => "microbe.Api", "methodName" => "getClassMap")));
		return $this->map;
	}
	public function trigger($_voName, $functionName, $params = null) {
		$instance = $this->createInstance($this->voPackage . $_voName);
		php_Lib::hprint(Reflect::callMethod($instance, $functionName, $params));
	}
	public function test($arg) {
		php_Lib::hprint($arg);
	}
	public function tags() {
		$url = new haxigniter_server_libraries_Url(microbe_controllers_GenericController::$appConfig);
		$segments = $url->segmentString(null, null);
		$slip = $url->split($segments, null);
		$rest = $slip->slice(2, null);
		$action = $rest[0];
		switch($action) {
		case "tag":{
			$args = $rest->slice(1, null);
			$tagName = strtolower($args[0]);
			$spodName = _hx_array_get($args->slice(2, null), 0);
			$spods = null;
			$spods = microbe_TagManager::getSpodsByTag($tagName, $spodName);
			php_Lib::hprint(haxe_Serializer::run($spods));
		}break;
		case "spod":{
			haxe_Log::trace("spod", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 150, "className" => "microbe.Api", "methodName" => "tags")));
			$args = $rest->slice(1, null);
			$spodName = strtolower($args[0]);
			haxe_Log::trace("spod" . $spodName, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 155, "className" => "microbe.Api", "methodName" => "tags")));
			$spodId = Std::parseInt(_hx_array_get($args->slice(2, null), 0));
			$tags = microbe_TagManager::getTags($spodName, $spodId);
			haxe_Log::trace("microbe.TagManager.getTags" . Std::string($tags), _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 160, "className" => "microbe.Api", "methodName" => "tags")));
			haxe_Log::trace("length=" . _hx_string_rec($tags->length, ""), _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 161, "className" => "microbe.Api", "methodName" => "tags")));
			php_Lib::hprint(haxe_Serializer::run($tags));
		}break;
		default:{
			php_Lib::hprint("ooups");
		}break;
		}
	}
	public function associateTag($tag, $spod, $spodId) {
		microbe_TagManager::associate($tag, $spod, $spodId);
	}
	public function dissociateTag($tag, $spod, $spod_id) {
		$tag = urldecode($tag);
		microbe_TagManager::dissociate($tag, $spod, $spod_id);
	}
	public function recTag($tag, $spod, $spod_id) {
		$tag = urldecode($tag);
		if(microbe_TagManager::getTaxo($tag, $spod) === null) {
			$neotag = new vo_Taxo();
			$neotag->tag = strtolower($tag);
			$neotag->spodtype = strtolower($spod);
			$neotag->insert();
		}
		$this->associateTag($tag, $spod, $spod_id);
		php_Lib::hprint($tag);
	}
	public function spodByTag($s) {
		$spods = microbe_TagManager::getSpodsByTag($s, null);
		php_Lib::hprint($spods);
		return $spods;
	}
	public function _json($data) {
	}
	public function _xml($data) {
		php_Lib::hprint("<data>" . $data . "</data>");
	}
	public $rootSpod;
	public $cnx;
	public $voPackage;
	public $map;
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
	static $__rtti = "<class path=\"microbe.Api\" params=\"\">\x0A\x09<map><c path=\"microbe.ClassMap\"/></map>\x0A\x09<voPackage><c path=\"String\"/></voPackage>\x0A\x09<cnx><c path=\"sys.db.Connection\"/></cnx>\x0A\x09<rootSpod><c path=\"microbe.vo.Spodable\"/></rootSpod>\x0A\x09<_xml set=\"method\" line=\"62\"><f a=\"data\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></_xml>\x0A\x09<_json set=\"method\" line=\"65\"><f a=\"data\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></_json>\x0A\x09<spodByTag public=\"1\" set=\"method\" line=\"81\"><f a=\"s\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></spodByTag>\x0A\x09<recTag public=\"1\" set=\"method\" line=\"95\"><f a=\"tag:spod:spod_id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></recTag>\x0A\x09<dissociateTag public=\"1\" set=\"method\" line=\"109\"><f a=\"tag:spod:spod_id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></dissociateTag>\x0A\x09<associateTag public=\"1\" set=\"method\" line=\"113\"><f a=\"tag:spod:spodId\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></associateTag>\x0A\x09<tags public=\"1\" set=\"method\" line=\"120\"><f a=\"\"><e path=\"Void\"/></f></tags>\x0A\x09<test public=\"1\" set=\"method\" line=\"172\"><f a=\"arg\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></test>\x0A\x09<trigger public=\"1\" set=\"method\" line=\"177\"><f a=\"_voName:functionName:?params\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Array\"><c path=\"String\"/></c>\x0A\x09<e path=\"Void\"/>\x0A</f></trigger>\x0A\x09<getClassMap set=\"method\" line=\"188\"><f a=\"\"><c path=\"microbe.ClassMap\"/></f></getClassMap>\x0A\x09<read public=\"1\" set=\"method\" line=\"195\"><f a=\"_vo:?id:?offset\">\x0A\x09<c path=\"String\"/>\x0A\x09<t path=\"microbe.Vo_Id\"/>\x0A\x09<t path=\"microbe.Offset\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></read>\x0A\x09<getOne public=\"1\" set=\"method\" line=\"200\"><f a=\"_vo:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></getOne>\x0A\x09<getLast public=\"1\" set=\"method\" line=\"212\"><f a=\"_vo:?search\">\x0A\x09<c path=\"String\"/>\x0A\x09<d/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></getLast>\x0A\x09<getOneH public=\"1\" set=\"method\" line=\"239\"><f a=\"_vo:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"String\"/>\x0A</f></getOneH>\x0A\x09<getAllorded public=\"1\" set=\"method\" line=\"248\"><f a=\"_vo:?arg\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Array\"><d/></c>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getAllorded>\x0A\x09<getSearch public=\"1\" set=\"method\" line=\"278\"><f a=\"_vo:search\">\x0A\x09<c path=\"String\"/>\x0A\x09<d/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getSearch>\x0A\x09<getAll public=\"1\" set=\"method\" line=\"308\"><f a=\"_vo\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getAll>\x0A\x09<getPages set=\"method\" line=\"316\"><f a=\"vo:offset\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></getPages>\x0A\x09<rec public=\"1\" set=\"method\" line=\"324\"><f a=\"\"><d/></f></rec>\x0A\x09<microRec public=\"1\" set=\"method\" line=\"331\"><f a=\"\"><c path=\"microbe.vo.Spodable\"/></f></microRec>\x0A\x09<recClassMap set=\"method\" line=\"339\"><f a=\"\"><d/></f></recClassMap>\x0A\x09<delete public=\"1\" set=\"method\" line=\"405\"><f a=\"voName:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></delete>\x0A\x09<getManager set=\"method\" line=\"412\"><f a=\"_vo\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"sys.db.Manager\"><c path=\"sys.db.Object\"/></c>\x0A</f></getManager>\x0A\x09<createInstance set=\"method\" line=\"419\"><f a=\"_vo\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></createInstance>\x0A\x09<new public=\"1\" set=\"method\" line=\"53\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A\x09<meta><m n=\":rttiInfos\"/></meta>\x0A</class>";
	function __toString() { return 'microbe.Api'; }
}
