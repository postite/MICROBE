<?php

class controllers_Login extends microbe_backof_Login {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
	}}
	public function index() {
		parent::index();
	}
	public function checkid($param) {
		parent::checkid(null);
	}
	public function success($result) {
		parent::success($result);
	}
	public function erreur($p) {
		parent::erreur($p);
	}
	static $__rtti = "<class path=\"controllers.Login\" params=\"\">\x0A\x09<extends path=\"microbe.backof.Login\"/>\x0A\x09<index public=\"1\" set=\"method\" line=\"17\" override=\"1\"><f a=\"\"><e path=\"Void\"/></f></index>\x0A\x09<checkid public=\"1\" set=\"method\" line=\"21\" override=\"1\"><f a=\"?param\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></checkid>\x0A\x09<success public=\"1\" set=\"method\" line=\"25\" override=\"1\"><f a=\"result\">\x0A\x09<c path=\"vo.UserVo\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></success>\x0A\x09<erreur public=\"1\" set=\"method\" line=\"28\" override=\"1\"><f a=\"?p\">\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></erreur>\x0A\x09<new public=\"1\" set=\"method\" line=\"9\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.Login'; }
}
