<?php

class haxigniter_common_libraries_ERegTools {
	public function __construct(){}
	static $quoteMetaChars = ".\\+*?[^](\$)";
	static function quoteMeta($str) {
		{
			$_g1 = 0; $_g = strlen(haxigniter_common_libraries_ERegTools::$quoteMetaChars);
			while($_g1 < $_g) {
				$i = $_g1++;
				$char = _hx_char_at(haxigniter_common_libraries_ERegTools::$quoteMetaChars, $i);
				$str = str_replace($char, "\\" . $char, $str);
				unset($i,$char);
			}
		}
		return $str;
	}
	function __toString() { return 'haxigniter.common.libraries.ERegTools'; }
}
