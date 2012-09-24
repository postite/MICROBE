package microbe.factoryType;
//import microbe.vo.Taggable;
import sys.db.Object;
import microbe.controllers.GenericController;
/*import vo.Monstre;*/
import microbe.form.Form;
import microbe.form.Microfield;
import microbe.form.MicroFieldList;
import microbe.form.IMicrotype;
import microbe.vo.Spodable;
import php.Lib;



////implementer les tags la dedans?

class SpodableBehaviour implements IBehaviour
{
	public var data:Spodable;
	public function new()
	{
microbe.tools.Mytrace.setRedirection();
	}
	
	
	public function parse(source:IMicrotype):String{
		var castedsource:MicroFieldList= cast source;
		for(a in castedsource.iterator()){
			var parser=new MicroParser(a);
			parser.parse();
		}
		return "i'm a spod" + source.voName;
	}

	public function create(voName:String,element:FieldType,field:String,?formulaire:Form):IMicrotype{ 
		trace("im'a spod");
		var liste= new MicroFieldList();
		var fieldClass= Type.resolveClass(element.classe);
		var instanceClass:Spodable=Type.createInstance(fieldClass,[]);

		//on on recurse
		var sousVoName=Lambda.list(element.classe.split(".")).last();
		liste.field=field;  //--- pas pris en compte
		liste.type=spodable;
		liste.voName=sousVoName; 
		var creator=new MicroCreator();
		creator.data= Reflect.callMethod(data,"get_"+field,[]);
		creator.generate(sousVoName,instanceClass.getFormule(),liste,formulaire);
		return liste;
	}
	public function record(source:IMicrotype,data:Spodable) : Spodable {
		//trace("spodable");
		var voInstance=null;
			var castedsource:MicroFieldList= cast source;
			if(data.id==null){
			 voInstance=Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),[]);
			}else{
			 voInstance=Reflect.callMethod(data, Reflect.field(data, "get_"+source.field), [voInstance]);	
			}
			//for(a in castedsource.iterator()){
			//	trace("bip="+a);
				var parser=new MicroCreator();
				parser.source=castedsource;
				parser.data=voInstance;

				var child:Object=cast parser.record();
				if (cast(child).id==null){
				child.insert();
				}else{
				child.update();
				}
				//child.sync(); //HAck
				Reflect.callMethod(data, Reflect.field(data, "set_"+source.field), [voInstance]);
			//}
			
			return data;
	}
	
	public function delete(voName:String,id:Int):Void{
		
	}
	
}