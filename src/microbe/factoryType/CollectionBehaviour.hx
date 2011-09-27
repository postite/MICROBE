package microbe.factoryType;
import microbe.vo.Imbricable;
import microbe.form.elements.PlusCollectionButton;
import microbe.form.elements.CollectionWrapper;
import microbe.form.elements.Button;
import php.db.Object;
import microbe.controllers.GenericController;
/*import vo.ProprietaireVo;*/
import microbe.form.FormElement;
import microbe.form.MicroFieldList;
import microbe.vo.Spodable;
import microbe.form.Form;
import microbe.form.Microfield;
import microbe.form.IMicrotype;

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
		var liste= new MicroFieldList();
		var fieldClass= Type.resolveClass(element.classe);
		var instanceClass:Spodable=Type.createInstance(fieldClass,[]);
	//	var parent= cast Type.createInstance(cl : Class<T>, args : Array<Dynamic>)
		
	//	trace("parentManager="+parentManager.positions);
		
		trace("souSVO"+instanceClass.getFormule());
		//on on recurse
		var sousVoName=Lambda.list(element.classe.split(".")).last();
		liste.field=field;  //--- pas pris en compte
		liste.type=collection;
		liste.voName=sousVoName; 

		var creator=new MicroCreator();
		var collec:MicroFieldList=cast creator.justGet(sousVoName,instanceClass.getFormule(),liste);
		collec.voName=sousVoName;
		collec.type=spodable;
		collec.field=field;
		collec.elementId=formulaire.name+"_"+sousVoName+"_"+field;
		collec.pos=0;
		trace("collec="+collec);
		var graine:Int=0;
		var wrapper= new CollectionWrapper();
		
		formulaire.addElement(wrapper);
		if (data.id!=null){
		
		
			/////gestion des positions
			var parentManager=cast(Type.resolveClass("vo."+voName)).manager;
			var parent:Imbricable=parentManager.get(data.id,true);
			
//<gestion des positions>			
			if(parent.positions !=null){
			trace("parent.position"+parent.positions);
			trace("------"+haxe.Unserializer.run(parent.positions));
			tempPos=haxe.Unserializer.run(parent.positions);
			}else{
			tempPos=new IntHash<Int>();
			}
//</gestion de positions>
			
			
			
			
			trace("----------------------voiture="+tempPos+"<br/>");
			trace("y'a de la data"+collec.field);
			var voitures:List<Spodable> = cast Reflect.callMethod(data,"get_"+field,[]);
			//trace("voitures.length"+voitures.first().nom);
			trace("afterReflect");


			var newCollec=new MicroFieldList();
			newCollec.type= collection;
			newCollec.voName=sousVoName;
			newCollec.field=field;
			newCollec.elementId=formulaire.name+"_"+sousVoName+"_"+field;
			
			var micros:List<FormElement>= new List<FormElement>();

			for (car in voitures.iterator()){
				var micros:List<FormElement>= new List<FormElement>();
			//	parentManager.positions.set(3,4);
				var parent = Reflect.field(instanceClass,"rel");
				
 //<positions>	
	if( parent.positions != null)
  	trace("----------------------voiture="+tempPos.get(graine)+"<br/>");
  //</positions>
				var testItem:Microfield=null;
				//on checque les formElements  item:MicroField
				
				var spodList:MicroFieldList= new MicroFieldList();
				spodList.voName= sousVoName;//   car.nom+graine;//attention je remplace le voName par l'idDom pour matche l'ajaxe
				spodList.type=spodable;
				spodList.field=field;
				spodList.id=car.id;
				spodList.pos=graine;

				for (item in collec){
					var bum=new Microfield();

					bum.value= Reflect.field(car,item.field);//"poiipo"+Std.string(graine);//car.nom;//TODO

					bum.type=item.type;
					bum.voName=item.voName;
					bum.elementId=cast(item,Microfield).elementId+graine;
					bum.element=cast(item,Microfield).element;
					bum.field=item.field;
					spodList.add(bum);


					var elem:FormElement=creeAjaxFormElement(formulaire,cast bum,Std.string(graine));
					micros.add(elem);
					//testItem=cast item;
					}//fin item in collec*/	
					var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[sousVoName+"_"+field,field,micros,graine,graine]);
					//formulaire.addElement(microWrapper);///warning
					wrapper.addElement(cast microWrapper);
					graine++;
					trace("spod="+spodList.fields.last().value);
					newCollec.add(spodList);
					}//fin voiture iterator
					
					//-------------ajoute bouton ----------------//
						var micros:List<FormElement>= new List<FormElement>();
						for (item in collec){
							var elem:FormElement= creeAjaxFormElement(formulaire,cast item,"pitecanthrope");
							micros.add(elem);	

						}
						var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[sousVoName+"_"+field,"patapouf",micros,"pitecanthrope",graine]);
						formulaire.addElement(microWrapper);//warning
						
						//liste.add(collec);
					//

					//name:String, label:String, ?value:String = null, ?type:ButtonType = null,?link:String=null
					//var bouton =new Button("plus","plus",null,ButtonType.BUTTON,"monjs.Ajaxe.instance.PlusCollection('"+haxe.Serializer.run(microWrapper.render(2000))+"','"+haxe.Serializer.run(collec)+"')");
					var bouton=new PlusCollectionButton(haxe.Serializer.run(microWrapper.render(2000)),haxe.Serializer.run(collec));
					bouton.cssClass="plusCollectionButton";
				
					wrapper.addElement(cast(bouton));
					formulaire.removeElement(microWrapper);
					//------------- fin ajoute bouton ----------------//


					//parent.positions=haxe.Serializer.run(tempPos);
					//	liste.add(newCollec);
					return newCollec;	
					} //fin if data

/////////////////////pour un nouvel element clique sur 'ajoute' ///////////////
					else{
						trace("ajoute");
						
						
						
						//-------------ajoute bouton ----------------faut le mettre avant je sais pas pouruoi TODO//
						var microsPlus:List<FormElement>= new List<FormElement>();
																	for (item in collec){
																	var elem:FormElement= creeAjaxFormElement(formulaire,cast item,"pitecanthrope");
																	microsPlus.add(elem);	
																	}
																	var microWrapperPlus:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[sousVoName+"_"+field,"patapouf",microsPlus,"pitecanthrope"]);
																	wrapper.addElement(microWrapperPlus);
																						//formulaire.addElement(microWrapperPlus);
																	var bouton =new Button("plus","plus",null,ButtonType.BUTTON,"monjs.Ajaxe.instance.PlusCollection('"+haxe.Serializer.run(microWrapperPlus.render(2000))+"','"+haxe.Serializer.run(collec)+"')");
																						
												
												
						//------------- fin ajoute bouton ----------------//
						
						
								var micros:List<FormElement>= new List<FormElement>();
								for (item in collec){
								var elem:FormElement= creeAjaxFormElement(formulaire,cast item,Std.string(graine));
								micros.add(elem);	
								}
						var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[voName+"_"+field,"patapouf",micros,graine,graine]);
						wrapper.addElement(cast(microWrapper));
									//formulaire.addElement(microWrapper);
						liste.add(collec);
						
									//formulaire.addElement(bouton);
						
					wrapper.addElement(cast(bouton));
						
					wrapper.removeElement(microWrapperPlus);
									//formulaire.removeElement(microWrapper);
									//formulaire.removeElement(microWrapperPlus);
						
						return liste;
					}	






		return collec;
	}

	public function record(source:IMicrotype,data:Spodable) : Spodable {
		trace("collection"+data.id);
		
//<positions>		
	//	tempPos=new IntHash<Int>();
//</positions>


		trace("SOURCE="+source);
		//cast(data).sync();
			var collectionList= new List();
			var castedsource:MicroFieldList= cast source;
			//var voInstance=Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),[]);
			var childRefs:List<Object>= new List<Object>();
			
			if(data.id==null){
			
			
			
			for(a in castedsource.iterator()){
				trace("bip="+a.type);//spodable
				var  voInstance=Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),[]);
				var parser=new MicroCreator();
				parser.source=cast a;
				parser.data=cast(voInstance);
				var child:Object=cast parser.record();
						
				Reflect.setField(child,"rel", data);
				childRefs.add(child);

			}
			
		}else{
			
			//recuperation des id des elements existants
			var refs:List<Spodable>=Reflect.callMethod(data, Reflect.field(data, "get_"+castedsource.field),[]);
			trace("------hopopop="+refs);
		//	var fields=castedsource.fields;
			
			var iter=castedsource.iterator();
			for (spodcollection in castedsource){
//<positions>				
				tempPos.set(cast(spodcollection,MicroFieldList).pos, cast(spodcollection).id);
//</positions>
				
				//check si element existe déja
				if(cast(spodcollection).id !=null ){
				//il faut recuperer le spod ...
				var  manager=cast Reflect.field(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),"manager");
				var ref=manager.get(cast(spodcollection).id,true);
				
				var parser=new MicroCreator();
								parser.source=cast(spodcollection);
								parser.data=cast(ref);
								var child:Object=cast parser.record();				
								Reflect.setField(child, "rel", data);
								childRefs.add(child);
				//si il a été créé onthe fly....	
				}else{
					var  voInstance=Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+castedsource.voName),[]);
					var parser=new MicroCreator();
					
					parser.source=cast cast(spodcollection);
					parser.data=cast(voInstance);
					
					var child:Object=cast parser.record();

					Reflect.setField(child,"rel", data);
					childRefs.add(child);
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
		
//<positions>	
		//cast(data).nom=cast(data).nom+"1";
		//tempPos= new IntHash<Int>();
		//tempPos.set(1,5);
//</positions>


		cast(data).positions=haxe.Serializer.run(tempPos);				
		if(data.id==null){
		cast(data).insert();
								
		}else{
		
		trace("------------data="+cast(data).nom+"---------"+cast(data).positions+"\n");
		cast(data).update();
		}
		cast(data).sync();
			
			for(c in childRefs){
						if(cast(c).id!=null){
						c.update();

						}else{
						c.insert();
						}
						}	
		trace("------------data="+cast(data).nom+"---------"+cast(data).positions);		
				return data;
	}
	

	function creeAjaxFormElement(formulaire:Form,microfield:Microfield,?graine:String=""):FormElement{

		var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.voName+"_"+microfield.field+graine, microfield.field, null, null, null, null]);

		microfield.elementId =formulaire.name+"_"+microfield.voName+"_"+microfield.field+graine;

		//microbeFormElement.value= microfield.value;
		microbeFormElement.cssClass="generatorClass";
		return microbeFormElement;
	}
	public function delete(voName:String,id:Int) : Void {
		
	}
	
	
}