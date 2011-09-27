package microbe;

import microbe.form.IMicrotype;

import microbe.form.MicroFieldList;
class ClassMap
{
	public var id:Int;
	public var voClass:String; //attention y'a le package avec
	public var fields:MicroFieldList; //microfields or list<Microfield>
	public var submit:String;
	public var action:String;
	function toString() : String {
		return fields.toString();
	}
	
	public function new()
	{
		
	}
}