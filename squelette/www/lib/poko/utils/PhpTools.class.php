<?php

class poko_utils_PhpTools {
	public function __construct(){}
	static function pf($obj) {
		php_Lib::hprint("<pre>");
		print_r($obj);
		php_Lib::hprint("</pre>");
	}
	static function setupTrace() {
		$f = haxe_Log::$trace;
		haxe_Log::$trace = array(new _hx_lambda(array(&$f), "poko_utils_PhpTools_0"), 'execute');
	}
	static function mail($to, $subject, $message, $headers = null, $additionalParameters = null) {
		if($additionalParameters === null) {
			$additionalParameters = "";
		}
		if($headers === null) {
			$headers = "";
		}
		mail($to, $subject, $message, $headers, $additionalParameters);
	}
	static function moveFile($filename, $destination) {
		$success = move_uploaded_file($filename, $destination);
		if(!$success) {
			throw new HException("Error uploading '" . $filename . "' to '" . $destination . "'");
		}
	}
	static function getFilesInfo() {
		$files = php_Lib::hashOfAssociativeArray($_FILES);
		$output = new Hash();
		if(null == $files) throw new HException('null iterable');
		$»it = $files->keys();
		while($»it->hasNext()) {
			$file = $»it->next();
			$output->set($file, php_Lib::hashOfAssociativeArray($files->get($file)));
		}
		return $output;
	}
	function __toString() { return 'poko.utils.PhpTools'; }
}
function poko_utils_PhpTools_0(&$f, $v, $pos) {
	{
		call_user_func_array($f, array($v, $pos));
		php_Lib::hprint("<br />");
	}
}
