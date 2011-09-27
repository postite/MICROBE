package vo;
import php.db.Object;
import php.db.Manager;
import microbe.vo.Spodable;
import microbe.form.IMicrotype;


class News extends Object , implements Spodable
{
	
	public var id:Int;
	public var titre:String;
	public var date:Date;
	public var contenu:String;
	public var image:String;
	public var datelitterale:String;
	public var en_ligne:Int;
	
	public static var manager:Manager<News> = new Manager<News>(News);
	
	static var TABLE_NAME = "news";


public function getFormule():Hash<FieldType> 
{
	var formule:Hash<microbe.form.FieldType>;
	formule = new Hash<microbe.form.FieldType>();
	formule.set("titre", {classe:"microbe.form.elements.AjaxInput",type:formElement,champs:titre});
	formule.set("date", {classe:"microbe.form.elements.AjaxDate",type:formElement,champs:date});
	formule.set("datelitterale", {classe:"microbe.form.elements.AjaxInput",type:formElement,champs:datelitterale});
	formule.set("contenu",{type:formElement,classe:"microbe.form.elements.AjaxEditor",champs:contenu});
	formule.set("image", {type:formElement,classe:"microbe.form.elements.ImageUploader",champs:image});
	formule.set("en_ligne",{type:formElement,classe:"microbe.form.elements.CheckBox",champs:en_ligne});
	return formule;
}
 public function getDefaultField():String{
	return titre;
}
}