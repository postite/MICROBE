package vo;

import php.db.Object;
import php.db.Manager;
import microbe.vo.Spodable;
import microbe.form.IMicrotype;
/**
 * ...
 * @author postite
 */

class UserVo extends Object, implements Spodable
{
	public var id:Int;
	public var mdp:String;
	public var nom:String;
	
	//public var voType:String;
	
	static var PRIVATE_FIELDS = ["manager"];
	public var manager:Manager<UserVo>;
	
	static var TABLE_NAME = "user";
	
	public function new() 
	{
		//voType = "UserVo";
		manager = new Manager<UserVo>(UserVo);
		super();
		
	}
	
	/* INTERFACE vo.Spodable */
	
	public function getFormule():Hash<FieldType> 
	{
		var formule:Hash<FieldType>;
		formule = new Hash<FieldType>();
		formule.set("nom", {classe:"microbe.form.elements.Input",type:formElement,champs:nom});
		formule.set("mdp", {classe:"microbe.form.elements.Input",type:formElement,champs:mdp});
		return formule;
	}
	
	/* INTERFACE vo.Spodable */
	public function getFields(){
		var liste= new List<Dynamic>();
		liste.add("nom");
		liste.add("mdp");
		return liste;
	}
		public	function getHash() :Hash<Dynamic> {
			var h= new Hash<Dynamic>();
			h.set("nom", nom);
			h.set("mdp",mdp);
			return h;
		}
	public function getDefaultField():String 
	{
		return nom;
	}
	
}