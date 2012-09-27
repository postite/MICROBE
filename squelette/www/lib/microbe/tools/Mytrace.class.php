<?php

class microbe_tools_Mytrace {
	public function __construct(){}
	static function setRedirection() {
		haxe_Log::$trace = (isset(microbe_tools_Mytrace::$mytrace) ? microbe_tools_Mytrace::$mytrace: array("microbe_tools_Mytrace", "mytrace"));
	}
	static function mytrace($v, $inf = null) {
		microbe_controllers_GenericController::$appDebug->log(Std::string($v) . " ::> \x0A " . $inf->fileName . " " . _hx_string_rec($inf->lineNumber, "") . " " . $inf->methodName, null);
	}
	function __toString() { return 'microbe.tools.Mytrace'; }
}
