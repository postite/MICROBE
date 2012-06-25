<?php

interface microbe_factoryType_IBehaviour {
	//;
	function parse($source);
	function create($voName, $fieldtype, $field, $formulaire);
	function record($source, $data);
	function delete($voName, $id);
}
