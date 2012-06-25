<?php

class haxigniter_server_session_SessionObject {
	public function __construct() {
		;
	}
	public $flashVar;
	public function setFlash($value) {
		haxigniter_server_session_SessionObject::setObjFlash(Type::getClass($this), $value);
		$this->flashVar = $value;
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
	static $session;
	static $sessionName = "_haxigniter_session_";
	static $flashName = "_flash";
	static function restore($session, $classType, $classArgs) {
		if(haxigniter_server_session_SessionObject::$session !== null && haxigniter_server_session_SessionObject::$session !== $session) {
			throw new HException("Cannot change session handler for SessionObject.");
		} else {
			haxigniter_server_session_SessionObject::$session = $session;
		}
		$object = haxigniter_server_session_SessionObject::objectName($classType);
		if(!$session->exists($object)) {
			$session->set($object, Type::createInstance($classType, (($classArgs === null) ? new _hx_array(array()) : $classArgs)));
		}
		$output = $session->get($object);
		if(_hx_has_field($output, "flashVar")) {
			$output->{"flashVar"} = haxigniter_server_session_SessionObject::getObjFlash($classType);
			haxigniter_server_session_SessionObject::setObjFlash($classType, null);
		}
		return $output;
	}
	static function objectName($classType) {
		return haxigniter_server_session_SessionObject::$sessionName . Type::getClassName($classType);
	}
	static function setObjFlash($classType, $value) {
		$object = haxigniter_server_session_SessionObject::objectName($classType);
		haxigniter_server_session_SessionObject::$session->set($object . haxigniter_server_session_SessionObject::$flashName, $value);
	}
	static function getObjFlash($classType) {
		$object = haxigniter_server_session_SessionObject::objectName($classType);
		return ((haxigniter_server_session_SessionObject::$session->exists($object . haxigniter_server_session_SessionObject::$flashName)) ? haxigniter_server_session_SessionObject::$session->get($object . haxigniter_server_session_SessionObject::$flashName) : null);
	}
	static $__properties__ = array("set_flashVar" => "setFlash");
	function __toString() { return 'haxigniter.server.session.SessionObject'; }
}
