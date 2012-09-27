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

class DataElementBehaviour implements IBehaviour
{

	public var data:Spodable;
	public function parse(source:IMicrotype):String{
		source.value=source.value+"___modif";
		return "dataOnly";
	}
	public function create(voName:String,element:FieldType,field:String,?formulaire:Form):IMicrotype{
		//trace(voName+"it s a formElement >"+element);
		//var fieldClass= Type.resolveClass(element.classe);
		var micro:Microfield=creeMicroFieldListElement(field,element,voName,formulaire);		

		// if( formulaire!=null){
		// 	var formel:FormElement=creeAjaxFormElement(formulaire,micro);
		// 	formulaire.addElement(formel);
		// }
		return micro;
	}
	public function record(source:IMicrotype,data:Spodable):Spodable
	{
			Reflect.setField(data,source.field, source.value);
			// trace("titre value="+Reflect.field(data, "titre"));
			// trace("DATE value="+Reflect.field(data, "date"));
			return data;
	}
	public function delete(voName:String,id:Int):Void
	{

	}
	private function creeMicroFieldListElement(field:String,element:FieldType,voName:String,?formulaire:Form):Microfield{
			var brickElement:Microfield = new Microfield();
			brickElement.voName=voName; // a faire apres > delete
			brickElement.field=field;
			brickElement.element=element.classe; //instancier MicrobeElement
			brickElement.elementId =voName+"_"+field;
			brickElement.type=element.type;

			/// forcer le toString() pour les dates sinon il fait un Std.string auto!
			//et std.string génére une date de type TUE 23...
			var val:Dynamic=Reflect.field(data,field);
			if( Std.is(val,Date)){ val=val.toString();}
			brickElement.value=val;

			return brickElement;
		}
	
}