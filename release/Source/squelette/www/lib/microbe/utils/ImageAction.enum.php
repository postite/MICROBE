<?php

class microbe_utils_ImageAction extends Enum {
	public static $ASPECT;
	public static $CROP;
	public static $CUSTOM;
	public static $FIT;
	public static $RESIZE;
	public static $ROTATE;
	public static $SCALE;
	public static $__constructors = array(2 => 'ASPECT', 5 => 'CROP', 0 => 'CUSTOM', 1 => 'FIT', 3 => 'RESIZE', 6 => 'ROTATE', 4 => 'SCALE');
	}
microbe_utils_ImageAction::$ASPECT = new microbe_utils_ImageAction("ASPECT", 2);
microbe_utils_ImageAction::$CROP = new microbe_utils_ImageAction("CROP", 5);
microbe_utils_ImageAction::$CUSTOM = new microbe_utils_ImageAction("CUSTOM", 0);
microbe_utils_ImageAction::$FIT = new microbe_utils_ImageAction("FIT", 1);
microbe_utils_ImageAction::$RESIZE = new microbe_utils_ImageAction("RESIZE", 3);
microbe_utils_ImageAction::$ROTATE = new microbe_utils_ImageAction("ROTATE", 6);
microbe_utils_ImageAction::$SCALE = new microbe_utils_ImageAction("SCALE", 4);
