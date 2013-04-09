<?php

class haxigniter_server_request_FileInfo {
	public function __construct($name, $tmpPath) {
		if(!php_Boot::$skip_constructor) {
		$this->tmpPath = $tmpPath;
		$this->name = $name;
	}}
	public function copyTo($relpath) {
		if(haxe_io_Path::withoutDirectory($relpath) === "") {
			$relpath .= $this->name;
		}
		sys_io_File::copy($this->tmpPath, haxe_io_Path::directory(dirname($_SERVER["SCRIPT_FILENAME"]) . "/") . $relpath);
		return $this->name;
	}
	public $tmpPath;
	public $name;
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
	function __toString() { return 'haxigniter.server.request.FileInfo'; }
}
