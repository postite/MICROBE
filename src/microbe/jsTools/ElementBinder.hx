package microbe.jsTools;
import microbe.form.elements.PlusCollectionButton;
import microbe.form.IMicrotype;
import microbe.macroUtils.Imports;

import microbe.form.AjaxElement;
import microbe.form.Microfield;


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
		//"new".Alerte();
	//Imports.pack("microbe.form.elements",false);
	//Imports.pack("elements",false);
		//js.Lib.setErrorHandler(myHandler);
		elements= new List<AjaxElement>();
	}
	
	 // static function myHandler( msg : String, stack : Array<String> ) {
  //       js.Lib.alert(msg+stack);
  //       return true;
  //   }
	public function createCollectionElement(microChamps:IMicrotype,?position:Int) : Void {
		
		var d:AjaxElement=cast Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[microChamps,position]);
		Std.string(position+"-pos").Alerte();
		//var b:PlusCollectionButton= new PlusCollectionButton(cast microChamps,position);
		
	}
	public function createElement(microChamps:Microfield):Void{
		//if (microChamps==null )return;
		//Std.string(microChamps.element).Alerte();
		if( microChamps.element!=null){
			
			var d:AjaxElement=null;
		
		try{ 
		var classe=Type.resolveClass(microChamps.element);
		if (classe==null)throw "not a component";
		d=cast Type.createInstance(classe,[microChamps]);

		} catch( msg : String ) {
		
   		js.Lib.alert(Std.format("le composant : ${microChamps.element} n\'existe pas : $msg"));
		}
		//Type.getClassName(classe).Alerte();
		this.add(d);
		

		
		}else{
			var fake=new AjaxElement(microChamps);
			this.add(fake);
		}
		//"after".Alerte();
	}

	
	
	///implementing ILIST
	public function add(element:AjaxElement) : Void {
		elements.add(element);
	}
	
	public function iterator():Iterator<AjaxElement>{
		return elements.iterator();
	}
	
	
}