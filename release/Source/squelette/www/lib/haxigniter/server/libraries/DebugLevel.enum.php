<?php

class haxigniter_server_libraries_DebugLevel extends Enum {
	public static $error;
	public static $info;
	public static $off;
	public static $verbose;
	public static $warning;
	public static $__constructors = array(1 => 'error', 3 => 'info', 0 => 'off', 4 => 'verbose', 2 => 'warning');
	}
haxigniter_server_libraries_DebugLevel::$error = new haxigniter_server_libraries_DebugLevel("error", 1);
haxigniter_server_libraries_DebugLevel::$info = new haxigniter_server_libraries_DebugLevel("info", 3);
haxigniter_server_libraries_DebugLevel::$off = new haxigniter_server_libraries_DebugLevel("off", 0);
haxigniter_server_libraries_DebugLevel::$verbose = new haxigniter_server_libraries_DebugLevel("verbose", 4);
haxigniter_server_libraries_DebugLevel::$warning = new haxigniter_server_libraries_DebugLevel("warning", 2);
