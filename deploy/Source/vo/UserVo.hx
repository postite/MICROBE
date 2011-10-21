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
/**
 * ...
 * @author postite
 */

@:table('user')
@:id(id)
class UserVo extends Object, implements Spodable
{
	@:skip public var poz:Int;
	public var id:SId;
	public var mdp:SString<255>;
	public var nom:SString<255>;
	

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