<?php

class haxigniter_server_routing_DefaultRouter implements haxigniter_server_routing_Router{
	public function __construct() { 
	}
	public function createController($config, $url) {
		$request = new haxigniter_server_libraries_Request($config);
		$urlLib = new haxigniter_server_libraries_Url($config);
		$segments = $urlLib->split($url->path, null);
		return $request->createController($segments[0], null);
	}
	function __toString() { return 'haxigniter.server.routing.DefaultRouter'; }
}
