<?php

class haxigniter_server_libraries_CurlMisc {
	public function __construct(){}
	static $CLOSEPOLICY_LEAST_RECENTLY_USED = 2;
	static $CLOSEPOLICY_OLDEST = 1;
	static $PROXY_HTTP = 0;
	static $PROXY_SOCKS5 = 5;
	static $HTTP_VERSION_1_0 = 1;
	static $HTTP_VERSION_1_1 = 2;
	static $HTTP_VERSION_NONE = 0;
	static $TIMECOND_IFMODSINCE = 1;
	function __toString() { return 'haxigniter.server.libraries.CurlMisc'; }
}
