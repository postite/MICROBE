<?php

class microbe_utils_ImageProcessor {
	public function __construct($file) {
		if(!php_Boot::$skip_constructor) {
		$this->fileName = $file;
		$this->queue = new HList();
		$this->cache = true;
		$this->cacheFolder = ".cache";
		$this->forceNoCache = false;
		$this->saveAlpha = false;
		$this->quality = .8;
		$this->format = microbe_utils_ImageOutputFormat::$JPG;
		$this->outputFormat = $this->getFileFormat($file);
		$this->init();
	}}
	public $fileName;
	public $resource;
	public $queue;
	public $forceNoCache;
	public $cache;
	public $cacheFolder;
	public $quality;
	public $format;
	public $hash;
	public $dateModified;
	public $saveAlpha;
	public $mimeType;
	public $outputFormat;
	public function init() {
		$this->resource = microbe_utils_ImageProcessor_0($this);
		$this->mimeType = microbe_utils_ImageProcessor_1($this);
		if(_hx_field($this, "resource") === null) {
			throw new HException("Could not load image");
		}
	}
	public function getWidth() {
		return imagesx($this->resource);
	}
	public function getHeight() {
		return imagesy($this->resource);
	}
	public function queueFitSize($maxWidth, $maxHeight) {
		$this->queue->add(_hx_anonymous(array("type" => microbe_utils_ImageAction::$FIT, "maxWidth" => $maxWidth, "maxHeight" => $maxHeight)));
	}
	public function queueCropToAspect($w, $h) {
		$this->queue->add(_hx_anonymous(array("type" => microbe_utils_ImageAction::$ASPECT, "w" => $w, "h" => $h)));
	}
	public function queueCrop($x, $y, $width, $height) {
		$this->queue->add(_hx_anonymous(array("type" => microbe_utils_ImageAction::$CROP, "x" => $x, "y" => $y, "width" => $width, "height" => $height)));
	}
	public function queueResize($width, $height) {
		$this->queue->add(_hx_anonymous(array("type" => microbe_utils_ImageAction::$RESIZE, "width" => $width, "height" => $height)));
	}
	public function queueScale($scaleX, $scaleY) {
		$this->queue->add(_hx_anonymous(array("type" => microbe_utils_ImageAction::$SCALE, "scaleX" => $scaleX, "scaleY" => $scaleY)));
	}
	public function queueRotate($CW) {
		if($CW === null) {
			$CW = true;
		}
		$this->queue->add(_hx_anonymous(array("type" => microbe_utils_ImageAction::$ROTATE, "CW" => $CW)));
	}
	public function queueCustom($func, $cacheIdentifier) {
		$this->queue->add(_hx_anonymous(array("type" => microbe_utils_ImageAction::$CUSTOM, "func" => $func, "cacheIdentifier" => $cacheIdentifier)));
	}
	public function applyFitSize($maxWidth, $maxHeight) {
		$ow = imagesx($this->resource);
		$oh = imagesy($this->resource);
		$scale = 1;
		if($ow > $maxWidth) {
			$scale = $maxWidth / $ow;
		}
		if($oh * $scale > $maxHeight) {
			$scale *= $maxHeight / ($oh * $scale);
		}
		$nw = intval($ow * $scale);
		$nh = intval($oh * $scale);
		if($nw < 1) {
			$nw = 1;
		}
		if($nh < 1) {
			$nh = 1;
		}
		$newResource = microbe_utils_GD::imageCreateTrueColor($nw, $nh);
		$success = imagecopyresampled($newResource, $this->resource, 0, 0, 0, 0, $nw, $nh, $ow, $oh);
		if(!$success) {
			throw new HException("There was an error resizing the image");
		}
		$this->resource = $newResource;
	}
	public function applyCropToAspect($w, $h) {
		$ow = imagesx($this->resource);
		$oh = imagesy($this->resource);
		$oaspect = $ow / $oh;
		$taspect = $w / $h;
		$nh = $oh;
		$nw = $ow;
		if($taspect > $oaspect) {
			$nh = intval(1 / $taspect * $ow);
		} else {
			$nw = intval($taspect * $oh);
		}
		if($nw < 1) {
			$nw = 1;
		}
		if($nh < 1) {
			$nh = 1;
		}
		$newResource = microbe_utils_GD::imageCreateTrueColor($nw, $nh);
		$success = imagecopyresampled($newResource, $this->resource, 0, 0, intval(($ow - $nw) / 2), intval(($oh - $nh) / 2), $nw, $nh, $nw, $nh);
		if(!$success) {
			throw new HException("There was an error cropping the image to aspect");
		}
		$this->resource = $newResource;
	}
	public function applyCrop($x, $y, $width, $height) {
		$newResource = microbe_utils_GD::imageCreateTrueColor($width, $height);
		$success = imagecopyresampled($newResource, $this->resource, 0, 0, $x, $y, $width, $height, $width, $height);
		if(!$success) {
			throw new HException("There was an error cropping the image to aspect");
		}
		$this->resource = $newResource;
	}
	public function applyResize($width, $height) {
		$ow = imagesx($this->resource);
		$oh = imagesy($this->resource);
		$newResource = microbe_utils_GD::imageCreateTrueColor($width, $height);
		$success = imagecopyresampled($newResource, $this->resource, 0, 0, 0, 0, $width, $height, $ow, $oh);
		if(!$success) {
			throw new HException("There was an error resizing the image");
		}
		$this->resource = $newResource;
	}
	public function applyScale($scaleX, $scaleY) {
		$ow = imagesx($this->resource);
		$oh = imagesy($this->resource);
		$nw = intval($ow * $scaleX);
		$nh = intval($oh * $scaleY);
		if($nw < 1) {
			$nw = 1;
		}
		if($nh < 1) {
			$nh = 1;
		}
		$newResource = microbe_utils_GD::imageCreateTrueColor($nw, $nh);
		$success = imagecopyresampled($newResource, $this->resource, 0, 0, 0, 0, $nw, $nh, $ow, $oh);
		if(!$success) {
			throw new HException("There was an error applying scale to the image");
		}
		$this->resource = $newResource;
	}
	public function applyRotation($angle, $CW, $bgcolor, $transparentBg) {
		if($transparentBg === null) {
			$transparentBg = false;
		}
		if($bgcolor === null) {
			$bgcolor = 0;
		}
		if($CW === null) {
			$CW = true;
		}
		$this->resource = imagerotate($this->resource, microbe_utils_ImageProcessor_2($this, $CW, $angle, $bgcolor, $transparentBg), $bgcolor, (($transparentBg) ? 1 : 0));
	}
	public function applyCustom($func, $cacheIdentifier) {
		Reflect::callMethod(null, $func, new _hx_array(array()));
	}
	public function processQueue() {
		if(null == $this->queue) throw new HException('null iterable');
		$»it = $this->queue->iterator();
		while($»it->hasNext()) {
			$action = $»it->next();
			$»t = ($action->type);
			switch($»t->index) {
			case 1:
			{
				$this->applyFitSize($action->maxWidth, $action->maxHeight);
			}break;
			case 2:
			{
				$this->applyCropToAspect($action->w, $action->h);
			}break;
			case 3:
			{
				$this->applyResize($action->width, $action->height);
			}break;
			case 4:
			{
				$this->applyScale($action->scaleX, $action->scaleY);
			}break;
			case 5:
			{
				$this->applyCrop($action->x, $action->y, $action->width, $action->height);
			}break;
			case 6:
			{
				$this->applyRotation($action->angle, $action->CW, $action->bgcolor, $action->transparent);
			}break;
			case 0:
			{
				$this->applyCustom((isset($action->func) ? $action->func: array($action, "func")), $action->cacheIdentifier);
			}break;
			}
		}
		$this->queue->clear();
	}
	public function getFileFormat($file) {
		$ext = strtolower(_hx_substr($file, _hx_last_index_of($file, ".", null) + 1, null));
		return microbe_utils_ImageProcessor_3($this, $ext, $file);
	}
	public function getHash() {
		$s = $this->fileName;
		if(null == $this->queue) throw new HException('null iterable');
		$»it = $this->queue->iterator();
		while($»it->hasNext()) {
			$action = $»it->next();
			$_g = 0; $_g1 = Reflect::fields($action);
			while($_g < $_g1->length) {
				$field = $_g1[$_g];
				++$_g;
				$s .= "&" . $field . "=" . Reflect::field($action, $field);
				unset($field);
			}
			unset($_g1,$_g);
		}
		$stat = sys_FileSystem::stat($this->fileName);
		$s .= "&" . $stat->mtime . "&" . $stat->ctime . "&" . microbe_utils_ImageProcessor::$revision . $this->quality . ((($this->saveAlpha) ? 1 : 0));
		$hash = haxe_Md5::encode($s);
		$this->dateModified = $stat->mtime;
		return $hash;
	}
	public function output() {
		ob_start();
		$»t = ($this->format);
		switch($»t->index) {
		case 2:
		{
			imagegif($this->resource, null);
		}break;
		case 0:
		{
			microbe_utils_GD::imageJpeg($this->resource, null, intval($this->quality * 100));
		}break;
		case 1:
		{
			imagepng($this->resource, null);
		}break;
		case 3:
		{
			imagewbmp($this->resource, null, null);
		}break;
		}
		$out = ob_get_contents();
		ob_end_clean();
		return $out;
	}
	public function getCacheName() {
		$hash = $this->getHash();
		$ext = microbe_utils_ImageProcessor_4($this, $hash);
		return $hash . "." . $ext;
	}
	public function getOutput($flush) {
		if($flush === null) {
			$flush = false;
		}
		if($this->cache && !$this->forceNoCache) {
			$cacheFile = $this->cacheFolder . "/" . $this->getCacheName();
			if(file_exists($cacheFile)) {
				return sys_io_File::getContent($cacheFile);
			} else {
				if($this->saveAlpha) {
					imagesavealpha ($this->resource, true);
				}
				if(!$this->queue->isEmpty()) {
					$this->processQueue();
				}
				$output = $this->output();
				sys_io_File::saveContent($cacheFile, $output);
				return $output;
			}
		} else {
			if(!$this->queue->isEmpty()) {
				$this->processQueue();
			}
			return $this->output();
		}
	}
	public function flushOutput() {
		$cacheName = $this->getCacheName();
		$cacheFile = $this->cacheFolder . "/" . $cacheName;
		header("content-type" . ": " . "image");
		header("Content-Transfer-Encoding" . ": " . "binary");
		if(file_exists($cacheFile)) {
			header("Content-Disposition" . ": " . ("inline; filename=" . $cacheName));
			header("Content-Length" . ": " . filesize($cacheFile));
			readfile($cacheFile);
			Sys::hexit(1);
		} else {
			php_Lib::hprint($this->getOutput(null));
		}
		Sys::hexit(1);
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->»dynamics[$m]) && is_callable($this->»dynamics[$m]))
			return call_user_func_array($this->»dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call «'.$m.'»');
	}
	static $revision = "0.1";
	function __toString() { return 'microbe.utils.ImageProcessor'; }
}
function microbe_utils_ImageProcessor_0(&$»this) {
	$»t = ($»this->outputFormat);
	switch($»t->index) {
	case 0:
	{
		return microbe_utils_GD::imageCreateFromJpeg($»this->fileName);
	}break;
	case 2:
	{
		return microbe_utils_GD::imageCreateFromGif($»this->fileName);
	}break;
	case 1:
	{
		return microbe_utils_GD::imageCreateFromPng($»this->fileName);
	}break;
	case 3:
	{
		return microbe_utils_GD::imageCreateFromPng($»this->fileName);
	}break;
	}
}
function microbe_utils_ImageProcessor_1(&$»this) {
	$»t = ($»this->outputFormat);
	switch($»t->index) {
	case 0:
	{
		return "image/jpeg";
	}break;
	case 2:
	{
		return "image/gif";
	}break;
	case 1:
	{
		return "image/png";
	}break;
	case 3:
	{
		return "image/bmp";
	}break;
	}
}
function microbe_utils_ImageProcessor_2(&$»this, &$CW, &$angle, &$bgcolor, &$transparentBg) {
	if($CW) {
		return $angle;
	} else {
		return $angle * -1;
	}
}
function microbe_utils_ImageProcessor_3(&$»this, &$ext, &$file) {
	switch($ext) {
	case "jpg":case "jpeg":{
		return microbe_utils_ImageOutputFormat::$JPG;
	}break;
	case "gif":{
		return microbe_utils_ImageOutputFormat::$GIF;
	}break;
	case "png":{
		return microbe_utils_ImageOutputFormat::$PNG;
	}break;
	case "bmp":{
		return microbe_utils_ImageOutputFormat::$BMP;
	}break;
	}
}
function microbe_utils_ImageProcessor_4(&$»this, &$hash) {
	$»t = ($»this->format);
	switch($»t->index) {
	case 2:
	{
		return "gif";
	}break;
	case 0:
	{
		return "jpg";
	}break;
	case 1:
	{
		return "png";
	}break;
	case 3:
	{
		return "bmp";
	}break;
	}
}
