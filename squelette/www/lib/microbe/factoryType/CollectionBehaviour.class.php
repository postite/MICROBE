<?php

class microbe_factoryType_CollectionBehaviour implements microbe_factoryType_IBehaviour{
	public function __construct() {
		;
	}
	public function delete($voName, $id) {
	}
	public function record($source, $data) {
		$collectionList = new HList();
		$castedsource = $source;
		$childRefs = new HList();
		if($data->id === null) {
			if(null == $castedsource) throw new HException('null iterable');
			$»it = $castedsource->iterator();
			while($»it->hasNext()) {
				$a = $»it->next();
				$data1 = Type::createInstance(Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $castedsource->voName), new _hx_array(array()));
				$parser = new microbe_MicroCreator();
				$parser->source = $a;
				$parser->data = $data1;
				$child = $parser->record();
				Reflect::callMethod($child, "set_rel", new _hx_array(array($data1)));
				$childRefs->add($child);
				unset($parser,$data1,$child);
			}
			null;
		} else {
			$refs = Reflect::field($data, $castedsource->field);
			$iter = $castedsource->iterator();
			if(null == $castedsource) throw new HException('null iterable');
			$»it = $castedsource->iterator();
			while($»it->hasNext()) {
				$spodcollection = $»it->next();
				if(_hx_field($spodcollection, "id") !== null) {
					$manager = Reflect::field(Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $castedsource->voName), "manager");
					$ref = $manager->unsafeGet($spodcollection->id, true);
					$parser = new microbe_MicroCreator();
					$parser->source = $spodcollection;
					$parser->data = $ref;
					$child = $parser->record();
					Reflect::callMethod($child, "set_rel", new _hx_array(array($data)));
					$childRefs->add($child);
					unset($ref,$parser,$manager,$child);
				} else {
					$voInstance = Type::createInstance(Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $castedsource->voName), new _hx_array(array()));
					$parser = new microbe_MicroCreator();
					$parser->source = $spodcollection;
					$parser->data = $voInstance;
					$child = $parser->record();
					Reflect::callMethod($child, "set_rel", new _hx_array(array($data)));
					$childRefs->add($child);
					unset($voInstance,$parser,$child);
				}
			}
		}
		if($data->id === null) {
			$data->insert();
			null;
		} else {
			$data->update();
			null;
		}
		if(null == $childRefs) throw new HException('null iterable');
		$»it = $childRefs->iterator();
		while($»it->hasNext()) {
			$c = $»it->next();
			if(_hx_field($c, "id") !== null) {
				$rel = Reflect::field($c, "rel");
				$c->update();
				unset($rel);
			} else {
				$rel = Reflect::field($c, "rel");
				Reflect::callMethod($c, "set_rel", new _hx_array(array($data)));
				$c->insert();
				unset($rel);
			}
		}
		return $data;
	}
	public function create($voName, $element, $field, $formulaire = null) {
		$fieldClass = Type::resolveClass($element->classe);
		$instanceClass = Type::createInstance($fieldClass, new _hx_array(array()));
		$sousVoName = Lambda::hlist(_hx_explode(".", $element->classe))->last();
		$newCollec = new microbe_form_MicroFieldList();
		$newCollec->type = microbe_form_InstanceType::$collection;
		$newCollec->voName = $sousVoName;
		$newCollec->field = $field;
		$newCollec->elementId = $voName . "_" . $field . "_" . $sousVoName;
		$creator = new microbe_MicroCreator();
		$collec = $creator->justGet($sousVoName, $instanceClass->getFormule(), null);
		$collec->voName = $sousVoName;
		$collec->type = microbe_form_InstanceType::$spodable;
		$collec->field = $field;
		$collec->elementId = $newCollec->elementId;
		$collec->pos = 0;
		$graine = 0;
		$wrapper = new microbe_form_elements_CollectionWrapper($sousVoName);
		$formulaire->addElement($wrapper, null);
		if($this->data->id !== null) {
			$newCollec->id = $this->data->id;
			$voitures = Reflect::field($this->data, $field);
			$micros = new HList();
			if($voitures->length > 0) {
				if(null == $voitures) throw new HException('null iterable');
				$»it = $voitures->iterator();
				while($»it->hasNext()) {
					$car = $»it->next();
					$micros1 = new HList();
					$parent = Reflect::field($instanceClass, "rel");
					$spodList = new microbe_form_MicroFieldList();
					$spodList->voName = $sousVoName;
					$spodList->type = microbe_form_InstanceType::$spodable;
					$spodList->field = $field;
					$spodList->id = $car->id;
					$spodList->pos = $car->poz;
					$spodList->elementId = $collec->elementId;
					if(null == $collec) throw new HException('null iterable');
					$»it2 = $collec->iterator();
					while($»it2->hasNext()) {
						$item = $»it2->next();
						$bum = new microbe_form_Microfield();
						$bum->value = Reflect::field($car, $item->field);
						$bum->type = $item->type;
						$bum->voName = $item->voName;
						$bum->elementId = $collec->elementId . "_" . $item->field . "_" . _hx_string_rec($graine, "");
						$bum->element = _hx_deref(($item))->element;
						$bum->field = $item->field;
						$spodList->add($bum);
						$elem = microbe_factoryType_CollectionBehaviour::creeAjaxFormElement($bum, Std::string($graine));
						$micros1->add($elem);
						unset($elem,$bum);
					}
					$microWrapper = Type::createInstance(Type::resolveClass("microbe.form.elements.CollectionElement"), new _hx_array(array($spodList->elementId, $field, $micros1, $graine, $spodList->id)));
					$wrapper->addElement($microWrapper);
					$graine++;
					$newCollec->add($spodList);
					unset($spodList,$parent,$micros1,$microWrapper);
				}
			} else {
				$car = $instanceClass;
				$micros1 = new HList();
				$parent = Reflect::field($instanceClass, "rel");
				$spodList = new microbe_form_MicroFieldList();
				$spodList->voName = $sousVoName;
				$spodList->type = microbe_form_InstanceType::$spodable;
				$spodList->field = $field;
				$spodList->id = $car->id;
				$spodList->pos = $car->poz;
				$spodList->elementId = $collec->elementId;
				if(null == $collec) throw new HException('null iterable');
				$»it = $collec->iterator();
				while($»it->hasNext()) {
					$item = $»it->next();
					$bum = new microbe_form_Microfield();
					$bum->value = Reflect::field($car, $item->field);
					$bum->type = $item->type;
					$bum->voName = $item->voName;
					$bum->elementId = $collec->elementId . "_" . $item->field . "_" . _hx_string_rec($graine, "");
					$bum->element = _hx_deref(($item))->element;
					$bum->field = $item->field;
					$spodList->add($bum);
					$elem = microbe_factoryType_CollectionBehaviour::creeAjaxFormElement($bum, Std::string($graine));
					$micros1->add($elem);
					unset($elem,$bum);
				}
				$microWrapper = Type::createInstance(Type::resolveClass("microbe.form.elements.CollectionElement"), new _hx_array(array($spodList->elementId, $field, $micros1, $graine, $spodList->id)));
				$wrapper->addElement($microWrapper);
				$graine++;
				$newCollec->add($spodList);
			}
			return $newCollec;
		} else {
			$micros = new HList();
			if(null == $collec) throw new HException('null iterable');
			$»it = $collec->iterator();
			while($»it->hasNext()) {
				$item = $»it->next();
				$item->type = $item->type;
				$item->voName = $item->voName;
				$item->elementId = $collec->elementId . "_" . $item->field;
				$item->field = $item->field;
				$elem = microbe_factoryType_CollectionBehaviour::creeAjaxFormElement($item, Std::string($graine));
				$micros->add($elem);
				unset($elem);
			}
			$microWrapper = Type::createInstance(Type::resolveClass("microbe.form.elements.CollectionElement"), new _hx_array(array($collec->elementId, "patapouf", $micros, $graine, 0)));
			$wrapper->addElement($microWrapper);
			$newCollec->add($collec);
			return $newCollec;
		}
		return $collec;
	}
	public function parse($source) {
		return "im a Collection";
		$parser = new microbe_MicroParser($source);
		$parser->parse();
	}
	public $tempPos;
	public $data;
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
	static function creeEmptyCollection($voName, $element, $field, $graine) {
		$fieldClass = Type::resolveClass($element->classe);
		$instanceClass = Type::createInstance($fieldClass, new _hx_array(array()));
		$sousVoName = Lambda::hlist(_hx_explode(".", $element->classe))->last();
		$newCollec = new microbe_form_MicroFieldList();
		$newCollec->type = microbe_form_InstanceType::$collection;
		$newCollec->voName = $sousVoName;
		$newCollec->field = $field;
		$newCollec->elementId = $voName . "_" . $field . "_" . $sousVoName;
		$creator = new microbe_MicroCreator();
		$collec = $creator->justGet($sousVoName, $instanceClass->getFormule(), null);
		$collec->voName = $sousVoName;
		$collec->type = microbe_form_InstanceType::$spodable;
		$collec->field = $field;
		$collec->elementId = $voName . "_" . $field . "_" . $sousVoName;
		$micros = new HList();
		if(null == $collec) throw new HException('null iterable');
		$»it = $collec->iterator();
		while($»it->hasNext()) {
			$item = $»it->next();
			$item->type = $item->type;
			$item->voName = $item->voName;
			$item->elementId = $collec->elementId . "_" . $item->field . "_" . _hx_string_rec($graine, "");
			$item->field = $item->field;
			$elem = microbe_factoryType_CollectionBehaviour::creeAjaxFormElement($item, Std::string($graine));
			$micros->add($elem);
			unset($elem);
		}
		$microWrapper = Type::createInstance(Type::resolveClass("microbe.form.elements.CollectionElement"), new _hx_array(array($collec->elementId, "patapouf", $micros, $graine, null)));
		$newCollec->add($collec);
		return _hx_anonymous(array("microliste" => $newCollec, "element" => $microWrapper->render(null)));
	}
	static function creeAjaxFormElement($microfield, $graine = null) {
		if($graine === null) {
			$graine = "";
		}
		$microbeFormElement = Type::createInstance(Type::resolveClass($microfield->element), new _hx_array(array($microfield->elementId, $microfield->field, null, null, null, null)));
		return $microbeFormElement;
	}
	function __toString() { return 'microbe.factoryType.CollectionBehaviour'; }
}
