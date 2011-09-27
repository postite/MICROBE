package microbe.form;
//import microbe.vo.Spodable;


typedef FieldType =
{
var classe:String;
var type:InstanceType;
var champs:Dynamic;
}

enum InstanceType
{
	formElement;
	collection;
	spodable;
}

interface IMicrotype
{
 	public var voName:String; //nom du vo sans le package
	public var field:String; //field in vo/sql
	public var value:String;
	public var type:InstanceType;
	
public function toString() : String ;
	
}