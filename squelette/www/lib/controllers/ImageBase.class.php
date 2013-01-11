<?php

class controllers_ImageBase extends microbe_controllers_LightController {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$configuration = new config_Config(null);
		$this->upfolder = $configuration->imagesPath;
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
	}}
	public function setHeaders($dateModified, $length, $hash) {
		header("Last-Modified" . ": " . (DateTools::format($dateModified, "%a, %d %b %Y %H:%M:%S") . " GMT"));
		header("Expires" . ": " . (DateTools::format(new Date($dateModified->getFullYear() + 1, $dateModified->getMonth(), $dateModified->getDay(), 0, 0, 0), "%a, %d %b %Y %H:%M:%S") . " GMT"));
		header("Cache-Control" . ": " . "public, max-age=31536000");
		header("ETag" . ": " . ("\"" . $hash . "\""));
		header("Pragma" . ": " . "");
		header("Content-type" . ": " . "image");
		header("Content-Length" . ": " . $length);
	}
	public function resizeImage($preset, $image, $w = null, $h = null) {
		if($image->format == microbe_utils_ImageOutputFormat::$PNG) {
			$image->saveAlpha = true;
		} else {
			$image->saveAlpha = false;
		}
		switch($preset) {
		case "slim":{
			$image->queueResize(300, 300);
			$image->queueCropToAspect(300, 60);
		}break;
		case "tiny":{
			$image->queueFitSize(40, 40);
		}break;
		case "thumb":{
			$image->queueCropToAspect(100, 100);
			$image->queueFitSize(100, 100);
		}break;
		case "aspect":{
			$w1 = Std::parseInt($w);
			$h1 = Std::parseInt($h);
			$image->queueCropToAspect($w1, $h1);
		}break;
		case "custom":{
			$w1 = Std::parseInt($w);
			$h1 = Std::parseInt($h);
			$image->queueFitSize($w1, $h1);
		}break;
		case "gallery":{
			$image->queueFitSize(500, 500);
		}break;
		case "modele":{
			$image->queueFitSize(260, 350);
		}break;
		case "variante":{
			$image->queueCropToAspect(70, 70);
			$image->queueFitSize(70, 70);
		}break;
		case "big":{
			$image->applyFitSize(600, 600);
		}break;
		}
	}
	public function resize($preset = null, $src = null, $w = null, $h = null) {
		if($preset !== null) {
			$image = new microbe_utils_ImageProcessor("." . $this->upfolder . $src);
			$image->cacheFolder = "." . $this->upfolder . "cache";
			$image->format = $image->getFileFormat($src);
			$this->resizeImage($preset, $image, $w, $h);
			$imageStr = $image->getOutput(null);
			$filename = $image->cacheFolder . "/" . $image->getCacheName();
			$length = ((file_exists($filename)) ? filesize($filename) : Std::string(strlen($imageStr)));
			$this->setHeaders($image->dateModified, $length, $image->hash);
			php_Lib::hprint($imageStr);
		} else {
			$dateModified = sys_FileSystem::stat($this->upfolder . $src)->mtime;
			$length = filesize($this->upfolder . $src);
			$this->setHeaders($dateModified, $length, haxe_Md5::encode($src));
			readfile($this->upfolder . $src);
			Sys::hexit(1);
		}
	}
	public $upfolder;
	public $data;
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
	static $__rtti = "<class path=\"controllers.ImageBase\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.LightController\"/>\x0A\x09<data public=\"1\"><d/></data>\x0A\x09<upfolder public=\"1\"><c path=\"String\"/></upfolder>\x0A\x09<resize public=\"1\" set=\"method\" line=\"44\"><f a=\"?preset:?src:?w:?h\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></resize>\x0A\x09<resizeImage set=\"method\" line=\"95\"><f a=\"preset:image:?w:?h\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"microbe.utils.ImageProcessor\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></resizeImage>\x0A\x09<setHeaders set=\"method\" line=\"143\"><f a=\"dateModified:length:hash\">\x0A\x09<c path=\"Date\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></setHeaders>\x0A\x09<new public=\"1\" set=\"method\" line=\"27\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A\x09<haxe_doc>* ...\x0A * @author postite</haxe_doc>\x0A</class>";
	function __toString() { return 'controllers.ImageBase'; }
}
