<?php

class microbe_ERROR_TYPE extends Enum {
	public static $DOUBLON;
	public static $FATAL;
	public static $__constructors = array(0 => 'DOUBLON', 1 => 'FATAL');
	}
microbe_ERROR_TYPE::$DOUBLON = new microbe_ERROR_TYPE("DOUBLON", 0);
microbe_ERROR_TYPE::$FATAL = new microbe_ERROR_TYPE("FATAL", 1);
