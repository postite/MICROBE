<?php

class haxigniter_server_request_FileUploadDecorator extends haxigniter_server_request_RequestHandlerDecorator {
	public function __construct($requestHandler, $restrictClass, $addToArguments) {
		if(!php_Boot::$skip_constructor) {
		if($addToArguments === null) {
			$addToArguments = false;
		}
		parent::__construct($requestHandler);
		$this->restrictClass = $restrictClass;
		$this->addToArguments = $addToArguments;
	}}
	public $restrictClass;
	public $addToArguments;
	public $hashFile;
	public $fields;
	public $currentFile;
	public $currentFileName;
	public $currentFieldName;
	public $currentFileFieldName;
	public $currentIsFile;
	public $currentWrittenByte;
	public function handleRequest($controller, $url, $method, $getPostData, $requestData) {
		$result = $this->requestHandler->handleRequest($controller, $url, $method, $getPostData, $requestData);
		$»t = ($result);
		switch($»t->index) {
		case 0:
		{
			return $result;
		}break;
		case 1:
		$value = $»t->params[0];
		{
			return $result;
		}break;
		case 2:
		$arguments = $»t->params[2]; $method1 = $»t->params[1]; $object = $»t->params[0];
		{
			$this->hashFile = new Hash();
			$this->fields = new Hash();
			php_Web::parseMultipart((isset($this->onInfo) ? $this->onInfo: array($this, "onInfo")), (isset($this->onData) ? $this->onData: array($this, "onData")));
			if($this->currentFieldName !== null) {
				$arguments->pop();
				$arguments->push($this->fields);
			}
			if($this->currentFile !== null) {
				$this->currentFile->close();
				if($this->currentWrittenByte === 0) {
					$this->hashFile->remove($this->currentFileFieldName);
				}
				$arguments->push($this->hashFile);
				$arguments->push($this->currentWrittenByte);
			}
			return haxigniter_server_request_RequestResult::methodCall($object, $method1, $arguments);
		}break;
		}
	}
	public function onInfo($fieldName, $fileName) {
		if($fileName !== null) {
			$this->currentIsFile = true;
			if($this->currentFile !== null) {
				$this->currentFile->close();
				if($this->currentWrittenByte === 0) {
					$this->hashFile->remove($this->currentFileFieldName);
				}
			}
			$this->currentWrittenByte = 0;
			$this->currentFileFieldName = $fieldName;
			$tmpPath = haxe_io_Path::directory(dirname($_SERVER["SCRIPT_FILENAME"]) . "/") . "/runtime/cache/igni-" . haxe_Md5::encode(Std::string(Math::random() + Math::random()));
			$standardizedName = str_replace(" ", "_", $fileName);
			$r = new EReg("[\\x80-\\xFF]", "");
			$standardizedName = $r->replace($standardizedName, "-");
			$this->hashFile->set($fieldName, new haxigniter_server_request_FileInfo($standardizedName, $tmpPath));
			$this->currentFile = sys_io_File::write($tmpPath, true);
		} else {
			$this->currentFieldName = $fieldName;
			$this->currentIsFile = false;
		}
	}
	public function onData($data, $pos, $length) {
		if($this->currentIsFile) {
			$this->currentFile->writeBytes($data, $pos, $length);
			$this->currentWrittenByte += $length;
		} else {
			if($this->fields->exists($this->currentFieldName)) {
				$this->fields->set($this->currentFieldName, $this->fields->get($this->currentFieldName) . $data->readString($pos, $length));
			} else {
				$this->fields->set($this->currentFieldName, $data->readString($pos, $length));
			}
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
	function __toString() { return 'haxigniter.server.request.FileUploadDecorator'; }
}
