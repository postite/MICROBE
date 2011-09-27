package microbe.factoryType;
import microbe.vo.Spodable;
import microbe.form.MicroFieldList;
import microbe.form.Form;

import microbe.form.IMicrotype;

interface IBehaviour
{
	public var data:Spodable;
	public function parse(source:IMicrotype):String;
	public function create(voName:String,fieldtype:FieldType,field:String,?formulaire:Form):IMicrotype;
	public function record(source:IMicrotype,data:Spodable):Spodable;
	public function delete(voName:String,id:Int):Void;
	
}