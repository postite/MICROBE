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
	public var image:SString<255>;
	public var modele:SString<255>;
	//@:skip public var subchildListe:List<SubChild>;
	@:relation(rid) public var rel:RelationTest;

	public static var manager = new ChildManager(ChildTest);


public function getFormule():Hash<FieldType> 
{
	var formule:Hash<microbe.form.FieldType>;
	formule = new Hash<microbe.form.FieldType>();
	//formule.set("subchildListe",{classe:"vo.SubChild",type:collection,champs:subchildListe});
	formule.set("titre", {classe:"microbe.form.elements.AjaxInput",type:formElement,champs:titre});
	formule.set("image", {classe:"microbe.form.elements.ImageUploader",type:formElement,champs:image});
	formule.set("modele", {classe:"microbe.form.elements.Mock",type:formElement,champs:image});
	
	return formule;
}
 public function getDefaultField():String{
	return titre.toString();
}

}

class ChildManager extends Manager<ChildTest>{
	
	//called when a returned SPOD object is created following data retrieval from the database
		override function make(a:ChildTest) : Void {
			trace("make");
			//a.subchildListe=SubChild.manager.search({rid:a.id},{orderBy:poz });
			
		}
	
	//called just before an update is made
	override function unmake( a : ChildTest ) : Void
	{
		trace("unmake");
		//a.childListe=ChildTest.manager.search({rid:a.id},{orderBy:poz });
		//a.childListe=ChildTest.manager.search({rid:a.id});
	}
	
}