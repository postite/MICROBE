<?php

class haxe_Json {
	public function __construct() {
		;
	}
	public function parseString() {
		$start = $this->pos;
		$buf = new StringBuf();
		while(true) {
			$c = ord(substr($this->str,$this->pos++,1));
			if($c === 34) {
				break;
			}
			if($c === 92) {
				$buf->b .= _hx_substr($this->str, $start, $this->pos - $start - 1);
				$c = ord(substr($this->str,$this->pos++,1));
				switch($c) {
				case 114:{
					$buf->b .= chr(13);
				}break;
				case 110:{
					$buf->b .= chr(10);
				}break;
				case 116:{
					$buf->b .= chr(9);
				}break;
				case 98:{
					$buf->b .= chr(8);
				}break;
				case 102:{
					$buf->b .= chr(12);
				}break;
				case 47:case 92:case 34:{
					$buf->b .= chr($c);
				}break;
				case 117:{
					$uc = Std::parseInt("0x" . _hx_substr($this->str, $this->pos, 4));
					$this->pos += 4;
					if($uc <= 127) {
						$buf->b .= chr($uc);
					} else {
						if($uc <= 2047) {
							$buf->b .= chr(192 | $uc >> 6);
							$buf->b .= chr(128 | $uc & 63);
						} else {
							if($uc <= 65535) {
								$buf->b .= chr(224 | $uc >> 12);
								$buf->b .= chr(128 | $uc >> 6 & 63);
								$buf->b .= chr(128 | $uc & 63);
							} else {
								$buf->b .= chr(240 | $uc >> 18);
								$buf->b .= chr(128 | $uc >> 12 & 63);
								$buf->b .= chr(128 | $uc >> 6 & 63);
								$buf->b .= chr(128 | $uc & 63);
							}
						}
					}
				}break;
				default:{
					throw new HException("Invalid escape sequence \\" . chr($c) . " at position " . _hx_string_rec(($this->pos - 1), ""));
				}break;
				}
				$start = $this->pos;
			} else {
				if($c >= 128) {
					$this->pos++;
					if($c >= 224) {
						$this->pos += 1 + ($c & 32);
					}
				} else {
					if(($c === 0)) {
						throw new HException("Unclosed string");
					}
				}
			}
			unset($c);
		}
		$buf->b .= _hx_substr($this->str, $start, $this->pos - $start - 1);
		return $buf->b;
	}
	public function parseRec() {
		while(true) {
			$c = ord(substr($this->str,$this->pos++,1));
			switch($c) {
			case 32:case 13:case 10:case 9:{
			}break;
			case 123:{
				$obj = _hx_anonymous(array()); $field = null; $comma = null;
				while(true) {
					$c1 = ord(substr($this->str,$this->pos++,1));
					switch($c1) {
					case 32:case 13:case 10:case 9:{
					}break;
					case 125:{
						if($field !== null || $comma === false) {
							$this->invalidChar();
						}
						return $obj;
					}break;
					case 58:{
						if($field === null) {
							$this->invalidChar();
						}
						$obj->{$field} = $this->parseRec();
						$field = null;
						$comma = true;
					}break;
					case 44:{
						if($comma) {
							$comma = false;
						} else {
							$this->invalidChar();
						}
					}break;
					case 34:{
						if($comma) {
							$this->invalidChar();
						}
						$field = $this->parseString();
					}break;
					default:{
						$this->invalidChar();
					}break;
					}
					unset($c1);
				}
			}break;
			case 91:{
				$arr = new _hx_array(array()); $comma = null;
				while(true) {
					$c1 = ord(substr($this->str,$this->pos++,1));
					switch($c1) {
					case 32:case 13:case 10:case 9:{
					}break;
					case 93:{
						if($comma === false) {
							$this->invalidChar();
						}
						return $arr;
					}break;
					case 44:{
						if($comma) {
							$comma = false;
						} else {
							$this->invalidChar();
						}
					}break;
					default:{
						if($comma) {
							$this->invalidChar();
						}
						$this->pos--;
						$arr->push($this->parseRec());
						$comma = true;
					}break;
					}
					unset($c1);
				}
			}break;
			case 116:{
				$save = $this->pos;
				if(ord(substr($this->str,$this->pos++,1)) !== 114 || ord(substr($this->str,$this->pos++,1)) !== 117 || ord(substr($this->str,$this->pos++,1)) !== 101) {
					$this->pos = $save;
					$this->invalidChar();
				}
				return true;
			}break;
			case 102:{
				$save = $this->pos;
				if(ord(substr($this->str,$this->pos++,1)) !== 97 || ord(substr($this->str,$this->pos++,1)) !== 108 || ord(substr($this->str,$this->pos++,1)) !== 115 || ord(substr($this->str,$this->pos++,1)) !== 101) {
					$this->pos = $save;
					$this->invalidChar();
				}
				return false;
			}break;
			case 110:{
				$save = $this->pos;
				if(ord(substr($this->str,$this->pos++,1)) !== 117 || ord(substr($this->str,$this->pos++,1)) !== 108 || ord(substr($this->str,$this->pos++,1)) !== 108) {
					$this->pos = $save;
					$this->invalidChar();
				}
				return null;
			}break;
			case 34:{
				return $this->parseString();
			}break;
			case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:{
				$this->pos--;
				if(!$this->reg_float->match(_hx_substr($this->str, $this->pos, null))) {
					throw new HException("Invalid float at position " . _hx_string_rec($this->pos, ""));
				}
				$v = $this->reg_float->matched(0);
				$this->pos += strlen($v);
				$f = Std::parseFloat($v);
				$i = intval($f);
				return ((_hx_equal($i, $f)) ? $i : $f);
			}break;
			default:{
				$this->invalidChar();
			}break;
			}
			unset($c);
		}
	}
	public function nextChar() {
		return ord(substr($this->str,$this->pos++,1));
	}
	public function invalidChar() {
		$this->pos--;
		throw new HException("Invalid char " . _hx_string_rec(ord(substr($this->str,$this->pos,1)), "") . " at position " . _hx_string_rec($this->pos, ""));
	}
	public function doParse($str) {
		$this->reg_float = new EReg("^-?(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][+-]?[0-9]+)?", "");
		$this->str = $str;
		$this->pos = 0;
		return $this->parseRec();
	}
	public function quoteUtf8($s) {
		$u = new haxe_Utf8(null);
		haxe_Utf8::iter($s, array(new _hx_lambda(array(&$s, &$u), "haxe_Json_0"), 'execute'));
		$this->buf->add("\"");
		$this->buf->add($u->toString());
		$this->buf->add("\"");
	}
	public function quote($s) {
		if(strlen($s) !== haxe_Utf8::length($s)) {
			$this->quoteUtf8($s);
			return;
		}
		$this->buf->add("\"");
		$i = 0;
		while(true) {
			$c = ord(substr($s,$i++,1));
			if(($c === 0)) {
				break;
			}
			switch($c) {
			case 34:{
				$this->buf->add("\\\"");
			}break;
			case 92:{
				$this->buf->add("\\\\");
			}break;
			case 10:{
				$this->buf->add("\\n");
			}break;
			case 13:{
				$this->buf->add("\\r");
			}break;
			case 9:{
				$this->buf->add("\\t");
			}break;
			case 8:{
				$this->buf->add("\\b");
			}break;
			case 12:{
				$this->buf->add("\\f");
			}break;
			default:{
				$this->buf->b .= chr($c);
			}break;
			}
			unset($c);
		}
		$this->buf->add("\"");
	}
	public function toStringRec($v) {
		$»t = (Type::typeof($v));
		switch($»t->index) {
		case 8:
		{
			$this->buf->add("\"???\"");
		}break;
		case 4:
		{
			$this->objString($v);
		}break;
		case 1:
		case 2:
		{
			$this->buf->add($v);
		}break;
		case 5:
		{
			$this->buf->add("\"<fun>\"");
		}break;
		case 6:
		$c = $»t->params[0];
		{
			if($c == _hx_qtype("String")) {
				$this->quote($v);
			} else {
				if($c == _hx_qtype("Array")) {
					$v1 = $v;
					$this->buf->add("[");
					$len = $v1->length;
					if($len > 0) {
						$this->toStringRec($v1[0]);
						$i = 1;
						while($i < $len) {
							$this->buf->add(",");
							$this->toStringRec($v1[$i++]);
						}
					}
					$this->buf->add("]");
				} else {
					if($c == _hx_qtype("Hash")) {
						$v1 = $v;
						$o = _hx_anonymous(array());
						if(null == $v1) throw new HException('null iterable');
						$»it = $v1->keys();
						while($»it->hasNext()) {
							$k = $»it->next();
							$o->{$k} = $v1->get($k);
						}
						$this->objString($o);
					} else {
						$this->objString($v);
					}
				}
			}
		}break;
		case 7:
		$e = $»t->params[0];
		{
			$this->buf->add($v->index);
		}break;
		case 3:
		{
			$this->buf->add((($v) ? "true" : "false"));
		}break;
		case 0:
		{
			$this->buf->add("null");
		}break;
		}
	}
	public function objString($v) {
		$this->fieldsString($v, Reflect::fields($v));
	}
	public function fieldsString($v, $fields) {
		$first = true;
		$this->buf->add("{");
		{
			$_g = 0;
			while($_g < $fields->length) {
				$f = $fields[$_g];
				++$_g;
				$value = Reflect::field($v, $f);
				if(Reflect::isFunction($value)) {
					continue;
				}
				if($first) {
					$first = false;
				} else {
					$this->buf->add(",");
				}
				$this->quote($f);
				$this->buf->add(":");
				$this->toStringRec($value);
				unset($value,$f);
			}
		}
		$this->buf->add("}");
	}
	public function toString($v) {
		$this->buf = new StringBuf();
		$this->toStringRec($v);
		return $this->buf->b;
	}
	public $reg_float;
	public $pos;
	public $str;
	public $buf;
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
	static function parse($text) {
		return _hx_deref(new haxe_Json())->doParse($text);
	}
	static function stringify($value) {
		return _hx_deref(new haxe_Json())->toString($value);
	}
	function __toString() { return $this->toString(); }
}
function haxe_Json_0(&$s, &$u, $c) {
	{
		switch($c) {
		case 92:case 34:{
			$u->addChar(92);
			$u->addChar($c);
		}break;
		case 10:{
			$u->addChar(92);
			$u->addChar(110);
		}break;
		case 13:{
			$u->addChar(92);
			$u->addChar(114);
		}break;
		case 9:{
			$u->addChar(92);
			$u->addChar(116);
		}break;
		case 8:{
			$u->addChar(92);
			$u->addChar(98);
		}break;
		case 12:{
			$u->addChar(92);
			$u->addChar(102);
		}break;
		default:{
			$u->addChar($c);
		}break;
		}
	}
}
