package microbe;

import microbe.form.MicroFieldList;
import microbe.MicroCreator;
import microbe.vo.Spodable;
import microbe.form.IMicrotype;
class Output
{
	var hash:Hash<Dynamic>;
	private var voName:String;
	private var data:Spodable;
	public function new(spod:Spodable,?_voName:String)
	{
		data=spod;
		voName=_voName;
		hash= new Hash<Dynamic>();
		var formule=spod.getFormule();
		for (field in formule.keys()){
			//if(Std.is(formule.get(field).champs,String))
			/*try{
			if 
							hash.set(field,Reflect.callMethod(spod, Reflect.field(spod, "get_"+field),[]));
							continue;
						}	catch( msg : String ) {
								hash.set(field,msg);
							  // continue;
						}*/
						
		/*if(formule.get(field).champs==null){
				//	hash.set(field,Reflect.callMethod(spod, Reflect.field(spod, "get_"+field),[]));
				var subSpods:List<Spodable>=Reflect.callMethod(spod,Reflect.field(spod, "get_"+field),[]);
				var liste = new List<Dynamic>();//cast(spod).get_voitures().length;
				 for(subField in subSpods.first().getFormule().keys()){
					liste.add(subField);
					}
				hash.set(field,liste);
				}else{*/
	if(Std.is(formule.get(field).champs,List)){
		var neoHash=new Hash<>();
		var liste:List<Spodable>=formule.get(field).champs;
		var neoList=new List<>();
		var subFormule:Hash<FieldType>=liste.first().getFormule();
		for( item in liste){
			for(subField in subFormule.keys()){
						neoHash.set(subField,subFormule.get(subField).champs);
					}
					neoList.add(neoHash);
		}
		hash.set(field,neoList);
	}else{
		hash.set(field,formule.get(field).champs);	
	}
	//	hash.set(field,"formule.get(field).champs");	
	//	}				
						
		
			//Reflect.callMethod(ob, Reflect.field(ob, "methodname"), []);
		}
		
	}
	function parse():MicroFieldList{
		var newList:MicroFieldList= new MicroFieldList();
		var creator=new MicroCreator();
		creator.data=this.data;
		creator.generate("vo."+voName, data.getFormule(),newList);
		return newList;
	}
	
	public function render():String{
		/*var hache= new Hash<String>();
				hache.set("one","un");
				hache.set("two","deux");
		var hacsz=haxe.Serializer.run(hache);*/
	//	return haxe.Serializer.run(parse());	
	//	return hash;
	return haxe.Serializer.run(hash);
	}
}