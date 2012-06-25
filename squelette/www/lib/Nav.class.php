<?php

class Nav extends microbe_backof_Navigation {
	public function __construct() { if(!php_Boot::$skip_constructor) {
		parent::__construct();
		$this->items = new HList();
		$a = _hx_anonymous(array());
		$a->data = 1;
		$a->label = "news";
		$a->vo = "News";
		$b = _hx_anonymous(array());
		$b->data = 2;
		$b->label = "edito";
		$b->vo = "Edito";
		$c = _hx_anonymous(array());
		$c->data = 3;
		$c->label = "relationTest";
		$c->vo = "RelationTest";
		$this->items->add($a);
		$this->items->add($b);
		$this->items->add($c);
	}}
	function __toString() { return 'Nav'; }
}
