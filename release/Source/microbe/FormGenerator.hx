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
import sys.db.Object;
import microbe.form.Microfield;
import microbe.form.BrickField;
import microbe.form.elements.CollectionElement;
import microbe.form.FormElement;


///import all Components
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
		
		
		//////// function d'execution des formules de vo ... peut etre a externaliser 
		
	
		
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
			var _formulaire= new Form("form",null,POST);
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
			
			
			
			trace("resolt="+creator.result);
			return creator.result;
			
			
		}
	
		
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