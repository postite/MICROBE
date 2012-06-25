<?php

class haxigniter_server_libraries_CurlAuth {
	public function __construct(){}
	static $ANY = -1;
	static $ANYSAFE = -2;
	static $BASIC = 1;
	static $DIGEST = 2;
	static $GSSNEGOTIATE = 4;
	static $NTLM = 8;
	static $FTPAUTH_DEFAULT = 0;
	static $FTPAUTH_SSL = 1;
	static $FTPAUTH_TLS = 2;
	function __toString() { return 'haxigniter.server.libraries.CurlAuth'; }
}
