<?php

class controllers_ImageBase extends microbe_controllers_GenericController {
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$configuration = new config_Config(null);
		$this->upfolder = $configuration->imagesPath;
		$this->cachefolder = $configuration->uploadsPath . "cache";
		$this->requestHandler = new haxigniter_server_request_BasicHandler($this->configuration);
	}}
	public $data;
	public $upfolder;
	public $cachefolder;
	public function resize($preset, $src, $w, $h) {
		if($src === "" || $src === null) {
			$blankGif = "R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==";
			$blankHash = haxe_Md5::encode($blankGif);
			$this->setHeaders(Date::fromTime(0), "43", $blankHash, "image/gif");
			php_Lib::hprint(base64_decode($blankGif));
			return;
		}
		if($preset !== null) {
			$image = new microbe_utils_ImageProcessor($this->upfolder . $src);
			$image->cacheFolder = $this->cachefolder;
			$image->format = microbe_utils_ImageOutputFormat::$JPG;
			$this->resizeImage($preset, $image, null, null);
			$cacheName2 = $image->getCacheName();
			$imageStr = $image->getOutput(null);
			$filename = $image->cacheFolder . "/" . $image->getCacheName();
			$length = ((file_exists($filename)) ? filesize($filename) : Std::string(strlen($imageStr)));
			$this->setHeaders($image->dateModified, $length, $image->hash, $image->mimeType);
			php_Lib::hprint($imageStr);
		} else {
			$dateModified = sys_FileSystem::stat($this->upfolder . $src)->mtime;
			$mime = strtolower(_hx_substr($src, _hx_last_index_of($src, ".", null) + 1, null));
			if($mime === "jpg") {
				$mime = "jpeg";
			}
			$mime = "image/" . $mime;
			$length = filesize($this->upfolder . $src);
			$this->setHeaders($dateModified, $length, haxe_Md5::encode($src), $mime);
			readfile($this->upfolder . $src);
			Sys::hexit(1);
		}
	}
	public function resizeImage($preset, $image, $w, $h) {
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
			$image->queueFitSize(300, 300);
		}break;
		case "modele":{
			$image->queueFitSize(260, 350);
		}break;
		case "variante":{
			$image->queueCropToAspect(70, 70);
			$image->queueFitSize(70, 70);
		}break;
		case "big":{
			$image->queueFitSize(1000, 1000);
		}break;
		}
	}
	public function setHeaders($dateModified, $length, $hash, $mime) {
		header("Last-Modified" . ": " . (DateTools::format($dateModified, "%a, %d %b %Y %H:%M:%S") . " GMT"));
		header("Expires" . ": " . (DateTools::format(new Date($dateModified->getFullYear() + 1, $dateModified->getMonth(), $dateModified->getDay(), 0, 0, 0), "%a, %d %b %Y %H:%M:%S") . " GMT"));
		header("Cache-Control" . ": " . "public, max-age=31536000");
		header("ETag" . ": " . ("\"" . $hash . "\""));
		header("Pragma" . ": " . "");
		header("Content-Type" . ": " . $mime);
		header("Content-Length" . ": " . $length);
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
	static $__rtti = "<class path=\"controllers.ImageBase\" params=\"\">\x0A\x09<extends path=\"microbe.controllers.GenericController\"/>\x0A\x09<data public=\"1\"><d/></data>\x0A\x09<upfolder public=\"1\"><c path=\"String\"/></upfolder>\x0A\x09<cachefolder public=\"1\"><c path=\"String\"/></cachefolder>\x0A\x09<resize public=\"1\" set=\"method\" line=\"59\"><f a=\"?preset:?src:?w:?h\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></resize>\x0A\x09<resizeImage set=\"method\" line=\"131\"><f a=\"preset:image:?w:?h\">\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"microbe.utils.ImageProcessor\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></resizeImage>\x0A\x09<setHeaders set=\"method\" line=\"174\"><f a=\"dateModified:length:hash:mime\">\x0A\x09<c path=\"Date\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<c path=\"String\"/>\x0A\x09<e path=\"Void\"/>\x0A</f></setHeaders>\x0A\x09<new public=\"1\" set=\"method\" line=\"48\"><f a=\"\"><e path=\"Void\"/></f></new>\x0A</class>";
	function __toString() { return 'controllers.ImageBase'; }
}
