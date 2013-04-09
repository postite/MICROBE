<?php

class microbe_form_elements_ButtonType extends Enum {
	public static $BUTTON;
	public static $RESET;
	public static $SUBMIT;
	public static $__constructors = array(1 => 'BUTTON', 2 => 'RESET', 0 => 'SUBMIT');
	}
microbe_form_elements_ButtonType::$BUTTON = new microbe_form_elements_ButtonType("BUTTON", 1);
microbe_form_elements_ButtonType::$RESET = new microbe_form_elements_ButtonType("RESET", 2);
microbe_form_elements_ButtonType::$SUBMIT = new microbe_form_elements_ButtonType("SUBMIT", 0);
