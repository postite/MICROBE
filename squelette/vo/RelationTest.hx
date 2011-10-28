package vo;
import sys.db.Manager;
import sys.db.Object;
import sys.db.Types;
import microbe.vo.Spodable;
import microbe.form.IMicrotype;

@:id(id)
@:table("relationtest")
class RelationTest extends Object, implements Spodable
{
	
	
	public var poz:Int;
	public var id: SId;
	public var titre:SString<255>;
	@:skip public var childListe:List<ChildTest>;
	static public var manager=new RelationManager(RelationTest);
	
	/// interface vo spodable
	public function getFormule():Hash<FieldType> 
	{
		var formule:Hash<microbe.form.FieldType>;
		formule = new Hash<microbe.form.FieldType>();
		formule.set("titre", {classe:"microbe.form.elements.AjaxInput",type:formElement,champs:titre});
			formule.set("childListe",{classe:"vo.ChildTest",type:collection,champs:childListe});
		return formule;
	}
	 public function getDefaultField():String{
		return titre.toString();
	}
	
	
}


class RelationManager extends Manager<RelationTest>{
	
	//called when a returned SPOD object is created following data retrieval from the database
		override function make(a:RelationTest) : Void {
			trace("make");
			a.childListe=ChildTest.manager.search({rid:a.id},{orderBy:poz });
		}
	
	//called just before an update is made
	override function unmake( a : RelationTest ) : Void
	{
		trace("unmake");
		a.childListe=ChildTest.manager.search({rid:a.id},{orderBy:poz });
		//a.childListe=ChildTest.manager.search({rid:a.id});
	}
	
}