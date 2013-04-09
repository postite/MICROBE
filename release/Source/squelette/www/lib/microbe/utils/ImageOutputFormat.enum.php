<?php

class microbe_utils_ImageOutputFormat extends Enum {
	public static $BMP;
	public static $GIF;
	public static $JPG;
	public static $PNG;
	public static $__constructors = array(3 => 'BMP', 2 => 'GIF', 0 => 'JPG', 1 => 'PNG');
	}
microbe_utils_ImageOutputFormat::$BMP = new microbe_utils_ImageOutputFormat("BMP", 3);
microbe_utils_ImageOutputFormat::$GIF = new microbe_utils_ImageOutputFormat("GIF", 2);
microbe_utils_ImageOutputFormat::$JPG = new microbe_utils_ImageOutputFormat("JPG", 0);
microbe_utils_ImageOutputFormat::$PNG = new microbe_utils_ImageOutputFormat("PNG", 1);
