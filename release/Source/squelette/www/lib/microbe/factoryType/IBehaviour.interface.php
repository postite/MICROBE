<?php

interface microbe_factoryType_IBehaviour {
	function delete($voName, $id);
	function record($source, $data);
	function create($voName, $fieldtype, $field, $formulaire = null);
	function parse($source);
	//;
}
