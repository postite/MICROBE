<?php

class microbe_utils_ImageFilter extends Enum {
	public static $BRIGHTNESS;
	public static $COLORIZE;
	public static $CONTRAST;
	public static $EDGEDETECT;
	public static $EMBOSS;
	public static $GAUSSIAN_BLUR;
	public static $GRAYSCALE;
	public static $MEAN_REMOVAL;
	public static $NEGATE;
	public static $SELECTIVE_BLUR;
	public static $SMOOTH;
	public static $__constructors = array(2 => 'BRIGHTNESS', 4 => 'COLORIZE', 3 => 'CONTRAST', 5 => 'EDGEDETECT', 6 => 'EMBOSS', 7 => 'GAUSSIAN_BLUR', 1 => 'GRAYSCALE', 9 => 'MEAN_REMOVAL', 0 => 'NEGATE', 8 => 'SELECTIVE_BLUR', 10 => 'SMOOTH');
	}
microbe_utils_ImageFilter::$BRIGHTNESS = new microbe_utils_ImageFilter("BRIGHTNESS", 2);
microbe_utils_ImageFilter::$COLORIZE = new microbe_utils_ImageFilter("COLORIZE", 4);
microbe_utils_ImageFilter::$CONTRAST = new microbe_utils_ImageFilter("CONTRAST", 3);
microbe_utils_ImageFilter::$EDGEDETECT = new microbe_utils_ImageFilter("EDGEDETECT", 5);
microbe_utils_ImageFilter::$EMBOSS = new microbe_utils_ImageFilter("EMBOSS", 6);
microbe_utils_ImageFilter::$GAUSSIAN_BLUR = new microbe_utils_ImageFilter("GAUSSIAN_BLUR", 7);
microbe_utils_ImageFilter::$GRAYSCALE = new microbe_utils_ImageFilter("GRAYSCALE", 1);
microbe_utils_ImageFilter::$MEAN_REMOVAL = new microbe_utils_ImageFilter("MEAN_REMOVAL", 9);
microbe_utils_ImageFilter::$NEGATE = new microbe_utils_ImageFilter("NEGATE", 0);
microbe_utils_ImageFilter::$SELECTIVE_BLUR = new microbe_utils_ImageFilter("SELECTIVE_BLUR", 8);
microbe_utils_ImageFilter::$SMOOTH = new microbe_utils_ImageFilter("SMOOTH", 10);
