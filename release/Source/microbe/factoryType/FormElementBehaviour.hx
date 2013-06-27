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
		return "im a dataElement"+source.voName;

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

			trace("FormElementBehaviour"+source.field +"--"+source.value);
			Reflect.setField(data,source.field, source.value);
			// trace("titre value="+Reflect.field(data, "titre"));
			// trace("DATE value="+Reflect.field(data, "date"));
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
			brickElement.voId=data.id;
			/// forcer le toString() pour les dates sinon il fait un Std.string auto!
			//et std.string génére une date de type TUE 23...
			var val:Dynamic=Reflect.field(data,field);


			if( Std.is(val,Date)){ val=val.toString();}
			//if( Std.is(val,Int)){ val=val.toString();} //humpf marche pas 
			brickElement.value=val;

			return brickElement;
		}
		
		function creeAjaxFormElement(formulaire:Form,microfield:Microfield,?graine:String=""):FormElement{
			//microfield=brickelement
//			var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.voName+"_"+microfield.field+graine, microfield.field, null, null, null, null]);
			var microbeFormElement:FormElement= Type.createInstance(Type.resolveClass(microfield.element),[microfield.elementId, microfield.field, microfield.value, null, null, null]);
			//microfield.elementId=formulaire.name+"_"+microfield.voName+"_"+microfield.field;
			//microfield.elementId="formElementBHcreaajaxElement";
			microbeFormElement.setMicrofield(microfield);
			microbeFormElement.cssClass="generatorClass";
			return microbeFormElement;
		}
		
		
		public function delete(voName:String,id:Int) : Void {

		}
}