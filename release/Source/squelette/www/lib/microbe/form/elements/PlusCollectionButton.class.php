<?php

class microbe_form_elements_PlusCollectionButton extends microbe_form_elements_Button {
	public function __construct($_data = null, $_collec) {
		if(!php_Boot::$skip_constructor) {
		parent::__construct("name","plus",null,microbe_form_elements_ButtonType::$BUTTON,null);
		$transport = _hx_anonymous(array("data" => haxe_Unserializer::run($_data), "collec" => haxe_Unserializer::run($_collec)));
		$nom = $transport->collec->voName . "_" . $transport->collec->field;
		$this->name = $nom . "_" . $this->label;
		$this->Xtransport = haxe_Serializer::run($transport);
	}}
	public function render($iter = null) {
		return "<button type=\"" . Std::string($this->type) . "\" class=\"" . $this->getClasses() . "\" name=\"" . $this->form->name . "_" . $this->name . "\" id=\"" . $this->form->name . "_" . $this->name . "\" value=\"" . $this->Xtransport . "\"  >" . $this->label . "</button>";
	}
	public $Xtransport;
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
	function __toString() { return 'microbe.form.elements.PlusCollectionButton'; }
}
