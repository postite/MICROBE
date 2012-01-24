package microbe.factoryType;
import microbe.vo.Imbricable;
import microbe.form.elements.PlusCollectionButton;
import microbe.form.elements.CollectionWrapper;
import microbe.form.elements.Button;
import sys.db.Object;
import microbe.controllers.GenericController;
/*import vo.ProprietaireVo;*/
import microbe.form.FormElement;
import microbe.form.MicroFieldList;
import microbe.vo.Spodable;
import microbe.form.Form;
import microbe.form.Microfield;
import microbe.form.IMicrotype;
import microbe.form.elements.CollectionElement;
class CollectionBehaviour implements IBehaviour
{
	public var data:Spodable;
	
	var tempPos:IntHash<Int>;
	public function new()
	{

	}
	public function parse(source:IMicrotype):String{
		return "im a Collection";
		var parser=new MicroParser(source);
		parser.parse();
	} 
	public function create(voName:String,element:FieldType,field:String,?formulaire:Form):IMicrotype{ 
		trace("create collection "+element.classe);

		//instancie un spod de la collection
		var fieldClass= Type.resolveClass(element.classe);
		var instanceClass:Spodable=Type.createInstance(fieldClass,[]);
		//recupere le nom sans le package
		var sousVoName=Lambda.list(element.classe.split(".")).last();
		
		// nouvelle microfieldList celle qui est retournée à la fin de cette fonction 
		var newCollec=new MicroFieldList();
		newCollec.type= collection;
		newCollec.voName=sousVoName;
		newCollec.field=field;
		newCollec.elementId=voName+"_"+field+"_"+sousVoName;

		//// recupere les champs du sousVo
		var creator=new MicroCreator();
		var collec:MicroFieldList=cast creator.justGet(sousVoName,instanceClass.getFormule());
		collec.voName=sousVoName;
		collec.type=spodable;
		collec.field=field;
		collec.elementId=newCollec.elementId;
		collec.pos=0;
		
		var graine:Int=0;
		var wrapper= new CollectionWrapper(sousVoName); //php
		formulaire.addElement(wrapper);
		
		if (data.id!=null){
			
			//trace("----------------------voiture="+tempPos+"<br/>");
			trace("y'a de la data"+data.id);
			newCollec.id=data.id;
			//recupere les données
			var voitures:List<Spodable>=cast Reflect.field(data,field);
		
			
			
		
			var micros:List<FormElement>= new List<FormElement>(); //?
			
			if( voitures.length>0){
			//debut iteration des sous-vo
			for (car in voitures.iterator()){
				
				var micros:List<FormElement>= new List<FormElement>();
			
				var parent = Reflect.field(instanceClass,"rel"); ///dependance à rel
				
				
				//on checque les formElements  item:MicroField
				
				var spodList:MicroFieldList= new MicroFieldList();
				spodList.voName= sousVoName;
				spodList.type=spodable;
				spodList.field=field;
				spodList.id=car.id;
				spodList.pos=car.poz;
				spodList.elementId=collec.elementId;

				
					
				for (item in collec){
					/// cree un microfield pour chaque champs actif (ajaxelement) de collec /sousSpod
					var bum=new Microfield();

					bum.value= Reflect.field(car,item.field);//"poiipo"+Std.string(graine);//car.nom;//TODO

					bum.type=item.type;
					bum.voName=item.voName;
					bum.elementId=collec.elementId+"_"+item.field+"_"+graine;
					bum.element=cast(item,Microfield).element;
					bum.field=item.field;
					spodList.add(bum);


					var elem:FormElement=creeAjaxFormElement(cast bum,Std.string(graine));
					micros.add(elem);
					
					}//fin item in collec*/	
					
					//si data mais pas de collec encore...
			
					
					//creation du wrapper qui va faire un render() sur tous les formelement creeé depuis bum
	//RENAMING				var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[sousVoName+"_"+field,field,micros,graine,spodList.pos]);
					var microWrapper:CollectionElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[spodList.elementId,field,micros,graine,spodList.id]);
					//formulaire.addElement(microWrapper);///warning
					wrapper.addElement(cast microWrapper);
					graine++;
					//trace("spod="+spodList.fields.last().value);
					newCollec.add(spodList);
					}//fin voiture iterator
					
				//si pas de données de collection
				}else{
					
					var car=instanceClass;
					
					var micros:List<FormElement>= new List<FormElement>();

					var parent = Reflect.field(instanceClass,"rel"); ///dependance à rel


					//on checque les formElements  item:MicroField

					var spodList:MicroFieldList= new MicroFieldList();
					spodList.voName= sousVoName;
					spodList.type=spodable;
					spodList.field=field;
					spodList.id=car.id;
					spodList.pos=car.poz;
					spodList.elementId=collec.elementId;



					for (item in collec){
						/// cree un microfield pour chaque champs actif (ajaxelement) de collec /sousSpod
						var bum=new Microfield();

						bum.value= Reflect.field(car,item.field);//"poiipo"+Std.string(graine);//car.nom;//TODO

						bum.type=item.type;
						bum.voName=item.voName;
						bum.elementId=collec.elementId+"_"+item.field+"_"+graine;
						bum.element=cast(item,Microfield).element;
						bum.field=item.field;
						spodList.add(bum);


						var elem:FormElement=creeAjaxFormElement(cast bum,Std.string(graine));
						micros.add(elem);

						}//fin item in collec*/	

						//si data mais pas de collec encore...


						//creation du wrapper qui va faire un render() sur tous les formelement creeé depuis bum
		//RENAMING				var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[sousVoName+"_"+field,field,micros,graine,spodList.pos]);
						var microWrapper:CollectionElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[spodList.elementId,field,micros,graine,spodList.id]);
						//formulaire.addElement(microWrapper);///warning
						wrapper.addElement(cast microWrapper);
						graine++;
						//trace("spod="+spodList.fields.last().value);
						newCollec.add(spodList);
					
					
					
					
					
					
					
					
				}
					return newCollec;	
					} //fin if data

/////////////////////pour un nouvel element clique sur 'ajoute' ///////////////
					else{
						
								var micros:List<FormElement>= new List<FormElement>();
								 for (item in collec){
								

									item.type=item.type;
									item.voName=item.voName;
									cast(item).elementId=collec.elementId+"_"+item.field;
									item.field=item.field;
									
								 var elem:FormElement= creeAjaxFormElement(cast item,Std.string(graine));
								 micros.add(elem);	
								  		}
								 var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[collec.elementId,"patapouf",micros,graine,0]);
								 wrapper.addElement(cast(microWrapper));
								 
								 newCollec.add(collec);
								 return newCollec;		
						//fin no data
					}	






		return collec;
	}

	public static function creeEmptyCollection(voName:String,element:FieldType,field:String,graine:Int):Dynamic{
	//	microbe.macroUtils.Imports.pack("microbe.form.elements",false);
		//instancie un spod de la collection  //ChildTest + vo package
		var fieldClass= Type.resolveClass(element.classe);
		var instanceClass:Spodable=Type.createInstance(fieldClass,[]);
		//recupere le nom sans le package
		var sousVoName=Lambda.list(element.classe.split(".")).last();
		
		// nouvelle microfieldList celle qui est retournée à la fin de cette fonction 
		var newCollec=new MicroFieldList();
		newCollec.type= collection;
		newCollec.voName=sousVoName;
		newCollec.field=field;
		newCollec.elementId=voName+"_"+field+"_"+sousVoName;

		//// recupere les champs du sousVo
		var creator=new MicroCreator();
		var collec:MicroFieldList=cast creator.justGet(sousVoName,instanceClass.getFormule());
		collec.voName=sousVoName;
		collec.type=spodable;
		collec.field=field;
		collec.elementId=voName+"_"+field+"_"+sousVoName;
		
		
		//var wrapper= new CollectionWrapper(sousVoName); //php
		//formulaire.addElement(wrapper);
		//n'a pas besoin de wrapper'
		
		var micros:List<FormElement>= new List<FormElement>();
		 for (item in collec){
			item.type=item.type;
			item.voName=item.voName;
			cast(item).elementId=collec.elementId+"_"+item.field+"_"+graine;
			item.field=item.field;
			
		 var elem:FormElement= creeAjaxFormElement(cast item,Std.string(graine));
		 micros.add(elem);	
		  		}
		
		 var microWrapper:CollectionElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[collec.elementId,"patapouf",micros,graine,null]);
		 newCollec.add(collec);
		
		 return {microliste:newCollec,element:microWrapper.render()};
	}


	public function record(source:IMicrotype,data:Spodable) : Spodable {
		trace("record collection"+data.id);
		
//<positions>		
	//	tempPos=new IntHash<Int>();
//</positions>


	//	trace("SOURCE="+source);
		//cast(data).sync();
			var collectionList= new List();
			var castedsource:MicroFieldList= cast source;
			//var voInstance=Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),[]);
			var childRefs:List<Object>= new List<Object>();
			
			if(data.id==null){
				trace("data.id==NULL");
			for(a in castedsource.iterator()){
				trace("bip="+a.type);//spodable
				var  data=Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),[]);
				
				var parser=new MicroCreator();
				parser.source=cast a;
				parser.data=cast(data);
				var child:Object=cast parser.record();
				trace("child_titre="+Reflect.field(child,"titre"));
				Reflect.callMethod(child, "set_rel", [data]);
				childRefs.add(child);
				
			}
			trace("after nodataid");
		}else{
			trace("DATA.ID exist");
			//recuperation des id des elements existants
			//var refs:List<Spodable>=Reflect.callMethod(data, Reflect.field(data, "get_"+castedsource.field),[]);
			var refs:List<Spodable>=Reflect.field(data,castedsource.field);
			trace("------hopopop="+refs);
		//	var fields=castedsource.fields;
			
			var iter=castedsource.iterator();
			for (spodcollection in castedsource){
				trace("iterate in castedSource");
//<positions>				
			//	tempPos.set(cast(spodcollection,MicroFieldList).pos, cast(spodcollection).id);
//</positions>
				
				//check si element existe déja
				if(cast(spodcollection).id !=null ){
					trace("collection id exist");
				//il faut recuperer le spod ...
				var  manager=cast Reflect.field(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),"manager");
				var ref=manager.unsafeGet(cast(spodcollection).id,true);
				
				var parser=new MicroCreator();
								parser.source=cast(spodcollection);
								parser.data=cast(ref);
								var child:Object=cast parser.record();	
						//	Reflect.setField(child,"rel", data);			
								Reflect.callMethod(child, "set_rel", [data]);
								childRefs.add(child);
								
				//si il a été créé onthe fly....	
				}else{
					trace("collection id does not exist");
					var  voInstance=Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),[]);
					var parser=new MicroCreator();
					
					parser.source=cast(spodcollection);
					parser.data=cast(voInstance);
					
					var child:Object=cast parser.record();
					Reflect.callMethod(child, "set_rel", [data]);
					childRefs.add(child);
				//	trace("after create" +Reflect.field(Reflect.field(child,"rel"),"id"));
				}
				
				
			}
			
			
			
			
			
			
			/* for (ref in refs.iterator()){
							
							var parser=new MicroCreator();
											parser.source=cast iter.next();
											parser.data=cast(ref);
											var child:Object=cast parser.record();				
											Reflect.setField(child, "rel", data);
											childRefs.add(child);
							
							}*/
			
			
		}


	
	//	cast(data).positions=haxe.Serializer.run(tempPos);
	//cast (data).lock();		
		
		if(data.id==null){
		//	cast(data).lock();
		cast(data).insert();
		trace("after insert");						
		}else{
		trace("data.id!=null");
		//trace("------------data="+cast(data).nom+"---------"+cast(data).positions+"\n");
		cast(data).update();
		trace("after update");
		}
		//cast(data).sync();
			
			for(c in childRefs){
						if(cast(c).id!=null){
							trace("update child");
							var rel=Reflect.field(c,"rel");
							//Reflect.callMethod(c, "set_rel", [data]);
						//trace(Reflect.field(rel, "id"));
						c.update();
						}else{
							trace("insert child");
							var rel=Reflect.field(c,"rel");
							Reflect.callMethod(c, "set_rel", [data]);
							trace(Reflect.field(rel, "id"));
						//	c.update();
						//	c.insert();
						
						//Reflect.setField(d, "rel", data);
						
						c.insert();
						}
						}	
						trace("END");
		//trace("------fin------data="+cast(data).nom+"---------"+cast(data).positions);		
				return data;
	}
	

	static function creeAjaxFormElement(microfield:Microfield,?graine:String=""):Dynamic{
		//microfield= item in collec ou bum
	///	var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.voName+"_"+microfield.field+graine, microfield.field, null, null, null, null]);
		var microbeFormElement:Dynamic= Type.createInstance(Type.resolveClass(microfield.element),[microfield.elementId, microfield.field, null, null, null, null]);
		//microfield.elementId =formulaire.name+"_"+microfield.voName+"_"+microfield.field+graine;
		//microfield.elementId ="collectionBehaviourcreaAjaxlmnt";

		//microbeFormElement.value= microfield.value;
		//microbeFormElement.cssClass="generatorClass";
		return microbeFormElement;
	}
	public function delete(voName:String,id:Int) : Void {
		
	}
	
	
}