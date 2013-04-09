<?php

class microbe_utils_ImageLayerEffect extends Enum {
	public static $NORMAL;
	public static $OVERLAY;
	public static $REPLACE;
	public static $__constructors = array(1 => 'NORMAL', 2 => 'OVERLAY', 0 => 'REPLACE');
	}
microbe_utils_ImageLayerEffect::$NORMAL = new microbe_utils_ImageLayerEffect("NORMAL", 1);
microbe_utils_ImageLayerEffect::$OVERLAY = new microbe_utils_ImageLayerEffect("OVERLAY", 2);
microbe_utils_ImageLayerEffect::$REPLACE = new microbe_utils_ImageLayerEffect("REPLACE", 0);
