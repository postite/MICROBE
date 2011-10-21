package haxigniter.server.session;

interface Session
{
	function start() : Void;
	function close() : Void;
	function clear() : Void;
	
	function get(name : String) : Dynamic;
	function set(name : String, value : Dynamic) : Void;
	function exists(name : String) : Bool;
	function remove(name : String) : Void;
}
