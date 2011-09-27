package microbe.form;
using microbe.tools.Debug;
import js.JQuery;
import microbe.form.Microfield;

class AjaxElement  {
	
	
	public static var debug=false;
	
	public var id:String;
	public var microfield:Microfield;
	public var microfieldliste:MicroFieldList;
	public var field:String;
	public var element:String;
	public var value:String;
	public var pos:Int;
	public var voName:String;
	public var spodId:Int;
//	public var self:AjaxElement;
	public function new(_microfield:IMicrotype,?_iter:Int){
		
		"new".Alerte();
		if( Std.is(_microfield,Microfield)){
		microfield=cast _microfield;
		this.id=cast (_microfield).elementId;
		this.field=cast (_microfield).field;
		this.element=cast (_microfield).element;
		this.value=cast (_microfield).value;
		}
		if( Std.is(_microfield,MicroFieldList)){
			microfieldliste=cast(_microfield);
			this.id=cast (_microfield).elementId;
			this.field=cast (_microfield).field;
			this.element=cast (_microfield).element;
			this.value=cast (_microfield).value;
			this.voName=cast(_microfield).voName;
			this.spodId=cast(_microfield).id;
		}
		if (_iter!=null) pos=_iter;
		setValue(value);
	//	self=this;
	}

	public function focus() : Void {
		new JQuery("#"+id).addClass("borded");
	}
	public function getForm():String{
	var p:JQuery =new JQuery("#"+id).parents("form");
	return p.attr("id");
	}
	public 	function output() : String {
		return "yop";
	}
	public function getValue():String{
		//to be overriden
		return "null";
	}
	public function setValue(val:String):Void{
		
	}
	
	
}