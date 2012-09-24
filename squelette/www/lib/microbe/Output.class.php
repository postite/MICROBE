<?php

class microbe_Output {
	public function __construct($spod, $_voName = null) {
		if(!php_Boot::$skip_constructor) {
		$this->data = $spod;
		$this->voName = $_voName;
		$this->hash = new Hash();
		$formule = $spod->getFormule();
		if(null == $formule) throw new HException('null iterable');
		$»it = $formule->keys();
		while($»it->hasNext()) {
			$field = $»it->next();
			if(Std::is($formule->get($field)->champs, _hx_qtype("List"))) {
				$neoHash = new Hash();
				$liste = $formule->get($field)->champs;
				$neoList = new HList();
				$subFormule = $liste->first()->getFormule();
				if(null == $liste) throw new HException('null iterable');
				$»it2 = $liste->iterator();
				while($»it2->hasNext()) {
					$item = $»it2->next();
					if(null == $subFormule) throw new HException('null iterable');
					$»it3 = $subFormule->keys();
					while($»it3->hasNext()) {
						$subField = $»it3->next();
						$neoHash->set($subField, $subFormule->get($subField)->champs);
					}
					$neoList->add($neoHash);
				}
				$this->hash->set($field, $neoList);
				unset($subFormule,$neoList,$neoHash,$liste);
			} else {
				$this->hash->set($field, $formule->get($field)->champs);
			}
		}
	}}
	public function render() {
		return haxe_Serializer::run($this->hash);
	}
	public function parse() {
		$newList = new microbe_form_MicroFieldList();
		$creator = new microbe_MicroCreator();
		$creator->data = $this->data;
		$creator->generate("vo." . $this->voName, $this->data->getFormule(), $newList, null);
		return $newList;
	}
	public $data;
	public $voName;
	public $hash;
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
	function __toString() { return 'microbe.Output'; }
}
