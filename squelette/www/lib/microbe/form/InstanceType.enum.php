<?php

class microbe_form_InstanceType extends Enum {
	public static $collection;
	public static $dataElement;
	public static $formElement;
	public static $spodable;
	public static $__constructors = array(1 => 'collection', 3 => 'dataElement', 0 => 'formElement', 2 => 'spodable');
	}
microbe_form_InstanceType::$collection = new microbe_form_InstanceType("collection", 1);
microbe_form_InstanceType::$dataElement = new microbe_form_InstanceType("dataElement", 3);
microbe_form_InstanceType::$formElement = new microbe_form_InstanceType("formElement", 0);
microbe_form_InstanceType::$spodable = new microbe_form_InstanceType("spodable", 2);
