package microbe;
import microbe.vo.Taggable;

import microbe.form.IMicrotype;
import microbe.form.MicroFieldList;
import microbe.ClassMap;
import Lambda;
import Type;
import microbe.form.Form;
import microbe.form.elements.Button;
import microbe.form.elements.Hidden;
import microbe.form.elements.Input;
import microbe.form.FormElement;
import microbe.form.elements.AjaxInput;
import microbe.form.elements.RichtextWym;
import microbe.form.elements.AjaxEditor;
import microbe.vo.Spodable;
import php.db.Object;
import microbe.form.Microfield;
import microbe.form.BrickField;
import microbe.form.elements.CollectionElement;
import microbe.form.FormElement;
import microbe.form.elements.FakeElement;
import microbe.form.elements.DeleteButton;
import microbe.form.elements.AjaxArea;
import microbe.form.elements.TailleSelector;
import microbe.form.elements.ImageUploader;
import microbe.form.elements.AjaxUploader;
import microbe.form.elements.CheckBox;
import microbe.form.elements.AjaxDate;
import microbe.form.elements.TagView;



class FormGenerator
{
	
	public static var voPackage: String;
	private var spodForm: Form;
	public var formulaire:Form;
	public var classMap:ClassMap;
	public var compressedClassMap(getCompressedClassMap,null):String;
	public var arborescence: Hash<Dynamic>;
	public var cloud:String;
	
	public function new()
	{
		
	}

public function render():String{
	return formulaire+cloud;
}
		function parseInstanceType(liste:MicroFieldList,element:FieldType,field:String,voName:String,voInstance:Spodable,form:Form,?voRef:String,?voInstanceRef:Spodable,?superfield:String){
		
		//elemnt.type==InstanceType/enum in Spodable Interface	
		return	switch ( element.type )
			{
				case InstanceType.formElement:doFormElement(liste,element,field,voName,voInstance,form,voRef,voInstanceRef,superfield);
				
				case InstanceType.collection:doCollection(liste,element,field,voName,voInstance,form,voRef,voInstanceRef,superfield);
					
				case InstanceType.spodable:doSpodable(liste,element,field,voName,voInstance,form,voRef,voInstanceRef,superfield);
				
			}
			
		}
		
		//////// function d'execution des formules de vo ... peut etre a externaliser 
		
		function doCollection(liste:MicroFieldList,element:FieldType,field:String,voName:String,voInstance:Spodable,form:Form,?voRef:String,?voInstanceRef:Spodable,?superfield:String){
			trace("this is a collection of Voitures");
				//	trace(element);
					
					var fieldClass= Type.resolveClass(element.classe);
					var instanceClass:Spodable=Type.createInstance(fieldClass,[]);
					//on on recurse
					var sousVoName=Lambda.list(element.classe.split(".")).last();
					liste.field=field;
					
					

				//tentative d'imbrication
				
				
				//recuperation des formElemnts dans le spodable de la collection
				var collec=populateBrickField(sousVoName,instanceClass,form,voName,voInstance,field,false);
				collec.type=collection; //assignation du type...
				
				var newCollec=new MicroFieldList();
				newCollec.type=collection;
				newCollec.voName=sousVoName;

			//	field:voitures
				//si data
				if (voInstance.id!=null){
					
					var formule=voInstance.getFormule();
					var collecField=getCollectionField(formule);
					
				//recursion dans la liste de la collection : proprietaires.voitures> list<VoitureVo>;
					var enfants:List<Dynamic> = Reflect.callMethod(voInstance,"get_"+collecField,[]);
					var graine:Int=0;
				  for (car in enfants.iterator()){
					trace("loop in voiture" +enfants.length);
					 var micros:List<FormElement>= new List<FormElement>();
					var testItem:Microfield=null;
					 //on checque les formElements  item:MicroField
					var spodList:MicroFieldList= new MicroFieldList();
					spodList.voName= voName+"_"+element.champs;//   car.nom+graine;//attention je remplace le voName par l'idDom pour matche l'ajaxe
					spodList.type=spodable;
					spodList.field=field;
					spodList.id=car.id;
						
					 for (item in collec){
							var bum=new Microfield();
							bum.value=car.nom;
							bum.type=item.type;
							bum.voName=item.voName;
							bum.elementId=cast(item,Microfield).elementId+graine;
							bum.element=cast(item,Microfield).element;
							bum.field=item.field;
							spodList.add(bum);
					 				 			//		trace ("loop in collec");
					 				 			//		trace("car.id="+car.id);
					 				 					//if( voInstance.id!=null){
					 				 						//item.value = Reflect.field(Reflect.callMethod(voInstanceRef, "get_"+superfield,[]),field);
					 				 						//item.value = Std.string(car.nom);//Reflect.field(car,item.field);
					 				 					//	spodList.add(item);	
					 				 					//}
					 				 			//		trace("item.value="+item.value);
					 				 			
					 	var elem:FormElement=creeAjaxFormElement(cast bum,Std.string(graine));
					 				micros.add(elem);
					 				 									//testItem=cast item;
					 	}//fin item in collec
											
										
						var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[voName+"_"+element.champs,"patapouf",micros]);
										form.addElement(microWrapper);
						graine++;
						trace("spod="+spodList.fields.last().value);
						newCollec.add(spodList);
						//collec.add(spodList);
						//collec.add(cast testItem);
						
					}//fin car in voitures
					//var neoCollec=new MicroFieldList();
						//			neoCollec.type=collection;
						//			neoCollec.field=field;
						//			neoCollec.voName=sousVoName;
						//			liste.add(neoCollec);
					}//fin if not null
				
				if (voInstance.id==null){
					
				var micros:List<FormElement>= new List<FormElement>();
				 for (item in collec){
						var elem:FormElement= creeAjaxFormElement(cast item);
						micros.add(elem);	
					
					}
					var microWrapper:FormElement= Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[voName+"_"+element.champs,"patapouf",micros]);
					form.addElement(microWrapper);
					
				}//fin if null
				
				
				//liste.add(collec);
			if(newCollec!=null)
			liste.add(newCollec);
				
				
				
				//fin imbrication
				
				
				
				

					
				
				
				
														
					
		}
		
	//	besoin de element, voInstance ,liste,form,voName,field,voRef
		function doSpodable(liste:MicroFieldList,element:FieldType,field:String,voName:String,voInstance:Spodable,form:Form,?voRef:String,?voInstanceRef:Spodable,?superfield:String){
			trace("spodable");
			var fieldClass= Type.resolveClass(element.classe);
			var instanceClass:Spodable=Type.createInstance(fieldClass,[]);
				//on on recurse
				var sousVoName=Lambda.list(element.classe.split(".")).last();
				liste.field=field;  //--- pas pris en compte
				liste.type=spodable; /////ah bah merde ça se comporte pas normalement .. ça crache un formElemnt .. c'est pas bon ça ! TODO
				//si data
				if (voInstance.id!=null){
				//	trace("pasnull_"+voInstance);
					//instanciation du voDependant
					var dataChild:Spodable=Reflect.callMethod(voInstance,"get_"+field,[]);
					var souslistedata=populateBrickField(sousVoName, dataChild,form,voName,voInstance,field);
					souslistedata.type=spodable;
					liste.add(souslistedata);
				}else{
					// si vo n'existe pas en core == ajoute une entrée vide
					var sousliste=populateBrickField(sousVoName, cast(instanceClass,Spodable),form,voName,voInstance,field);
					sousliste.type=spodable;
					sousliste.field=field;
					liste.add(sousliste);
			}
		}
		//besoin de element,voName,form,field
		function doFormElement(liste:MicroFieldList,element:FieldType,field:String,voName:String,voInstance:Spodable,form:Form,?voRef:String,?voInstanceRef:Spodable,?superfield:String){
			var fieldClass= Type.resolveClass(element.classe);
			var micro:Microfield=creeMicroFieldListElement(field,element,voName,form);
			//	micro.value="popo";
			//trace("instance="+Type.typeof(voInstance));
			//micro.type=InstanceType.formElement;
			micro.type=formElement;
			if (voInstance.id!=null){
				
					//si VoRAcine
						if(voRef==null) {
							//	if(voInstance.id!=null){
						micro.value = Reflect.field(voInstance,field);
										trace("--------------------"+micro.value);
							//	}
						}else{
							//si vo dependant
							
							//bordel de reflect pour acceder au child de SPOD
							micro.value = Reflect.field(Reflect.callMethod(voInstanceRef, "get_"+superfield,[]),field);
						}
				liste.id=voInstance.id;
			}
			
			
				
			var formel:FormElement=creeAjaxFormElement(micro);
			
			form.addElement(formel);
			liste.add(micro);
			
		}
		
		
		
		function logMap(liste:MicroFieldList){
	 
		}
		
		
		
		//gestion des microfields imbriqués avec relations
		public function generateComplexClassMapForm(nomVo:String,?data:Spodable) : Void {
			//stockage classMApping
			var spodvo:Spodable;
			var _classMap= new ClassMap();
			
			//instanciation du vo ->spodvo
			var stringVo = voPackage + nomVo;
			if(data==null) {
			spodvo=Type.createInstance(Type.resolveClass(stringVo),[]);
			}else{
			spodvo=data;
			_classMap.id=spodvo.id;
			}
			var formule:Hash<FieldType> = spodvo.getFormule();
			
			_classMap.voClass=nomVo;
			//creation du formulaire temporaire ->formulaire
			var _formulaire= new Form(nomVo+"_form",null,POST);
			var elementValue = null;
			var fields=new MicroFieldList();
			
			fields=populateBrickField(nomVo,spodvo,_formulaire);
			
			fields.taggable=false;
			if (Std.is(spodvo,Taggable)){		
				fields.taggable=true;
		//	var tags=haxe.Serializer.run(TagManager.getTags(TagManager.getSpodName(spodvo)));
		//	var tagid=haxe.Serializer.run(TagManager.getTagsById(TagManager.getSpodName(spodvo), spodvo.id));
			this.cloud=new TagView("pif","paf").render();
				//_formulaire.addElement(new TagView("pif","paf",tags));
				
			}	
			
			_classMap.fields=fields;
						//submission
						//var deleteaction:String=DeleteButton.action; 
						var submit = new Button("submit", "enregistrer","enregistrer",BUTTON);
						submit.cssClass="submitor";
						var delete = new DeleteButton("effacer", "effacer","effacer",BUTTON,"poop");
						delete.cssClass="deletebutton";
						//submit.cssClass="monbouton";
						_formulaire.setSubmitButton(submit);
						_formulaire.addElement(delete);			
						_classMap.submit=_formulaire.name+"_"+"submit";
						formulaire=_formulaire;		
						classMap=_classMap;
						trace("classMAp="+classMap.fields);
					//	recurMaptrace(classMap.fields,"-");
				
		}
		
		//recursiveTrace pour classMap
		function recurMaptrace(iter:MicroFieldList,indent:String){
			for (chps in iter){
				if (Std.is(chps,MicroFieldList)){
					indent+="-";
					recurMaptrace(cast chps,indent);
					
				}else{
				trace(indent+"chps="+chps +"<br/>");
				trace( indent+ chps.field);
				trace( indent+ chps.value);
				trace( indent+ chps.voName);
					
				}
				
			}
		}
		
				
		//function recursive de creation de bricks... 
		// il faut la decouper en autant de function que de IF.... TODO
		
		//function creeFormelement
		function populateData(){
			
		}
		
		//@field:nom du champ ex description
		//@element: nom de la classe de l'element  ex microbe.form.formelemnt.AjaxInput
		//@voName:nom du vo sans le package
		//@form : formulaire
		private function creeMicroFieldListElement(field:String, element:FieldType,voName:String,form:Form):Microfield{
			var brickElement:Microfield = new Microfield();
			brickElement.voName=voName; // a faire apres > delete
			brickElement.field=field;
			brickElement.element=element.classe; //instancier MicrobeElement
			brickElement.elementId =form.name+"_"+voName+"_"+field;
			brickElement.type=element.type;
			return brickElement;
		}
		
		function creeAjaxFormElement(microfield:Microfield,?graine:String=""):FormElement{
			
			var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.voName+"_"+microfield.field+graine, microfield.field, null, null, null, null]);
			//microbeFormElement.value= microfield.value;
			microbeFormElement.cssClass="generatorClass";
			return microbeFormElement;
		}
		
	
		private function populateBrickField(voName:String,voInstance:Spodable,form:Form,?voRef:String,?voInstanceRef:Spodable,?superfield:String,recur:Bool=true):MicroFieldList{
			var liste:MicroFieldList= new MicroFieldList();
			liste.voName=voName; /// attribution du nomDuVo à la liste
			liste.type=spodable;
			liste.id=voInstance.id;
			trace("yeahhh");
			
					
			var formule=voInstance.getFormule();
			//recuperation des champs microbeFormElemnents ou/et vo dependants
			var creator=new MicroCreator();
			creator.data=voInstance;
			creator.generate(voName,formule,liste,form);
			
			//liste.add(creator.result);
			
			trace("resolt="+creator.result);
			return creator.result;
			
			/*for ( field in formule.keys()){
						
						var element:FieldType=formule.get(field);
								var parser= new MicroParser()
						}*/
			
			//return liste;
		}
	/*	private function populateBrickField(voName:String,voInstance:Spodable,form:Form,?voRef:String,?voInstanceRef:Spodable,?superfield:String,recur:Bool=true):MicroFieldList{
				//cree une liste de stockage de Microfields
				var liste:MicroFieldList= new MicroFieldList();// a implementer
				liste.voName=voName; /// attribution du nomDuVo à la liste
				liste.type=spodable;
			//	trace("voInstance="+voInstance);
				//recupere les champs du vo
				var formule=voInstance.getFormule();
				
				//recuperation des champs microbeFormElemnents ou/et vo dependants
				for ( field in formule.keys()){
				
				var element:FieldType=formule.get(field);
					
				//recupreation de la classe
				//var fieldtype:InstanceType= element.type;
				///allez zou on checke les enums youhououuuu...
				
			if(recur==true){
					parseInstanceType(liste,element,field,voName,voInstance,form,voRef,voInstanceRef,superfield);
				}else{
					liste.add(creeMicroFieldListElement(field,element,voName,form));
				}
				
			}
		//	trace("liste="+liste.toString());
			return  cast liste;
			}*/
		
		private function getCollectionField(formule:Hash<FieldType>):Dynamic{
			for (f in formule){
				if (f.type==collection) return f.champs;
			}
			return null;
		}
		private function getStringId(element:FormElement):String{
			var id= element.form.name + "_" + element.name;
			return id;
		}
		public function compressedArborescence():String{
			return haxe.Serializer.run(arborescence);
		}
		public function getCompressedClassMap():String{
			return haxe.Serializer.run(this.classMap);
		}
		
}