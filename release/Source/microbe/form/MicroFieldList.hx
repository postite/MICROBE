package microbe.form;
import microbe.form.IMicrotype;
//import microbe.vo.Spodable;
// à implementer sur demande
import haxe.Json;
class MicroFieldList implements IMicrotype //, implements List<Dynamic> 
{
	
	//implementation succinte de Microfield
	public var field:String;
	public var voName:String;
	public var value:String;
	public var id:Int; //id du voCorrespondant...pour check si update
	public var elementId:String; ///pour les collections 
	public var type:InstanceType;
	public var fields:List<IMicrotype>; //composition
	private var indent:Int;
	public var length(getLength,null) : Int;
	public var pos:Int;
	public var taggable:Bool;
	public var traductable:Bool;
	
	public function new()
	{
		fields=new List<IMicrotype>();
	}
	public function getLength():Int{
		return fields.length;
	}
	public function add(item:IMicrotype):IMicrotype{
		fields.add(item);
		return item;
	}
	public function iterator():Iterator<IMicrotype>{
		return fields.iterator();
	}
	public function first(){
		return fields.first();
	}
	public function last(){
		return fields.last();
	}
	public function next(){
		return fields.iterator().next();
	}
	public function remove( v : Dynamic ) : Bool {
		return fields.remove(v);
	}
	public function filter( f : Dynamic -> Bool ){
		return fields.filter(f);
	}
	public function map<X>(f : Dynamic -> X) : List<X> {
		return fields.map(f);
	}
	
	
	public function toString():String{
		//attention ne prends pas en compte les microFields Fields
		indent++;
		#if (php )
		return "<div class='indent"+indent+"'><div class='microtrace'><p>MICROFIELDLIST: "+ voName + "</p><p>-"+", TYPE:"+type+" TAGGABLE="+taggable+"  POS:"+pos+", FIELD:"+field+"  ID:"+id+ "ElementId:"+elementId+", VALUE:"+value+ "</p><p>"+fields.toString()+"</p></div></div>";
		#end
		
		#if (flash || js)
		return "MICROFIELDLIST: "+ voName +", TYPE:"+type+", FIELD:"+field+"  ID:"+id+",ElementId:"+elementId+" pos="+pos+" VALUE:"+value+ "\n"+fields.toString()+"\n";
		#end
		
		return "";
		
	}
	
	
}