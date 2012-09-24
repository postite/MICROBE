<?php

class microbe_Api implements haxe_rtti_Infos{
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
		$voInstance = null;
		if($this->map->id !== null) {
			$voInstance = $this->getOne($this->map->voClass, $this->map->id);
		} else {
			$voInstance = Type::createInstance(Type::resolveClass($this->voPackage . $this->map->voClass), new _hx_array(array()));
		}
		$creator = new microbe_MicroCreator();
		$creator->source = $this->map->fields;
		$creator->data = $voInstance;
		$fullSpod = $creator->record();
		$fullSpod->date = Date::now();
		if(_hx_field($fullSpod, "id") === null) {
			$fullSpod->insert();
		} else {
			$fullSpod->update();
		}
	}
	public function rec() {
		$this->getClassMap();
		$this->recClassMap();
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
	public function getAllorded($_vo) {
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
		$liste = $manager->unsafeObjects("SELECT * FROM " . $table . " ORDER BY poz", true);
		return $liste;
	}
	public function getOneH($_vo, $id) {
		$spod = $this->getOne($_vo, $id);
		$out = new microbe_Output($spod, null);
		$compressed = haxe_Serializer::run($out->render());
		return $compressed;
	}
	public function getLast($_vo) {
		$all = null;
		try {
			$all = $this->getManager($_vo)->all(null);
		}catch(Exception $�e) {
			$_ex_ = ($�e instanceof HException) ? $�e->e : $�e;
			if(is_string($msg = $_ex_)){
				null;
			} else throw $�e;;
		}
		if(_hx_len($all) > 0) {
			return $all->last();
		} else {
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
			$args = $rest->slice(1, null);
			$spodName = strtolower($args[0]);
			$spodId = Std::parseInt(_hx_array_get($args->slice(2, null), 0));
			$tags = microbe_TagManager::getTags($spodName, $spodId);
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
		else if(isset($this->�dynamics[$m]) && is_callable($this->�dynamics[$m]))
			return call_user_func_array($this->�dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call �'.$m.'�');
	}
	static $__rtti = "<class path=\"microbe.Api\" params=\"\">\x0A\x09<implements path=\"haxe.rtti.Infos\"/>\x0A\x09<map><c path=\"microbe.ClassMap\"/></map>\x0A\x09<voPackage><c path=\"String\"/></voPackage>\x0A\x09<cnx><c path=\"sys.db.Connection\"/></cnx>\x0A\x09<rootSpod><c path=\"microbe.vo.Spodable\"/></rootSpod>\x0A\x09<_xml set=\"method\" line=\"62\"><f a=\"data\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></_xml>\x0A\x09<_json set=\"method\" line=\"65\"><f a=\"data\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></_json>\x0A\x09<spodByTag public=\"1\" set=\"method\" line=\"81\"><f a=\"s\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></spodByTag>\x0A\x09<recTag public=\"1\" set=\"method\" line=\"95\"><f a=\"tag:spod:spod_id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></recTag>\x0A\x09<dissociateTag public=\"1\" set=\"method\" line=\"109\"><f a=\"tag:spod:spod_id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></dissociateTag>\x0A\x09<associateTag public=\"1\" set=\"method\" line=\"113\"><f a=\"tag:spod:spodId\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></associateTag>\x0A\x09<tags public=\"1\" set=\"method\" line=\"120\"><f a=\"\"><e path=\"Void\"/></f></tags>\x0A\x09<test public=\"1\" set=\"method\" line=\"168\"><f a=\"arg\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></test>\x0A\x09<trigger public=\"1\" set=\"method\" line=\"173\"><f a=\"_voName:functionName:?params\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Array\"><c path=\"String\"/></c>\x0A\x09<e path=\"Void\"/>\x0A</f></trigger>\x0A\x09<getClassMap set=\"method\" line=\"184\"><f a=\"\"><c path=\"microbe.ClassMap\"/></f></getClassMap>\x0A\x09<read public=\"1\" set=\"method\" line=\"191\"><f a=\"_vo:?id:?offset\">\x0A\x09<c path=\"String\"/>\x0A\x09<t path=\"microbe.Vo_Id\"/>\x0A\x09<t path=\"microbe.Offset\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></read>\x0A\x09<getOne public=\"1\" set=\"method\" line=\"196\"><f a=\"_vo:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></getOne>\x0A\x09<getLast public=\"1\" set=\"method\" line=\"201\"><f a=\"_vo\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></getLast>\x0A\x09<getOneH public=\"1\" set=\"method\" line=\"225\"><f a=\"_vo:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"String\"/>\x0A</f></getOneH>\x0A\x09<getAllorded public=\"1\" set=\"method\" line=\"234\"><f a=\"_vo\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getAllorded>\x0A\x09<getSearch public=\"1\" set=\"method\" line=\"264\"><f a=\"_vo:search\">\x0A\x09<c path=\"String\"/>\x0A\x09<d/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getSearch>\x0A\x09<getAll public=\"1\" set=\"method\" line=\"294\"><f a=\"_vo\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getAll>\x0A\x09<getPages set=\"method\" line=\"302\"><f a=\"vo:offset\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></getPages>\x0A\x09<rec public=\"1\" set=\"method\" line=\"310\"><f a=\"\"><e path=\"Void\"/></f></rec>\x0A\x09<recClassMap set=\"method\" line=\"315\"><f a=\"\"><e path=\"Void\"/></f></recClassMap>\x0A\x09<delete public=\"1\" set=\"method\" line=\"343\"><f a=\"voName:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></delete>\x0A\x09<getManager set=\"method\" line=\"350\"><f a=\"_vo\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"sys.db.Manager\"><c path=\"sys.db.Object\"/></c>\x0A</f></getManager>\x0A\x09<createInstance set=\"method\" line=\"357\"><f a=\"_vo\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></createInstance>\x0A\x09<new public=\"1\" set=\"method\" line=\"53\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'microbe.Api'; }
}
