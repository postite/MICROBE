<?php

class microbe_ACTION extends Enum {
	public static $CREATE;
	public static $DELETE;
	public static $UPDATE;
	public static $__constructors = array(0 => 'CREATE', 2 => 'DELETE', 1 => 'UPDATE');
	}
microbe_ACTION::$CREATE = new microbe_ACTION("CREATE", 0);
microbe_ACTION::$DELETE = new microbe_ACTION("DELETE", 2);
microbe_ACTION::$UPDATE = new microbe_ACTION("UPDATE", 1);
