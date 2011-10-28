package vo;
/*#if !spod_macro
import php.db.Object;
import php.db.Manager;
#else*/
import sys.db.Manager;
import sys.db.Object;
import sys.db.Types;
//#end
import microbe.vo.Spodable;
import microbe.form.IMicrotype;

@:id(id)
@:table("edito")
class Edito extends Object , implements Spodable
{
	public var poz:Int;
	public var id:SId;
	public var contenu:SString<255>;
	public var date:SDate;

public function new() : Void {
	
	//sys.db.TableCreate.create(manager);
	super();
}


public function getFormule():Hash<FieldType> 
{
	var formule:Hash<microbe.form.FieldType>;
	formule = new Hash<microbe.form.FieldType>();
	formule.set("contenu", {classe:"microbe.form.elements.AjaxArea",type:formElement,champs:contenu});
	return formule;
}
 public function getDefaultField():String{
	return date.toString();
}
}