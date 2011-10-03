package microbe.jsTools;
import microbe.form.elements.PlusCollectionButton;
import microbe.form.IMicrotype;

import microbe.form.AjaxElement;
import microbe.form.Microfield;
import microbe.form.ImportAllAjaxe;
using microbe.tools.Debug;
import microbe.form.MicroFieldList;

//import allElements
//doit etre accessible depuis BackJS 
//comportement Model?
//get values ?
class ElementBinder
{
	public static var debug=0;
	public var elements:List<AjaxElement>;
	public function new()
	{
	//	"new".Alerte();
		elements= new List<AjaxElement>();
	}
	
	
	public function createCollectionElement(microChamps:IMicrotype,?position:Int) : Void {
		
		var d:AjaxElement=cast Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[microChamps,position]);
		"createInstance".Alerte();
		//var b:PlusCollectionButton= new PlusCollectionButton(cast microChamps,position);
		
	}
	public function createElement(microChamps:Microfield):Void{
		Std.string(microChamps.element).Alerte();
		var classe=Type.resolveClass(microChamps.element);
		Type.getClassName(classe).Alerte();
		var d:AjaxElement=cast Type.createInstance(Type.resolveClass(microChamps.element),[microChamps]);
		this.add(d);
		"after".Alerte();
	}

	
	
	///implementing ILIST
	public function add(element:AjaxElement) : Void {
		elements.add(element);
	}
	
	public function iterator():Iterator<AjaxElement>{
		return elements.iterator();
	}
	
	
}