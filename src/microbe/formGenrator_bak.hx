package microbe;
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

import microbe.form.FormElement;



class FormGenerator
{
	
	public static var voPackage: String;
	private var spodForm: Form;
	public var formulaire:Form;
	public var classMap:ClassMap;
	public var compressedClassMap(getCompressedClassMap,null):String;
	public var arborescence: Hash<Dynamic>;
	public function new()
	{
		
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
			var formule:Hash<String> = spodvo.getFormule();
			
			_classMap.voClass=stringVo;
			//creation du formulaire temporaire ->formulaire
			var _formulaire= new Form(nomVo+"_form",null,POST);
			var elementValue = null;
			var fields=new MicroFieldList();
			fields=populateBrickField(nomVo,spodvo,_formulaire);
			
			_classMap.fields=fields;
						//submission 
						var submit = new Button("submit", "enregistrer","enregistrer",BUTTON);
						//submit.cssClass="monbouton";
						_formulaire.setSubmitButton(submit);
						
						_classMap.submit=_formulaire.name+"_"+"submit";

						formulaire=_formulaire;		
						classMap=_classMap;
						
						trace("classMAp="+fields.length);
						//recurMaptrace(classMap.fields,"-");
				
		}
		
		//recursiveTrace pour classMap
		function recurMaptrace(iter:List<Dynamic>,indent:String){
			for (chps in iter){
				if (Std.is(chps,List)){
					indent+="-";
					recurMaptrace(chps,indent);
					
				}else{
				trace(indent+"chps="+chps +"<br/>");	
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
		private function creeMicroFieldListElement(field:String, element:String,voName:String,form:Form):Microfield{
			var brickElement:Microfield = new Microfield();
			brickElement.voName=voName; // a faire apres > delete
			brickElement.field=field;
			brickElement.element=element; //instancier MicrobeElement
			brickElement.elementId =form.name+"_"+voName+"_"+field;
			
			return brickElement;
		}
		
		function creeAjaxFormElement(microfield:Microfield):FormElement{
			
			var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.voName+"_"+microfield.field, microfield.field, null, null, null, null]);
			//microbeFormElement.value= microfield.value;
			microbeFormElement.cssClass="generatorClass";
			return microbeFormElement;
		}
		
	
		
		private function populateBrickField(voName:String,voInstance:Spodable,form:Form,?voRef:String,?voInstanceRef:Spodable,?superfield:String):MicroFieldList{
			//cree une liste de stockage de Microfields
			var liste:MicroFieldList= new MicroFieldList();// a implementer
			liste.voName=voName; /// attribution du nomDuVo à la liste
			
			//recupere les champs du vo
			var formule=voInstance.getFormule();
			
			//recuperation des champs microbeFormElemnents ou/et vo dependants
			for ( field in formule.keys()){
			
			var element:String=formule.get(field);	
			//recupreation de la classe
			var fieldClass= Type.resolveClass(element);
			//var fieldClass=Type.getClass(fieldInstance);
			//check si le l'element est de type Object(Spodable) et non un Microbe.form.FormElement 
			 	if ( Type.getSuperClass(fieldClass)==Object){
				var instanceClass:Spodable=Type.createInstance(fieldClass,[]);
				//var childFieldsList= new List<BrickField>();
					//on creee une instance de la classe enfant correspondant au champ
					//var childVo=cast Type.createInstance(fieldClass,[]);
					
					//on on recurse
					var sousVoName=Lambda.list(Type.getClassName(fieldClass).split(".")).last();
					liste.field=field;
					
					//si le vo existe et possede des données
					if (voInstance.id!=null){
						trace("pasnull_"+voInstance);
						//instanciation du voDependant
						var dataChild:Spodable=Reflect.callMethod(voInstance,"get_"+field,[]);
						trace("fieldClass_id="+dataChild.id);
						liste.add( populateBrickField(sousVoName, dataChild,form,voName,voInstance,field));
					}else{
						// si vo n'existe pas en core == ajoute une entrée vide
					
					liste.add( populateBrickField(sousVoName, cast(instanceClass,Spodable),form,voName,voInstance,field));
				}
				
				
			/// si il s'agit d'un element de formulaire  //Microbe.formElement		
			}else{
				var micro:Microfield=creeMicroFieldListElement(field,element,voName,form);
				
			//	micro.value="popo";
			//trace("instance="+Type.typeof(voInstance));
			
		
			if (voInstance.id!=null){
				
					//si VoRAcine
						if(voRef==null) {
							//	if(voInstance.id!=null){
											micro.value = Reflect.field(voInstance,field);
										
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
			
			//trace("brick="+brickElement.voName+"<br/>");
			}
			
			//les deux 
			
		}//fin boucle
		trace("liste="+liste.toString());
		return  cast liste;
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