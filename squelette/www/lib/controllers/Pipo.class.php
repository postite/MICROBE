<?php

class controllers_Pipo extends microbe_backof_Back {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct(new controllers_Login());
		$this->jsScript = new HList();
		$this->jsLib = new microbe_tools_JSLIB();
		$this->generator = new microbe_FormGenerator();
		microbe_FormGenerator::$voPackage = "vo.";
		$this->chemins = "popopop";
		$user = new vo_UserVo();
		$user->nom = "pop";
		sys_db_Manager::cleanup();
		sys_db_Manager::setConnection($this->db->getConnection());
		sys_db_Manager::initialize();
		$this->api = new microbe_Api();
		$this->view->assign("contenttype", null);
	}}
	public function reorder($voName) {
		$manager = Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $voName)->manager;
		$table = $manager->dbInfos()->name;
		haxe_Log::trace("currentVo" . $voName, _hx_anonymous(array("fileName" => "Pipo.hx", "lineNumber" => 293, "className" => "controllers.Pipo", "methodName" => "reorder")));
		$data = php_Web::getParams()->get("orderedList");
		$tab = haxe_Unserializer::run($data);
		{
			$_g1 = 0; $_g = $tab->length;
			while($_g1 < $_g) {
				$i = $_g1++;
				$this->db->query("UPDATE " . $table . " SET poz = " . _hx_string_rec($i, "") . " WHERE id = " . _hx_string_rec($tab[$i], "") . " ", null, _hx_anonymous(array("fileName" => "Pipo.hx", "lineNumber" => 316, "className" => "controllers.Pipo", "methodName" => "reorder")));
				unset($i);
			}
		}
		php_Lib::hprint("lkl");
	}
	public function delete($voName, $id) {
		$this->api->delete($voName, $id);
		$this->nav($voName);
	}
	public function rec() {
		$this->api->rec();
		return;
	}
	public function ajoute($voName) {
		haxe_Log::trace("ajoute", _hx_anonymous(array("fileName" => "Pipo.hx", "lineNumber" => 267, "className" => "controllers.Pipo", "methodName" => "ajoute")));
		$this->generator->generateComplexClassMapForm($voName, null);
		$this->jsLib->addOnce(controllers_Pipo::$backjs);
		$this->jsScript->add(controllers_Pipo::$backInstance . ".instance.setClassMap('" . $this->generator->getCompressedClassMap() . "');");
		$this->defaultAssign();
		$this->view->assign("currentVo", $voName);
		$this->view->assign("content", $this->generator->render());
		$this->view->display("back/design.html");
	}
	public function traduit($id, $voName, $lang = null) {
		$data = $this->api->getOne($voName, $id);
		$clone = config_Config::$hclone;
		$traduction_id = _hx_deref(($data))->getTrad($lang);
		$newData = null;
		if($traduction_id === 0) {
			if($clone) {
				$newData = $data;
				_hx_deref(($newData))->id = null;
			} else {
				$newData = Type::createInstance(Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $voName), new _hx_array(array()));
			}
			_hx_deref(($newData))->id_ref = $id;
			_hx_deref(($newData))->lang = $lang;
			$this->generator->generateComplexClassMapForm($voName, $newData);
		} else {
			$this->generator->generateComplexClassMapForm($voName, $this->api->getOne($voName, $traduction_id));
		}
		$this->jsLib->addOnce(controllers_Pipo::$backjs);
		$this->jsScript->add(controllers_Pipo::$backInstance . ".instance.setClassMap('" . $this->generator->getCompressedClassMap() . "');");
		$this->defaultAssign();
		$this->view->assign("linkfr", $this->url->siteUrl(null, null) . "/pipo/choix/" . _hx_string_rec($data->id, "") . "/" . $voName);
		$this->view->assign("linken", $this->url->siteUrl(null, null) . "/pipo/traduit/" . _hx_string_rec($data->id, "") . "/" . $voName . "/en");
		$this->view->assign("currentVo", $voName);
		$this->view->assign("lang", "en");
		$this->view->assign("tradContent", $this->generator->renderForm());
		$this->view->assign("tradCloud", $this->generator->renderCloud());
		$this->view->assign("content", $this->view->render("back/TradContent.html"));
		$this->view->display("back/design.html");
	}
	public function addCollectServerItem() {
		$params = php_Web::getParams();
		$collectionName = $params->get("name");
		$hierarchy = _hx_explode("_", $collectionName);
		$voName = $hierarchy[0];
		$field = $hierarchy[1];
		$sousVoName = $hierarchy[2];
		$voParent = $params->get("voParent");
		$parentId = Std::parseInt($params->get("voParentId"));
		$graine = Std::parseInt($params->get("graine"));
		$retour = microbe_factoryType_CollectionBehaviour::creeEmptyCollection($voName, _hx_anonymous(array("classe" => microbe_controllers_GenericController::$appConfig->voPackage . $sousVoName, "type" => microbe_form_InstanceType::$collection, "champs" => null)), $field, $graine);
		php_Lib::hprint(haxe_Serializer::run($retour));
	}
	public function addCollectItem() {
		$params = php_Web::getParams();
		$voName = $params->get("voName");
		$voParent = $params->get("voParent");
		$parentId = Std::parseInt($params->get("voParentId"));
		$newCollectItem = Type::createInstance(Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $voName), new _hx_array(array()));
		$parentClass = Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $voParent);
		$parentSpod = Type::createInstance($parentClass, new _hx_array(array()));
		$Pmanager = Reflect::field($parentClass, "manager");
		$parent = $Pmanager->unsafeGet($parentId, null);
		Reflect::callMethod($newCollectItem, "set_rel", new _hx_array(array($parent)));
		$newCollectItem->insert();
		$newID = $newCollectItem->id;
		$creator = new microbe_MicroCreator();
		$microFieldItem = $creator->justGet($voName, _hx_deref(($newCollectItem))->getFormule(), null);
		$microFieldItem->id = $newID;
		$microFieldItem->voName = $voName;
		$microFieldItem->type = microbe_form_InstanceType::$collection;
		$XmicroFieldItem = haxe_Serializer::run($microFieldItem);
		php_Lib::hprint($XmicroFieldItem);
	}
	public function getPage($voName) {
		return $this->api->getOne($voName, 1);
	}
	public function index() {
		haxe_Log::trace("index", _hx_anonymous(array("fileName" => "Pipo.hx", "lineNumber" => 158, "className" => "controllers.Pipo", "methodName" => "index")));
		$this->jsLib->add(controllers_Pipo::$backjs);
		$this->defaultAssign();
		$this->view->assign("content", "popopo");
		$this->view->display("back/design.html");
		haxe_Log::trace("after", _hx_anonymous(array("fileName" => "Pipo.hx", "lineNumber" => 164, "className" => "controllers.Pipo", "methodName" => "index")));
	}
	public function getMenu() {
		$navig = new Nav();
		return $navig->items;
	}
	public function getVoList($voName) {
		return $this->api->getSearch($voName, _hx_anonymous(array("lang" => "fr")));
	}
	public function choix($id = null, $voName) {
		haxe_Log::trace("choix id=" . _hx_string_rec($id, "") . " vo=" . $voName, _hx_anonymous(array("fileName" => "Pipo.hx", "lineNumber" => 105, "className" => "controllers.Pipo", "methodName" => "choix")));
		$data = null;
		if($id === null) {
			$data = $this->api->getLast($voName);
		} else {
			$data = $this->api->getOne($voName, $id);
		}
		if(Std::is($data, _hx_qtype("microbe.vo.Page"))) {
			$this->view->assign("contenttype", "page");
		}
		$this->generator->generateComplexClassMapForm($voName, $data);
		$this->jsLib->addOnce(microbe_controllers_GenericController::$appConfig->jsPath . "jquery-ui-1.8.14.custom.min.js");
		$this->jsLib->addOnce(controllers_Pipo::$backjs);
		$this->jsScript->add(controllers_Pipo::$backInstance . ".instance.setClassMap('" . $this->generator->getCompressedClassMap() . "');");
		$this->defaultAssign();
		$this->view->assign("currentVo", $voName);
		if(Std::is($data, _hx_qtype("vo.Traductable"))) {
			$this->view->assign("lang", "fr");
			$this->view->assign("linkfr", $this->url->siteUrl(null, null) . "/pipo/choix/" . _hx_string_rec($data->id, "") . "/" . $voName);
			$id_ref = _hx_deref(($data))->getTrad("en");
			if($id_ref === null) {
			}
			$this->view->assign("linken", $this->url->siteUrl(null, null) . "/pipo/traduit/" . _hx_string_rec($data->id, "") . "/" . $voName . "/en");
			$this->view->assign("tradContent", $this->generator->renderForm());
			$this->view->assign("tradCloud", $this->generator->renderCloud());
			$this->view->assign("content", $this->view->render("back/TradContent.html"));
		} else {
			$this->view->assign("content", $this->generator->render());
		}
		$this->view->display("back/design.html");
	}
	public function nav($voName) {
		haxe_Log::trace("voName=" . $voName, _hx_anonymous(array("fileName" => "Pipo.hx", "lineNumber" => 90, "className" => "controllers.Pipo", "methodName" => "nav")));
		$this->defaultAssign();
		$this->view->assign("currentVo", $voName);
		$content = "";
		$this->choix(null, $voName);
		return;
		$this->view->assign("content", $content);
		$this->view->display("back/design.html");
		return;
	}
	public function defaultAssign() {
		$this->view->assign("page", null);
		$this->view->assign("link", $this->url->siteUrl(null, null));
		$this->view->assign("backpage", $this->url->siteUrl(null, null) . "/pipo");
		$this->view->assign("titre", "microbe admin");
		$this->jsLib->addOnce(controllers_Pipo::$backjs);
		$this->jsLib->addOnce(microbe_controllers_GenericController::$appConfig->jsPath . "jquery-ui-1.8.14.custom.min.js");
		$this->view->assign("menu", $this->getMenu());
		$this->view->assign("contentype", null);
		$this->view->assign("currentVo", null);
		$this->view->assign("jsScript", $this->jsScript);
		$this->view->assign("jsLib", $this->jsLib);
		$this->view->assign("title", "Microbe admin");
		$this->view->assign("scope", $this);
	}
	public $generator;
	public $jsLib;
	public $jsScript;
	public $api;
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
	static $__rtti = "<class path=\"controllers.Pipo\" params=\"\">\x0A\x09<extends path=\"microbe.backof.Back\"/>\x0A\x09<backjs public=\"1\" line=\"24\" static=\"1\"><c path=\"String\"/></backjs>\x0A\x09<backInstance public=\"1\" line=\"25\" static=\"1\"><c path=\"String\"/></backInstance>\x0A\x09<api public=\"1\"><c path=\"microbe.Api\"/></api>\x0A\x09<jsScript public=\"1\"><c path=\"List\"><c path=\"String\"/></c></jsScript>\x0A\x09<jsLib public=\"1\"><c path=\"microbe.tools.JSLIB\"/></jsLib>\x0A\x09<generator><c path=\"microbe.FormGenerator\"/></generator>\x0A\x09<defaultAssign public=\"1\" set=\"method\" line=\"66\"><f a=\"\"><e path=\"Void\"/></f></defaultAssign>\x0A\x09<nav public=\"1\" set=\"method\" line=\"89\"><f a=\"voName\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></nav>\x0A\x09<choix public=\"1\" set=\"method\" line=\"103\"><f a=\"?id:voName\">\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></choix>\x0A\x09<getVoList public=\"1\" set=\"method\" line=\"146\"><f a=\"voName\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"List\"><c path=\"microbe.vo.Spodable\"/></c>\x0A</f></getVoList>\x0A\x09<getMenu public=\"1\" set=\"method\" line=\"152\"><f a=\"\"><c path=\"List\"><t path=\"microbe.backof.NavItem\"/></c></f></getMenu>\x0A\x09<index public=\"1\" set=\"method\" line=\"157\" override=\"1\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<getPage public=\"1\" set=\"method\" line=\"170\"><f a=\"voName\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"microbe.vo.Spodable\"/>\x0A</f></getPage>\x0A\x09<addCollectItem public=\"1\" set=\"method\" line=\"173\"><f a=\"\"><e path=\"Void\"/></f></addCollectItem>\x0A\x09<addCollectServerItem public=\"1\" set=\"method\" line=\"203\"><f a=\"\"><e path=\"Void\"/></f></addCollectServerItem>\x0A\x09<traduit public=\"1\" set=\"method\" line=\"224\"><f a=\"id:voName:?lang\">\x0A\x09<c path=\"Int\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></traduit>\x0A\x09<ajoute public=\"1\" set=\"method\" line=\"266\"><f a=\"voName\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></ajoute>\x0A\x09<rec public=\"1\" set=\"method\" line=\"282\"><f a=\"\"><e path=\"Void\"/></f></rec>\x0A\x09<delete public=\"1\" set=\"method\" line=\"286\"><f a=\"voName:id\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"Int\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></delete>\x0A\x09<reorder public=\"1\" set=\"method\" line=\"290\"><f a=\"voName\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></reorder>\x0A\x09<new public=\"1\" set=\"method\" line=\"32\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	static $backjs;
	static $backInstance = "microbe.jsTools.BackJS";
	function __toString() { return 'controllers.Pipo'; }
}
controllers_Pipo::$backjs = microbe_controllers_GenericController::$appConfig->jsPath . microbe_controllers_GenericController::$appConfig->backjs;
