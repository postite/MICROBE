<?php

class microbe_MicroCreator {
	public function __construct() {
		;
	}
	public $result;
	public $formule;
	public $voName;
	public $formulaire;
	public $data;
	public $source;
	public function parse() {
	}
	public function generate($_voName, $_formule, $liste, $form) {
		$this->result = $liste;
		$this->formule = $_formule;
		$this->voName = $_voName;
		$this->formulaire = $form;
		if(null == $this->formule) throw new HException('null iterable');
		$»it = $this->formule->keys();
		while($»it->hasNext()) {
			$field = $»it->next();
			$item = $this->formule->get($field);
			$factory = new microbe_TypeFactory();
			$behaviour = $factory->create($item->type);
			$behaviour->data = $this->data;
			$this->result->add($behaviour->create($this->voName, $item, $field, $this->formulaire));
			unset($item,$factory,$behaviour);
		}
	}
	public function justGet($_voName, $_formule, $liste) {
		$list = new microbe_form_MicroFieldList();
		if(null == $_formule) throw new HException('null iterable');
		$»it = $_formule->keys();
		while($»it->hasNext()) {
			$field = $»it->next();
			$item = $_formule->get($field);
			$factory = new microbe_TypeFactory();
			$behaviour = $factory->create($item->type);
			$list->add($behaviour->create($_voName, $item, $field, null));
			unset($item,$factory,$behaviour);
		}
		return $list;
	}
	public function record() {
		haxe_Log::trace("record", _hx_anonymous(array("fileName" => "MicroCreator.hx", "lineNumber" => 62, "className" => "microbe.MicroCreator", "methodName" => "record")));
		if(null == $this->source) throw new HException('null iterable');
		$»it = $this->source->iterator();
		while($»it->hasNext()) {
			$a = $»it->next();
			haxe_Log::trace($a->type, _hx_anonymous(array("fileName" => "MicroCreator.hx", "lineNumber" => 64, "className" => "microbe.MicroCreator", "methodName" => "record")));
			$factory = new microbe_TypeFactory();
			$behaviour = $factory->create($a->type);
			$behaviour->record($a, $this->data);
			unset($factory,$behaviour);
		}
		return $this->data;
	}
	public function addToForm($formulaire) {
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
	function __toString() { return 'microbe.MicroCreator'; }
}
