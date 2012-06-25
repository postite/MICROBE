<?php

class haxigniter_server_libraries_CurlInfo {
	public function __construct(){}
	static $EFFECTIVE_URL = 1;
	static $HTTP_CODE = 2;
	static $FILETIME = 14;
	static $TOTAL_TIME = 3;
	static $NAMELOOKUP_TIME = 4;
	static $CONNECT_TIME = 5;
	static $PRETRANSFER_TIME = 6;
	static $STARTTRANSFER_TIME = 17;
	static $REDIRECT_TIME = 19;
	static $REDIRECT_COUNT = 20;
	static $SIZE_UPLOAD = 7;
	static $SIZE_DOWNLOAD = 8;
	static $SPEED_DOWNLOAD = 9;
	static $SPEED_UPLOAD = 10;
	static $HEADER_SIZE = 11;
	static $REQUEST_SIZE = 12;
	static $SSL_VERIFYRESULT = 13;
	static $CONTENT_LENGTH_DOWNLOAD = 15;
	static $CONTENT_LENGTH_UPLOAD = 16;
	static $CONTENT_TYPE = 18;
	function __toString() { return 'haxigniter.server.libraries.CurlInfo'; }
}
