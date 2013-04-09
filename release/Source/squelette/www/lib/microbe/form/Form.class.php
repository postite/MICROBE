<?php

class microbe_form_Form {
	public function __construct($name, $action = null, $method = null) {
		if(!php_Boot::$skip_constructor) {
		$this->requiredClass = "formRequired";
		$this->requiredErrorClass = "formRequiredError";
		$this->invalidErrorClass = "formInvalidError";
		$this->labelRequiredIndicator = " *";
		$this->forcePopulate = false;
		$this->id = $this->name = $name;
		$this->action = $action;
		$this->method = (($method === null) ? microbe_form_FormMethod::$POST : $method);
		$this->elements = new HList();
		$this->extraErrors = new HList();
		$this->fieldsets = new Hash();
		$this->addFieldset("__default", new microbe_form_FieldSet("__default", "Default", false));
		$this->wymEditorCount = 0;
		$this->submittedButtonName = null;
	}}
	public function toString() {
		return $this->getPreview();
	}
	public function getPreview() {
		$s = new StringBuf();
		$s->add($this->getOpenTag());
		if($this->isSubmitted()) {
			$s->add($this->getErrors());
		}
		$s->add("<ul>\x0A");
		if(null == $this->getElements()) throw new HException('null iterable');
		$»it = $this->getElements()->iterator();
		while($»it->hasNext()) {
			$element = $»it->next();
			if($element !== $this->submitButton || $element !== $this->deleteButton) {
				$s->add("\x09" . $element->getPreview() . "\x0A");
			}
		}
		if($this->submitButton !== null) {
			$this->submitButton->form = $this;
			$s->add($this->submitButton->getPreview());
		}
		if($this->deleteButton !== null) {
			$this->deleteButton->form = $this;
			$s->add($this->deleteButton->render(null));
		}
		$s->add("</ul>\x0A");
		$s->add($this->getCloseTag());
		return $s->b;
	}
	public function getErrors() {
		if(!$this->isSubmitted()) {
			return "";
		}
		$s = new StringBuf();
		$errors = $this->getErrorsList();
		if($errors->length > 0) {
			$s->add("<ul class=\"formErrors\" >");
			if(null == $errors) throw new HException('null iterable');
			$»it = $errors->iterator();
			while($»it->hasNext()) {
				$error = $»it->next();
				$s->add("<li>" . $error . "</li>");
			}
			$s->add("</ul>");
		}
		return $s->b;
	}
	public function getSubmittedValue() {
		return php_Web::getParams()->get($this->name . "_formSubmitted");
		return "";
	}
	public function isSubmitted() {
		return php_Web::getParams()->get($this->name . "_formSubmitted") === "true";
		return false;
	}
	public function getElements() {
		return $this->elements;
	}
	public function getErrorsList() {
		$this->isValid();
		$errors = new HList();
		if(null == $this->extraErrors) throw new HException('null iterable');
		$»it = $this->extraErrors->iterator();
		while($»it->hasNext()) {
			$e = $»it->next();
			$errors->add($e);
		}
		if(null == $this->getElements()) throw new HException('null iterable');
		$»it = $this->getElements()->iterator();
		while($»it->hasNext()) {
			$element = $»it->next();
			if(null == $element->getErrors()) throw new HException('null iterable');
			$»it2 = $element->getErrors()->iterator();
			while($»it2->hasNext()) {
				$error = $»it2->next();
				$errors->add($error);
			}
		}
		return $errors;
	}
	public function addError($error) {
		$this->extraErrors->add($error);
	}
	public function isValid() {
		$valid = true;
		if(null == $this->getElements()) throw new HException('null iterable');
		$»it = $this->getElements()->iterator();
		while($»it->hasNext()) {
			$element = $»it->next();
			if(!$element->isValid()) {
				$valid = false;
			}
		}
		if($this->extraErrors->length > 0) {
			$valid = false;
		}
		return $valid;
	}
	public function getCloseTag() {
		$s = new StringBuf();
		$s->add("<input type=\"hidden\" name=\"" . $this->name . "_formSubmitted\" value=\"true\" /></form>");
		return $s->b;
	}
	public function getOpenTag() {
		return "<form id=\"" . $this->id . "\" name=\"" . $this->name . "\" method=\"" . Std::string($this->method) . "\" action=\"" . $this->action . "\" enctype=\"multipart/form-data\" >";
	}
	public function clearData() {
		$element = null;
		if(null == $this->getElements()) throw new HException('null iterable');
		$»it = $this->getElements()->iterator();
		while($»it->hasNext()) {
			$element1 = $»it->next();
			$element1->value = null;
		}
	}
	public function populateElements() {
		$element = null;
		if(null == $this->getElements()) throw new HException('null iterable');
		$»it = $this->getElements()->iterator();
		while($»it->hasNext()) {
			$element1 = $»it->next();
			$element1->populate();
		}
	}
	public function getData() {
		$data = _hx_anonymous(array());
		if(null == $this->getElements()) throw new HException('null iterable');
		$»it = $this->getElements()->iterator();
		while($»it->hasNext()) {
			$element = $»it->next();
			$data->{$element->name} = $element->value;
		}
		return $data;
	}
	public function getElementTyped($name, $type) {
		$o = $this->getElement($name);
		return $o;
	}
	public function getValueOf($elementName) {
		return $this->getElement($elementName)->value;
	}
	public function getElement($name) {
		if(null == $this->elements) throw new HException('null iterable');
		$»it = $this->elements->iterator();
		while($»it->hasNext()) {
			$element = $»it->next();
			if($element->name === $name) {
				return $element;
			}
		}
		throw new HException("Cannot access Form Element: '" . $name . "'");
		return null;
	}
	public function getLabel($elementName) {
		return $this->getElement($elementName)->getLabel();
	}
	public function getFieldsets() {
		return $this->fieldsets;
	}
	public function addFieldset($fieldSetKey, $fieldSet) {
		$fieldSet->form = $this;
		$this->fieldsets->set($fieldSetKey, $fieldSet);
	}
	public function setDeleteButton($el) {
		return $this->deleteButton = $el;
	}
	public function setSubmitButton($el) {
		return $this->submitButton = $el;
	}
	public function removeElement($element) {
		if($this->elements->remove($element)) {
			$element->form = null;
			if(null == $this->fieldsets) throw new HException('null iterable');
			$»it = $this->fieldsets->iterator();
			while($»it->hasNext()) {
				$fs = $»it->next();
				$fs->elements->remove($element);
			}
			return true;
		}
		return false;
	}
	public function addElement($element, $fieldSetKey = null) {
		if($fieldSetKey === null) {
			$fieldSetKey = "__default";
		}
		$element->form = $this;
		$this->elements->add($element);
		if($fieldSetKey !== null && $this->fieldsets->exists($fieldSetKey)) {
			$this->fieldsets->get($fieldSetKey)->elements->add($element);
		}
		if(Std::is($element, _hx_qtype("microbe.form.elements.RichtextWym"))) {
			$this->wymEditorCount++;
		}
		return $element;
	}
	public $wymEditorCount;
	public $submittedButtonName;
	public $defaultClass;
	public $labelRequiredIndicator;
	public $invalidErrorClass;
	public $requiredErrorClass;
	public $requiredClass;
	public $extraErrors;
	public $deleteButton;
	public $submitButton;
	public $forcePopulate;
	public $fieldsets;
	public $elements;
	public $method;
	public $action;
	public $name;
	public $id;
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
	function __toString() { return $this->toString(); }
}
