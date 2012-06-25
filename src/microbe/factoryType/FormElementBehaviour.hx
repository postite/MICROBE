package microbe.factoryType;
import microbe.vo.Spodable;
import microbe.form.FormElement;
import microbe.form.Form;
import microbe.form.Microfield;
import microbe.form.MicroFieldList;
import microbe.form.IMicrotype;

class FormElementBehaviour implements IBehaviour
{
	public var form:Form;
	public var data:Spodable;
	public function new()
	{

	}
	public function parse(source:IMicrotype):String{
		source.value=source.value+"___modif";
		return "im a formElement"+source.voName;

	}
	public function create(voName:String,element:FieldType,field:String,?formulaire:Form):IMicrotype{
		trace(voName+"it s a formElement >"+element);
		var fieldClass= Type.resolveClass(element.classe);
		var micro:Microfield=creeMicroFieldListElement(field,element,voName,formulaire);		

		if( formulaire!=null){
			var formel:FormElement=creeAjaxFormElement(formulaire,micro);
			formulaire.addElement(formel);
		}
		return micro;
		}
		
	public function record(source:IMicrotype,data:Spodable):Spodable {
			trace("elementVAlue="+data);
			Reflect.setField(data,source.field, source.value);
			trace("afterReflect"+Reflect.field(data, source.field));
			trace("titre value="+Reflect.field(data, "titre"));
			return data;
		}
		
		

		//@field:nom du champ ex description
		//@element: nom de la classe de l'element  ex microbe.form.formelemnt.AjaxInput
		//@voName:nom du vo sans le package
		//@form : formulaire
		private function creeMicroFieldListElement(field:String,element:FieldType,voName:String,?formulaire:Form):Microfield{
			var brickElement:Microfield = new Microfield();
			brickElement.voName=voName; // a faire apres > delete
			brickElement.field=field;
			brickElement.element=element.classe; //instancier MicrobeElement
			brickElement.elementId =voName+"_"+field;
			brickElement.type=element.type;
			brickElement.value=Reflect.field(data,field);
			return brickElement;
		}
		
		
		
		function creeAjaxFormElement(formulaire:Form,microfield:Microfield,?graine:String=""):FormElement{
				//microfield=brickelement
//			var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.voName+"_"+microfield.field+graine, microfield.field, null, null, null, null]);
			var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.elementId, microfield.field, null, null, null, null]);
			//microfield.elementId=formulaire.name+"_"+microfield.voName+"_"+microfield.field;
			//microfield.elementId="formElementBHcreaajaxElement";
			microbeFormElement.cssClass="generatorClass";
			return microbeFormElement;
		}
		
		
		public function delete(voName:String,id:Int) : Void {

		}
}