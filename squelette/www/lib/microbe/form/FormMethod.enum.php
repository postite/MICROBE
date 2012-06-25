<?php

class microbe_form_FormMethod extends Enum {
	public static $GET;
	public static $POST;
	public static $__constructors = array(0 => 'GET', 1 => 'POST');
	}
microbe_form_FormMethod::$GET = new microbe_form_FormMethod("GET", 0);
microbe_form_FormMethod::$POST = new microbe_form_FormMethod("POST", 1);
