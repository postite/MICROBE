package microbe.form;
using microbe.tools.Debug;
import js.JQuery;
import microbe.form.Microfield;
import microbe.jsTools.BackSignal;


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

		BackSignal.erreur.add(onError);
	//	self=this;
	}
	public function onError(er:microbe.ERROR) 
	{
		trace("onERROR"+er.forfield +"/"+this.field);
		if( er.forfield!=null){
			if (this.field == er.forfield){
				trace("ERROR"+er.forfield +"==?"+this.field +"id="+this.id);
			new js.JQuery("#"+this.id).css("background","red");
			BackSignal.tryAgain.addOnce(tryAgain);
			}
		}
	}
	public function tryAgain() 
	{
	new JQuery(" #"+this.id).focus(function(e)new JQuery(" #"+this.id).css("background",""));
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