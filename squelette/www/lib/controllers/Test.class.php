<?php

class controllers_Test extends microbe_controllers_GenericController {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
		$this->url = new haxigniter_server_libraries_Url($this->configuration);
	}}
	public $url;
	public function creeForm() {
		$formulaire = new microbe_form_Form("logForm", null, null);
		$formulaire->addElement(new microbe_form_elements_Input("login", "identifiant", null, null, null, null), null);
		$formulaire->addElement(new microbe_form_elements_Input("mdp", "mot de passe", null, null, null, null), null);
		$bouton = new microbe_form_elements_Button("submit", "soumettre", "soumettre", null, null);
		$formulaire->setSubmitButton($bouton);
		return $formulaire;
	}
	public function index() {
		$formulaire = $this->creeForm();
		$formulaire->action = $this->url->siteUrl(null, null) . "/test/checkid/";
		$this->view->assign("content", $formulaire);
		$this->view->assign("content", $formulaire);
		$this->view->display("test/logintest.html");
	}
	public function checkid() {
		$formulaire = $this->creeForm();
		$formulaire->populateElements();
		haxe_Log::trace("olo" . php_Web::getParams(), _hx_anonymous(array("fileName" => "Test.hx", "lineNumber" => 46, "className" => "controllers.Test", "methodName" => "checkid")));
		if(null == $formulaire->getElements()) throw new HException('null iterable');
		$»it = $formulaire->getElements()->iterator();
		while($»it->hasNext()) {
			$elem = $»it->next();
			haxe_Log::trace("elem=" . $elem->value, _hx_anonymous(array("fileName" => "Test.hx", "lineNumber" => 54, "className" => "controllers.Test", "methodName" => "checkid")));
		}
		$this->view->assign("content", $formulaire);
		$this->view->assign("content", $formulaire);
		$this->view->display("test/logintest.html");
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
	static $__rtti = "<class path=\"controllers.Test\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<url><c path=\"haxigniter.server.libraries.Url\"/></url>\x0A\x09<creeForm set=\"method\" line=\"22\"><f a=\"\"><c path=\"microbe.form.Form\"/></f></creeForm>\x0A\x09<index public=\"1\" set=\"method\" line=\"30\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<checkid public=\"1\" set=\"method\" line=\"43\"><f a=\"\"><e path=\"Void\"/></f></checkid>\x0A\x09<new public=\"1\" set=\"method\" line=\"15\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Test'; }
}
