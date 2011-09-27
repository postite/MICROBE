package microbe ;
import microbe.vo.Spodable;
import microbe.form.Form;

import microbe.form.MicroFieldList;
import microbe.form.Microfield;
import microbe.form.IMicrotype;

class MicroCreator
{
	public var result:MicroFieldList;
	private var formule: Hash<FieldType>;
	private var voName:String;
	private var formulaire:Form;
	public var data:Spodable;
	public var source:MicroFieldList;
	public function new()
	{
	
	}
	public function parse() : Void {
	//	for (a in source.iterator()){
			//trace(a.type);
		//	var factory = new TypeFactory();
		//	var behaviour=factory.create(source.type);
		//	trace(behaviour.parse(source));
	//	}
	}
	//cree les microfields avec formulaire
	public function generate(_voName:String,_formule:Hash<FieldType>,liste:MicroFieldList,?form:Form){
		result=liste;
		formule=_formule;
		voName=_voName;
		formulaire=form;
		for ( field in formule.keys()){
			var item:FieldType=formule.get(field);
			var factory = new TypeFactory();
			var behaviour=factory.create(item.type);
			behaviour.data=data;//Reflect.field(data,field);
			result.add(behaviour.create(voName,item,field,formulaire));	
		}
	}
	
	///cree les microField sans formulaire ... utilisé pour les collections
	public function justGet(_voName:String,_formule:Hash<FieldType>,liste:MicroFieldList):IMicrotype{
		//trace("creator justGet" +formule.get());
		var list= new MicroFieldList();
		for ( field in _formule.keys()){
			
			var item:FieldType=_formule.get(field);
			var factory = new TypeFactory();
			var behaviour=factory.create(item.type);
			list.add(behaviour.create(voName,item,field));	
		}
		return list	;
	}
	
	
	
	public function record() : Spodable {
		trace("record");
			for (a in source.iterator()){
					trace(a.type);
					var factory = new TypeFactory();
					var behaviour=factory.create(a.type);
					behaviour.record(a,data);
					//cast(data).sync();
				}
		return data;
	}
	
	
	public function addToForm(formulaire){
		
	}
	
}