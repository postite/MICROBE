<?php

interface haxigniter_server_session_Session {
	function remove($name);
	function exists($name);
	function set($name, $value);
	function get($name);
	function clear();
	function close();
	function start();
}
