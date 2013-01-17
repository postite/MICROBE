<?php

class microbe_backof_Login extends microbe_controllers_GenericController implements haxigniter_server_Controller{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
		$this->url = new haxigniter_server_libraries_Url($this->configuration);
	}}
	public function success($result) {
		$this->trace("result.next=" . Std::string($result), null, _hx_anonymous(array("fileName" => "Login.hx", "lineNumber" => 127, "className" => "microbe.backof.Login", "methodName" => "success")));
		$this->defaultAssign();
		$formulaire2 = new microbe_form_Form("cool", null, null);
		$this->session->user = $result;
		$formulaire2->submitButton = new microbe_form_elements_Button("continuer", "continuer", "continuer", null, null);
		$formulaire2->action = $this->url->siteUrl(null, null) . "/pipo/";
		$this->view->assign("content", $formulaire2);
		$this->view->assign("commentaire", "merci de vous etre identifie ");
		$this->view->display("back/design.html");
	}
	public function erreur($param = null) {
		haxe_Log::trace("errur" . $param, _hx_anonymous(array("fileName" => "Login.hx", "lineNumber" => 111, "className" => "microbe.backof.Login", "methodName" => "erreur")));
		$formulaire = $this->creeForm();
		$formulaire->populateElements();
		$this->defaultAssign();
		$this->view->assign("content", $formulaire);
		$this->view->assign("commentaire", "erreur d'identification");
		$this->view->display("back/design.html");
	}
	public function checkid($pop = null) {
		$formulaire = $this->creeForm();
		$formulaire->populateElements();
		$this->defaultAssign();
		$this->view->assign("content", $formulaire);
		$result = $this->db->query("SELECT * FROM user WHERE nom LIKE '" . $formulaire->getValueOf("login") . "' AND mdp LIKE '" . $formulaire->getValueOf("mdp") . "'", null, _hx_anonymous(array("fileName" => "Login.hx", "lineNumber" => 96, "className" => "microbe.backof.Login", "methodName" => "checkid")));
		if($result->getLength() > 0) {
			$u = $result->next();
			$this->success($u);
		} else {
			$this->erreur("pop=" . $pop);
		}
	}
	public function index() {
		$formulaire = $this->creeForm();
		$formulaire->action = $this->url->siteUrl(null, null) . "/login/checkid/pop";
		$this->defaultAssign();
		$this->view->assign("content", $formulaire);
		$this->view->assign("commentaire", "rien");
		$this->view->display("back/design.html");
	}
	public function creeForm() {
		$formulaire = new microbe_form_Form("logForm", null, null);
		$formulaire->addElement(new microbe_form_elements_Input("login", "identifiant", null, null, null, null), null);
		$formulaire->addElement(new microbe_form_elements_Input("mdp", "mot de passe", null, null, null, null), null);
		$bouton = new microbe_form_elements_Button("submit", "soumettre", "soumettre", null, null);
		$formulaire->setSubmitButton($bouton);
		return $formulaire;
	}
	public function defaultAssign() {
		$this->view->assign("customLogo", null);
		$this->view->assign("page", null);
		$this->view->assign("link", $this->url->siteUrl(null, null));
		$this->view->assign("backpage", $this->url->siteUrl(null, null) . "/pipo");
		$this->view->assign("title", "microbe admin");
		$this->view->assign("localClass", "login");
		$this->view->assign("custom", true);
		$this->view->assign("menu", null);
		$this->view->assign("currentVo", null);
		$this->view->assign("jsScript", null);
		$this->view->assign("jsLib", null);
		$this->view->assign("titre", "Microbe admin");
		$this->view->assign("scope", $this);
		$this->view->assign("contenttype", null);
	}
	public $url;
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
	static $__rtti = "<class path=\"microbe.backof.Login\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<implements path=\"haxigniter.server.Controller\"/>\x0A\x09<url><c path=\"haxigniter.server.libraries.Url\"/></url>\x0A\x09<defaultAssign set=\"method\" line=\"40\"><f a=\"\"><e path=\"Void\"/></f></defaultAssign>\x0A\x09<creeForm set=\"method\" line=\"67\"><f a=\"\"><c path=\"microbe.form.Form\"/></f></creeForm>\x0A\x09<index public=\"1\" set=\"method\" line=\"75\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<checkid public=\"1\" set=\"method\" line=\"87\"><f a=\"?pop\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></checkid>\x0A\x09<erreur public=\"1\" set=\"method\" line=\"110\"><f a=\"?param\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></erreur>\x0A\x09<success public=\"1\" set=\"method\" line=\"121\"><f a=\"result\">\x0A\x09<c path=\"vo.UserVo\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></success>\x0A\x09<new public=\"1\" set=\"method\" line=\"34\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'microbe.backof.Login'; }
}
