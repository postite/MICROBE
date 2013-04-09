<?php

class haxigniter_server_libraries_Debug {
	public function __construct($config, $traceLevel = null, $logOutput = null, $htmlOutput = null) {
		if(!php_Boot::$skip_constructor) {
		if($htmlOutput === null) {
			$htmlOutput = true;
		}
		$this->config = $config;
		$this->traceLevel = (($traceLevel === null) ? haxigniter_server_libraries_DebugLevel::$info : $traceLevel);
		$this->logOutput = $logOutput;
		$this->htmlOutput = $htmlOutput;
	}}
	public function trace($data, $traceLevel = null, $pos = null) {
		if($traceLevel === null) {
			$traceLevel = haxigniter_server_libraries_DebugLevel::$info;
		}
		if(haxigniter_server_libraries_Debug::toInt($traceLevel) > haxigniter_server_libraries_Debug::toInt($this->traceLevel)) {
			return;
		}
		if($this->htmlOutput) {
			php_Lib::hprint("<pre style=\"border:1px dashed green; padding:2px; background-color:#F9F8F6;\">");
		}
		haxigniter_server_libraries_Debug::startBuffer();
		haxe_Log::trace($data, $pos);
		$output = StringTools::htmlEscape(haxigniter_server_libraries_Debug::endBuffer());
		if($this->htmlOutput) {
			$output = haxigniter_server_libraries_Debug::colorize($output);
		}
		php_Lib::hprint($output);
		if($this->htmlOutput) {
			php_Lib::hprint("</pre>");
		}
	}
	public function log($message, $debugLevel = null) {
		if($debugLevel === null) {
			$debugLevel = haxigniter_server_libraries_DebugLevel::$info;
		}
		if(haxigniter_server_libraries_Debug::toInt($debugLevel) > haxigniter_server_libraries_Debug::toInt($this->config->logLevel)) {
			return;
		}
		$output = strtoupper(Std::string($debugLevel)) . " - " . DateTools::format(Date::now(), $this->config->logDateFormat) . " --> " . Std::string($message) . "\x0A";
		if($this->logOutput === null) {
			$logFile = $this->config->logPath . "log-" . DateTools::format(Date::now(), "%Y-%m-%d");
			$logFile .= ".php";
			if(!file_exists($logFile)) {
				$output = "<?php exit; ?>\x0A\x0A" . $output;
			}
			$file = sys_io_File::append($logFile, false);
			$file->writeString($output);
			$file->close();
		} else {
			$this->logOutput->writeString($output);
			$this->logOutput->flush();
		}
	}
	public $config;
	public $traceLevel;
	public $htmlOutput;
	public $logOutput;
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
	static function toInt($level) {
		return haxigniter_server_libraries_Debug_0($level);
	}
	static function startBuffer() {
		ob_start();
	}
	static function endBuffer() {
		return ob_get_clean();
	}
	static function colorize($data) {
		$title = new EReg("^([^:]+:\\d+:)", "");
		$title->match($data);
		$header = $title->matched(1);
		$data = $title->replace($data, "");
		$tabs = new EReg("\x09", "g");
		$data = $tabs->replace($data, "  ");
		$strings = new EReg("(\"[^\"]*\")", "g");
		$data = $strings->replace($data, "<span style=\"color:#C31515;\">\$1</span>");
		$num = new EReg("\\b(\\d+\\.?\\d*)\\b", "g");
		$data = $num->replace($data, "<span style=\"color:#008000;\">\$1</span>");
		$bools = new EReg("\\b(true|false)\\b", "g");
		$data = $bools->replace($data, "<span style=\"color:#1518FF;\">\$1</span>");
		return "<b>" . $header . "</b>" . $data;
	}
	function __toString() { return 'haxigniter.server.libraries.Debug'; }
}
function haxigniter_server_libraries_Debug_0(&$level) {
	$»t = ($level);
	switch($»t->index) {
	case 0:
	{
		return 0;
	}break;
	case 1:
	{
		return 1;
	}break;
	case 2:
	{
		return 2;
	}break;
	case 3:
	{
		return 3;
	}break;
	case 4:
	{
		return 4;
	}break;
	}
}
