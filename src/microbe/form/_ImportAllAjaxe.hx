package microbe.form;

import microbe.macroUtils.Imports;

class ImportAllAjaxe
{


	public static function resolveClass(voName:String):Class<Dynamic>{
		Imports.pack("microbe.form.elements",false);
		return cast  Type.resolveClass(voName);
	}
}