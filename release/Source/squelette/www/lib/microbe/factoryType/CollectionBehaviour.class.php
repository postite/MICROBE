<?php

class microbe_factoryType_CollectionBehaviour implements microbe_factoryType_IBehaviour{
	public function __construct() {
		if(!php_Boot::$skip_constructor) {
		microbe_tools_Mytrace::setRedirection();
	}}
	public function delete($voName, $id) {
	}
	public function record($source, $data) {
		haxe_Log::trace("record collection" . Std::string($data), _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 294, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
		$collectionList = new HList();
		$castedsource = $source;
		$childRefs = new HList();
		if($data->id === null) {
			haxe_Log::trace("data.id==NULL", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 309, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
			if(null == $castedsource) throw new HException('null iterable');
			$»it = $castedsource->iterator();
			while($»it->hasNext()) {
				$a = $»it->next();
				haxe_Log::trace("bip=" . Std::string($a->type), _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 311, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
				$data1 = Type::createInstance(Type::resolveClass(microbe_controllers_GenericController::$appConfig->voPackage . $castedsource->voName), new _hx_array(array()));
				$parser = new microbe_MicroCreator();
				$parser->source = $a;
				$parser->data = $data1;
				$child = $parser->record();
				haxe_Log::trace("child_titre=" . Std::string(Reflect::field($child, "titre")), _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 318, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
				Reflect::callMethod($child, "set_rel", new _hx_array(array($data1)));
				haxe_Log::trace("fakespod.id=" . $data1->id, _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 320, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
				$childRefs->add($child);
				unset($parser,$data1,$child);
			}
			haxe_Log::trace("after nodataid", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 325, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
		} else {
			haxe_Log::trace("DATA.ID exist", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 327, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
			$refs = Reflect::field($data, $castedsource->field);
			haxe_Log::trace("------hopopop=" . Std::string($refs), _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 331, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
			$iter = $castedsource->iterator();
			if(null == $castedsource) throw new HException('null iterable');
			$»it = $castedsource->iterator();
			while($»it->hasNext()) {
				$spodcollection = $»it->next();
				haxe_Log::trace("iterate in castedSource", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 336, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
				if(_hx_field($spodcollection, "id") !== null) {
					haxe_Log::trace("collection id exist", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 343, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
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
					haxe_Log::trace("collection id does not exist", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 358, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
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
			haxe_Log::trace("after insert", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 401, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
		} else {
			haxe_Log::trace("data.id!=null", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 403, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
			$data->update();
			haxe_Log::trace("after update", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 406, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
		}
		if(null == $childRefs) throw new HException('null iterable');
		$»it = $childRefs->iterator();
		while($»it->hasNext()) {
			$c = $»it->next();
			if(_hx_field($c, "id") !== null) {
				haxe_Log::trace("update child", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 412, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
				$rel = Reflect::field($c, "rel");
				$c->update();
				unset($rel);
			} else {
				haxe_Log::trace("insert child", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 418, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
				$rel = Reflect::field($c, "rel");
				Reflect::callMethod($c, "set_rel", new _hx_array(array($data)));
				haxe_Log::trace(Reflect::field($rel, "id"), _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 421, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
				$c->insert();
				unset($rel);
			}
		}
		haxe_Log::trace("END", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 430, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "record")));
		return $data;
	}
	public function create($voName, $element, $field, $formulaire = null) {
		$fieldClass = Type::resolveClass($element->classe);
		$instanceClass = Type::createInstance($fieldClass, new _hx_array(array()));
		$sousVoName = Lambda::hlist(_hx_explode(".", $element->classe))->last();
		haxe_Log::trace("sousvoName=" . $sousVoName, _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 39, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
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
		haxe_Log::trace("before collectionWrapper", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 65, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
		$graine = 0;
		$wrapper = new microbe_form_elements_CollectionWrapper($sousVoName);
		$formulaire->addElement($wrapper, null);
		if($this->data->id !== null) {
			haxe_Log::trace("y'a de la data yeah" . _hx_string_rec($this->data->id, "") . "voName" . $voName, _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 75, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
			$newCollec->id = $this->data->id;
			haxe_Log::trace("status2", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 78, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
			$voitures = Reflect::field($this->data, $field);
			haxe_Log::trace("voiture" . Std::string($voitures), _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 81, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
			$micros = new HList();
			if($voitures->length > 0) {
				haxe_Log::trace("in voiture length", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 87, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
				if(null == $voitures) throw new HException('null iterable');
				$»it = $voitures->iterator();
				while($»it->hasNext()) {
					$car = $»it->next();
					haxe_Log::trace(" in loop voiture iterator", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 90, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
					$micros1 = new HList();
					$parent = Reflect::field($instanceClass, "rel");
					haxe_Log::trace("parent=" . $parent, _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 95, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
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
						haxe_Log::trace(" in loop collec iterator", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 109, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
						$bum = new microbe_form_Microfield();
						$bum->value = Reflect::field($car, $item->field);
						$bum->type = $item->type;
						$bum->voName = $item->voName;
						$bum->elementId = $collec->elementId . "_" . $item->field . "_" . _hx_string_rec($graine, "");
						$bum->element = _hx_deref(($item))->element;
						$bum->field = $item->field;
						$spodList->add($bum);
						haxe_Log::trace("bum=" . Std::string($bum), _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 128, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
						$elem = microbe_factoryType_CollectionBehaviour::creeAjaxFormElement($bum, Std::string($graine));
						$micros1->add($elem);
						haxe_Log::trace("end loope", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 132, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
						unset($elem,$bum);
					}
					haxe_Log::trace("before CollectionElement", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 137, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
					$microWrapper = Type::createInstance(Type::resolveClass("microbe.form.elements.CollectionElement"), new _hx_array(array($spodList->elementId, $field, $micros1, $graine, $spodList->id)));
					haxe_Log::trace("after CollectionElement", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 142, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
					$wrapper->addElement($microWrapper);
					haxe_Log::trace("then", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 144, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
					$graine++;
					$newCollec->add($spodList);
					unset($spodList,$parent,$micros1,$microWrapper);
				}
				haxe_Log::trace("before else", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 149, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
			} else {
				haxe_Log::trace(" else", _hx_anonymous(array("fileName" => "CollectionBehaviour.hx", "lineNumber" => 152, "className" => "microbe.factoryType.CollectionBehaviour", "methodName" => "create")));
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
