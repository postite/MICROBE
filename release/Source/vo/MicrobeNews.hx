package vo;
/*#if !spod_macro
import php.db.Object;
import php.db.Manager;
#else*/
import sys.db.Manager;
import sys.db.Object;
import sys.db.Types;
import sys.db.TableCreate;
//#end
import microbe.vo.Spodable;
import microbe.form.IMicrotype;
import microbe.vo.Taggable;

@:table("actu")
@:id(id)
class MicrobeNews extends Object , implements Spodable , implements Taggable
{
	public var poz:Int;
	public var id:SId;
	public var titre:SString<255>;
	public var date:SDate;
	public var contenu:SText;
	public var image:SString<255>;
	public var datelitterale:SString<255>;
	public var en_ligne:SString<255>;
	
	public function new() : Void {
		super();
		/*
				sys.db.Manager.cnx = this.db.connection;
				sys.db.TableCreate.create(manager);*/
	}
	public function getTags():List<String>{
		return new List<String>();
	}
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