<?php

class haxigniter_server_libraries_DatabaseDriver extends Enum {
	public static $mysql;
	public static $other;
	public static $sqlite;
	public static $__constructors = array(0 => 'mysql', 2 => 'other', 1 => 'sqlite');
	}
haxigniter_server_libraries_DatabaseDriver::$mysql = new haxigniter_server_libraries_DatabaseDriver("mysql", 0);
haxigniter_server_libraries_DatabaseDriver::$other = new haxigniter_server_libraries_DatabaseDriver("other", 2);
haxigniter_server_libraries_DatabaseDriver::$sqlite = new haxigniter_server_libraries_DatabaseDriver("sqlite", 1);
