package vo;
import sys.db.Manager;
import sys.db.Object;
import sys.db.Types;
import microbe.vo.Spodable;
import microbe.form.IMicrotype;


@:table("child")
@:id(id)
class ChildTest extends Object, implements Spodable
{
	public var poz:Int;
	public var id:SId;
	public var titre:SString<255>;
	@:relation(rid) public var rel:RelationTest;




public function getFormule():Hash<FieldType> 
{
	var formule:Hash<microbe.form.FieldType>;
	formule = new Hash<microbe.form.FieldType>();
	formule.set("titre", {classe:"microbe.form.elements.AjaxInput",type:formElement,champs:titre});
	return formule;
}
 public function getDefaultField():String{
	return titre.toString();
}

}