<?php

class haxigniter_common_libraries_ParsedUrl {
	public function __construct($url) {
		if(!php_Boot::$skip_constructor) {
		$self = $this;
		$this->host = $url;
		$this->path = "/";
		{
			$pos = _hx_index_of($this->host, "?", null);
			if($pos >= 0) {
				{
					$self->query = _hx_substr($self->host, $pos + 1, null);
					$self->host = _hx_substr($self->host, 0, $pos);
					$fragmentPos = _hx_last_index_of($self->query, "#", null);
					if($fragmentPos >= 0) {
						$self->fragment = _hx_substr($self->query, $fragmentPos + 1, null);
						$self->query = _hx_substr($self->query, 0, $fragmentPos);
					}
				}
			}
		}
		{
			$pos = _hx_index_of($this->host, "://", null);
			if($pos >= 0) {
				{
					$self->scheme = _hx_substr($self->host, 0, $pos);
					$self->host = _hx_substr($self->host, $pos + 3, null);
				}
			}
		}
		{
			$pos = _hx_index_of($self->host, "@", null);
			if($pos >= 0) {
				{
					$self->user = _hx_substr($self->host, 0, $pos);
					$self->host = _hx_substr($self->host, $pos + 1, null);
					{
						$pos1 = _hx_index_of($self->user, ":", null);
						if($pos1 >= 0) {
							{
								$self->pass = _hx_substr($self->user, $pos1 + 1, null);
								$self->user = _hx_substr($self->user, 0, $pos1);
							}
						}
					}
				}
			}
		}
		{
			$pos = _hx_index_of($self->host, "/", null);
			if($pos >= 0) {
				{
					$self->path = _hx_substr($self->host, $pos, null);
					$self->host = _hx_substr($self->host, 0, $pos);
				}
			}
		}
		if($this->fragment === null) {
			{
				$pos = _hx_index_of($this->path, "#", null);
				if($pos >= 0) {
					{
						$self->fragment = _hx_substr($self->path, $pos + 1, null);
						$self->path = _hx_substr($self->path, 0, $pos);
					}
				}
			}
		}
		$portTest = new EReg("([^:]+):(\\d+)\\b", "");
		if($portTest->match($self->host)) {
			$self->host = $portTest->matched(1);
			$this->port = Std::parseInt($portTest->matched(2));
		}
	}}
	public $scheme;
	public $host;
	public $port;
	public $user;
	public $pass;
	public $path;
	public $query;
	public $fragment;
	public function ifMatch($input, $searchFor, $callBack) {
		$pos = _hx_index_of($input, $searchFor, null);
		if($pos >= 0) {
			call_user_func_array($callBack, array($pos));
		}
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
	static function parseQuery($queryString) {
		$output = new Hash();
		$pairs = null;
		$queryString = _hx_substr($queryString, _hx_index_of($queryString, "?", null) + 1, null);
		$pairs = _hx_explode("&", $queryString);
		{
			$_g = 0;
			while($_g < $pairs->length) {
				$pair = $pairs[$_g];
				++$_g;
				$keyValue = _hx_explode("=", $pair);
				if($keyValue->length === 2) {
					$output->set($keyValue[0], urldecode($keyValue[1]));
				}
				unset($pair,$keyValue);
			}
		}
		return $output;
	}
	static function queryFromHash($query) {
		$output = new HList();
		if(null == $query) throw new HException('null iterable');
		$»it = $query->keys();
		while($»it->hasNext()) {
			$key = $»it->next();
			$output->add($key . "=" . rawurlencode($query->get($key)));
		}
		return $output->join("&");
	}
	function __toString() { return 'haxigniter.common.libraries.ParsedUrl'; }
}
