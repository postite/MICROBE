<?php

interface haxigniter_server_session_Session {
	function start();
	function close();
	function clear();
	function get($name);
	function set($name, $value);
	function exists($name);
	function remove($name);
}
