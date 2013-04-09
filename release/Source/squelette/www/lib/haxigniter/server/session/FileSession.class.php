<?php

class haxigniter_server_session_FileSession implements haxigniter_server_session_Session{
	public function __construct($savePath) { if(!php_Boot::$skip_constructor) {
		php_Session::setSavePath($savePath);
	}}
	public function remove($name) {
		php_Session::remove($name);
	}
	public function exists($name) {
		return php_Session::exists($name);
	}
	public function set($name, $value) {
		php_Session::set($name, $value);
	}
	public function get($name) {
		return php_Session::get($name);
	}
	public function clear() {
		session_unset();
	}
	public function close() {
		session_write_close();
	}
	public function start() {
		php_Session::start();
	}
	function __toString() { return 'haxigniter.server.session.FileSession'; }
}
