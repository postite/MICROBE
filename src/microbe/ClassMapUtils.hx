package microbe;
import microbe.form.MicroFieldList;
import microbe.ClassMap;
import microbe.form.IMicrotype;
import js.Lib;
class ClassMapUtils
{
	private var currentCollec:MicroFieldList;
	private var map:ClassMap;
	public var mapFields:MicroFieldList;
	private var currentVoName:String;
	private var temp:List<IMicrotype>;
	public function new(_map:ClassMap)
	{
		map=_map;
		mapFields= new MicroFieldList();
		mapFields= cast(map.fields);
		//Lib.alert("maplength"+map.fields.length);
	}

	
public function removeInCurrent(list:MicroFieldList) : Void {
	currentCollec.remove(list);
}

	public function searchinCollecByPos(pos:Int) : MicroFieldList {
		return cast(currentCollec.filter(function (item:Dynamic) : Bool{
			//js.Lib.alert("cherche"+pos);
			if(item.pos==pos){
				//js.Lib.alert("Trouvé"+pos);
				return true;
			}
			return false;
		}).first());
	}
	public function addInCollec(item:MicroFieldList) : Void {
	//	js.Lib.alert("youoho"+currentCollec.getLength());
		//untyped console.log(item);
		currentCollec.add(item);
	//	js.Lib.alert("youoho"+currentCollec.getLength());
	}
	
	public function addinCollecAt(item:MicroFieldList,pos:Int){
	var tab=Lambda.array(currentCollec.fields);
	tab.insert(pos,item);
	currentCollec.fields=Lambda.list(tab);
	}
	
	public function searchCollec(voName:String):Void {
		temp=new List<IMicrotype>();
		currentVoName=voName;
		var result=mapFields.filter(searchCollecAlgo);
	//	Lib.alert("result="+currentVoName);
		currentCollec=cast(result.first());
	//	Lib.alert("currentCollec="+result.first());
	}
	
	
	function parseCollec(collec:MicroFieldList){
		trace("<br/>collec="+collec.getLength());
	//	collec.add(creeCollecItem());
		trace("<br/>new Collec="+collec);
	}
	
	function searchCollecAlgo(item:Dynamic):Bool{

		if(item.type==collection && item.voName==currentVoName){
		//	Lib.alert("yeAHHH"+item.voName);
			temp.add(item);
			return true;
		}else{
			if(Std.is(item,MicroFieldList)){ 
			item.filter(searchCollecAlgo); 
			}
		return false;
		}
	}
	
	
}