<?php

class microbe_form_elements_RichtextWym extends microbe_form_FormElement {
	public function __construct($name, $label, $value, $required, $attibutes) {
		if(!php_Boot::$skip_constructor) {
		if($attibutes === null) {
			$attibutes = "";
		}
		if($required === null) {
			$required = false;
		}
		parent::__construct();
		$this->name = $name;
		$this->label = $label;
		$this->value = $value;
		$this->required = $required;
		$this->attributes = $attibutes;
		$this->width = 500;
		$this->height = 300;
		$this->allowImages = true;
		$this->allowTables = false;
		$this->editorStyles = "";
		$this->containersItems = "";
		$this->classesItems = "";
	}}
	public $width;
	public $height;
	public $allowImages;
	public $allowTables;
	public $editorStyles;
	public $containersItems;
	public $classesItems;
	public function render($iter) {
		$n = $this->name;
		$this->editorStyles = str_replace("\x0A", " ", $this->editorStyles);
		$this->editorStyles = str_replace("\x0D", " ", $this->editorStyles);
		$str = new StringBuf();
		$str->add("\x0A <textarea name=\"" . $n . "\" id=\"" . $n . "\" >" . $this->value . "</textarea>");
		$str->add("<script type=\"text/javascript\">");
		$str->add("jQuery(function() {");
		$str->add("\x09jQuery('#" . $n . "').wymeditor({");
		$str->add("logoHtml: '',");
		$str->add("editorStyles: [\"" . $this->editorStyles . "\"],");
		$str->add("skin:'compact',");
		$str->add("postInit: function(wym) {");
		$str->add("\x09jQuery(wym._box).find(wym._options.containersSelector).removeClass('wym_dropdown').addClass('wym_panel').find('h2 > span').remove();");
		$str->add("\x09jQuery(wym._box).find(wym._options.iframeSelector).css('height', '" . $this->height . "px').css('width', '" . $this->width . "px');");
		$str->add("},");
		$str->add("toolsItems: [");
		$str->add("\x09{'name': 'Bold', 'title': 'Strong', 'css': 'wym_tools_strong'}, ");
		$str->add("\x09{'name': 'Italic', 'title': 'Emphasis', 'css': 'wym_tools_emphasis'},");
		$str->add("\x09{'name': 'CreateLink', 'title': 'Link', 'css': 'wym_tools_link'},");
		$str->add("\x09{'name': 'Unlink', 'title': 'Unlink', 'css': 'wym_tools_unlink'},");
		if($this->allowImages) {
			$str->add("{'name': 'InsertImage', 'title': 'Image', 'css': 'wym_tools_image'},");
		}
		$str->add("\x09{'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'},");
		$str->add("\x09{'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'},");
		if($this->allowTables) {
			$str->add("{'name': 'InsertTable', 'title': 'Table', 'css': 'wym_tools_table'},");
		}
		$str->add("\x09{'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'},");
		$str->add("\x09{'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'},");
		$str->add("\x09{'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'},");
		$str->add("\x09{'name': 'ToggleHtml', 'title': 'HTML', 'css': 'wym_tools_html'}");
		$str->add("],");
		$str->add("containersItems: [" . $this->containersItems . "],");
		if($this->classesItems !== "") {
			$str->add("classesItems: [" . $this->classesItems . "],");
		} else {
			$str->add("classesHtml: '',");
		}
		$str->add("postInitDialog: function (wym, wdw) { if(wymeditor_filebrowser != null) wymeditor_filebrowser(wym, wdw); }");
		$str->add("\x09});");
		$str->add("});");
		$str->add("</script>");
		if(!$this->isValid()) {
			$str->add(" required");
		}
		return $str->b;
	}
	public function toString() {
		return $this->render(null);
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
	function __toString() { return $this->toString(); }
}
