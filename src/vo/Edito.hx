package vo;
import php.db.Object;
import php.db.Manager;
import microbe.vo.Spodable;
import microbe.form.IMicrotype;


class Edito extends Object , implements Spodable
{
	public var id:Int;
	public var contenu:String;
	public var date:Date;
	
	public static var manager:Manager<Edito> = new Manager<Edito>(Edito);
	
	static var TABLE_NAME = "edito";


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