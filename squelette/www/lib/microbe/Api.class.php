<?php

class microbe_Api implements haxe_rtti_Infos{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		$this->cnx = sys_db_Manager::setConnection(microbe_controllers_GenericController::$appDb->getConnection());
		sys_db_Manager::initialize();
		$this->voPackage = microbe_controllers_GenericController::$appConfig->voPackage;
	}}
	public $map;
	public $voPackage;
	public $cnx;
	public $rootSpod;
	public function _xml($data) {
		php_Lib::hprint("<data>" . $data . "</data>");
	}
	public function _json($data) {
	}
	public function spodByTag($s) {
		$spods = vo_Taxo::$manager->getSpodsByTag($s, null);
		php_Lib::hprint($spods);
		return $spods;
	}
	public function recTag($tag, $spod, $spod_id) {
		$tag = urldecode($tag);
		if(vo_Taxo::$manager->getTag($tag, $spod) === null) {
			$neotag = new vo_Taxo();
			$neotag->tag = strtolower($tag);
			$neotag->spodtype = strtolower($spod);
			$neotag->insert();
		}
		$this->associateTag($tag, $spod, $spod_id);
		php_Lib::hprint($tag);
	}
	public function dissociateTag($tag, $spod, $spod_id) {
		$tag = urldecode($tag);
		vo_Taxo::$manager->dissociate($tag, $spod, $spod_id);
	}
	public function associateTag($tag, $spod, $spodId) {
		vo_Taxo::$manager->associate($tag, $spod, $spodId);
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
			$spods = microbe_TagManager::getSpodsbyTag($tagName, $spodName);
			php_Lib::hprint(haxe_Serializer::run($spods));
		}break;
		case "spod":{
			haxe_Log::trace("spod", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 144, "className" => "microbe.Api", "methodName" => "tags")));
			$args = $rest->slice(1, null);
			$spodName = strtolower($args[0]);
			haxe_Log::trace("spod" . $spodName, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 149, "className" => "microbe.Api", "methodName" => "tags")));
			$spodId = Std::parseInt(_hx_array_get($args->slice(2, null), 0));
			$tags = microbe_TagManager::getTags($spodName, $spodId);
			haxe_Log::trace("microbe.TagManager.getTags" . $tags, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 154, "className" => "microbe.Api", "methodName" => "tags")));
			php_Lib::hprint(haxe_Serializer::run($tags));
		}break;
		default:{
			php_Lib::hprint("ooups");
		}break;
		}
	}
	public function test($arg) {
		php_Lib::hprint($arg);
	}
	public function trigger($_voName, $functionName, $params) {
		$instance = $this->createInstance($this->voPackage . $_voName);
		php_Lib::hprint(Reflect::callMethod($instance, $functionName, $params));
	}
	public function getClassMap() {
		$cmap = php_Web::getParams()->get("map");
		$this->map = haxe_Unserializer::run($cmap);
		return $this->map;
	}
	public function read($_vo, $id, $offset) {
		php_Lib::hprint("pop" . $_vo);
	}
	public function getOne($_vo, $id) {
		return $this->getManager($_vo)->unsafeGet($id, null);
	}
	public function getLast($_vo) {
		$all = null;
		try {
			$all = $this->getManager($_vo)->all(null);
		}catch(Exception $»e) {
			$_ex_ = ($»e instanceof HException) ? $»e->e : $»e;
			if(is_string($msg = $_ex_)){
				haxe_Log::trace("Error occurred: " . $msg, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 204, "className" => "microbe.Api", "methodName" => "getLast")));
			} else throw $»e;;
		}
		if(_hx_len($all) > 0) {
			haxe_Log::trace("micrabeLast", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 210, "className" => "microbe.Api", "methodName" => "getLast")));
			return $all->last();
		} else {
			haxe_Log::trace("null", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 213, "className" => "microbe.Api", "methodName" => "getLast")));
			return null;
		}
	}
	public function getOneH($_vo, $id) {
		$spod = $this->getOne($_vo, $id);
		$out = new microbe_Output($spod, null);
		$compressed = haxe_Serializer::run($out->render());
		return $compressed;
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
	public function getAll($_vo) {
		$stringVo = $this->voPackage . $_vo;
		$manager = Reflect::field(Type::resolveClass($stringVo), "manager");
		$liste = $manager->all(true);
		return $liste;
	}
	public function getPages($vo, $offset) {
	}
	public function rec() {
		$this->getClassMap();
		$this->recClassMap();
	}
	public function recClassMap() {
		haxe_Log::trace("record" . $this->map->id, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 280, "className" => "microbe.Api", "methodName" => "recClassMap")));
		$voInstance = null;
		if($this->map->id !== null) {
			$voInstance = $this->getOne($this->map->voClass, $this->map->id);
			haxe_Log::trace("map.id=" . $this->map->id, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 284, "className" => "microbe.Api", "methodName" => "recClassMap")));
		} else {
			$voInstance = Type::createInstance(Type::resolveClass($this->voPackage . $this->map->voClass), new _hx_array(array()));
		}
		haxe_Log::trace("after", _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 289, "className" => "microbe.Api", "methodName" => "recClassMap")));
		$creator = new microbe_MicroCreator();
		$creator->source = $this->map->fields;
		$creator->data = $voInstance;
		$fullSpod = $creator->record();
		haxe_Log::trace("beforeRec=" . $fullSpod, _hx_anonymous(array("fileName" => "Api.hx", "lineNumber" => 296, "className" => "microbe.Api", "methodName" => "recClassMap")));
		if(_hx_field($fullSpod, "id") === null) {
			$fullSpod->insert();
		} else {
			$fullSpod->update();
		}
	}
	public function delete($voName, $id) {
		$spodadelete = $this->getManager($voName)->unsafeGet($id, null);
		$spodadelete->delete();
	}
	public function getManager($_vo) {
		$stringVo = $this->voPackage . $_vo;
		return Reflect::field(Type::resolveClass($stringVo), "manager");
	}
	public function createInstance($_vo) {
		return Type::createInstance(Type::resolveClass($_vo), new _hx_array(array()));
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
	static $__rtti = "<class path=\"microbe.Api\" params=\"\">\x0A\x09<implements path=\"haxe.rtti.Infos\"/>\x0A\x09<map><c path=\"microbe.ClassMap\"/></map>\x0A\x09<voPackage><c path=\"String\"/></voPackage>\x0A\x09<cnx><c path=\"sys.db.Connection\"/></cnx>\x0A\x09<rootSpod><c path=\"microbe.vo.Spodable\"/></rootSpod>\x0A\x09<_xml set=\"method\" line=\"61\"><f a=\"data\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></_xml>\x0A\x09<_json set=\"method\" line=\"64\"><f a=\"data\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></_json>\x0A\x09<spodByTag public=\"1\" set=\"method\" line=\"76\"><f a=\"s\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></spodByTag>\x0A\x09<recTag public=\"1\" set=\"method\" line=\"90\"><f a=\"tag:spod:spod_id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></recTag>\x0A\x09<dissociateTag public=\"1\" set=\"method\" line=\"104\"><f a=\"tag:spod:spod_id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></dissociateTag>\x0A\x09<associateTag public=\"1\" set=\"method\" line=\"108\"><f a=\"tag:spod:spodId\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></associateTag>\x0A\x09<tags public=\"1\" set=\"method\" line=\"115\"><f a=\"\"><e path=\"Void\"/></f></tags>\x0A\x09<test public=\"1\" set=\"method\" line=\"163\"><f a=\"arg\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></test>\x0A\x09<trigger public=\"1\" set=\"method\" line=\"168\"><f a=\"_voName:functionName:?params\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Array\"><c path=\"String\"/></c>\x0A\x09<d/>\x0A</f></trigger>\x0A\x09<getClassMap set=\"method\" line=\"179\"><f a=\"\"><c path=\"microbe.ClassMap\"/></f></getClassMap>\x0A\x09<read public=\"1\" set=\"method\" line=\"185\"><f a=\"_vo:?id:?offset\">\x0A\x09<c path=\"String\"/>\x0A\x09<t path=\"microbe.Vo_Id\"/>\x0A\x09<t path=\"microbe.Offset\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></read>\x0A\x09<getOne public=\"1\" set=\"method\" line=\"190\"><f a=\"_vo:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></getOne>\x0A\x09<getLast public=\"1\" set=\"method\" line=\"195\"><f a=\"_vo\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></getLast>\x0A\x09<getOneH public=\"1\" set=\"method\" line=\"219\"><f a=\"_vo:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"String\"/>\x0A</f></getOneH>\x0A\x09<getAllorded public=\"1\" set=\"method\" line=\"228\"><f a=\"_vo\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getAllorded>\x0A\x09<getAll public=\"1\" set=\"method\" line=\"258\"><f a=\"_vo\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getAll>\x0A\x09<getPages set=\"method\" line=\"266\"><f a=\"vo:offset\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></getPages>\x0A\x09<rec public=\"1\" set=\"method\" line=\"274\"><f a=\"\"><e path=\"Void\"/></f></rec>\x0A\x09<recClassMap set=\"method\" line=\"279\"><f a=\"\"><e path=\"Void\"/></f></recClassMap>\x0A\x09<delete public=\"1\" set=\"method\" line=\"304\"><f a=\"voName:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></delete>\x0A\x09<getManager set=\"method\" line=\"311\"><f a=\"_vo\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"sys.db.Manager\"><c path=\"sys.db.Object\"/></c>\x0A</f></getManager>\x0A\x09<createInstance set=\"method\" line=\"318\"><f a=\"_vo\">\x0A\x09<t path=\"microbe.VoName\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></createInstance>\x0A\x09<new public=\"1\" set=\"method\" line=\"53\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'microbe.Api'; }
}
