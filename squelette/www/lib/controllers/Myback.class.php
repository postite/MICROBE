<?php

class controllers_Myback extends microbe_backof_Back {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct(new controllers_Login());
		$user = new vo_UserVo();
		$user->nom = "pop";
		$this->view->assign("contenttype", null);
	}}
	public function index() {
		$this->defaultAssign();
		$this->view->assign("content", "popopo");
		$this->view->display("back/design.mtt");
	}
	public function defaultAssign() {
		$this->view->assign("page", null);
		$this->view->assign("link", $this->url->siteUrl(null, null));
		$this->view->assign("backpage", $this->url->siteUrl(null, null) . "/myback");
		$this->view->assign("titre", "administrationMelle");
		$this->view->assign("scope", $this);
	}
	static $__rtti = "<class path=\"controllers.Myback\" params=\"\">\x0A\x09<extends path=\"microbe.backof.Back\"/>\x0A\x09<defaultAssign public=\"1\" set=\"method\" line=\"44\"><f a=\"\"><e path=\"Void\"/></f></defaultAssign>\x0A\x09<index public=\"1\" set=\"method\" line=\"65\" override=\"1\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<new public=\"1\" set=\"method\" line=\"28\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Myback'; }
}
