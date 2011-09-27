package microbe.jsTools;
import microbe.ClassMap;
import microbe.form.MicroFieldList;
import microbe.form.IMicrotype;
import microbe.form.Microfield;

import microbe.form.AjaxElement;
using microbe.tools.Debug;

class MapParser
{
	
	//binderElement dependency
	//tags?
	
	
	var map:ClassMap;
	var microbeElements:ElementBinder;
	
	public function new(_microbeElements:ElementBinder)
	{
		microbeElements= _microbeElements;
	}
	

	
	
	
	/// classMAping form_classMAp -> js ClassMAp
	//implementer le recursif....
	//appelé par setClassMAp
	public function parse(_map:ClassMap):Void{
	"".Alerte();
	map=_map;
	//currentVo=map.voClass;
	var liste:MicroFieldList=map.fields; //Microfields or List<Microfield
	
	//a mettre ailleurs
	/*if (liste.taggable==true){
			new TagView(liste);
		}*/
	
	recurMap(liste);
	
	
	}
	
	//appelé par parse
	//recurse dans le classMap et instancie les instancie les AjaxElements pour binding.
	function recurMap(liste:MicroFieldList):Void{
		"".Alerte();
	//var ajaxList:List<AjaxElement>=null;
	/*	if((stock==null)){
			stock= new List<AjaxElement>();
			
			}*/
		var pos:Int=0;
		for (chps in liste){
		
			if(Std.is(chps,MicroFieldList)){
				///////va falloir trouver une autre solution
				
				if(chps.type==collection){
					
					for (item in cast(chps,MicroFieldList).fields.iterator()){
						trace("hop");
					//	Lib.alert("itemField="+item.toString());
						/*var microChamps:Microfield=new Microfield();//cast chps;
												microChamps.elementId=chps.voName;
												microChamps.field="opo";
												microChamps.value='pum';
												microChamps.element="popopo";
												trace(microChamps.toString());*/
						
						//var d:AjaxElement=cast Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[chps,pos]);
						microbeElements.createCollectionWrapper(chps,pos);
						pos++;
					}
					
					
					
					//var d:AjaxElement=cast Type.createInstance(Type.resolveClass("microbe.form.CollectionElement"),[microChamps]);
				//	stock.add(d);
					
				//	return stock;
				
				}
				recurMap(cast (chps,MicroFieldList));
			}
			
			
			else{
				
				var microChamps:Microfield=cast chps;
				//trace("microChamps"+microChamps.value);
			//	trace("microchamp="+microChamps.element);
			
			
				microbeElements.createElement(microChamps);
			//	trace("after binder");
				//d.focus();
			}
		}
		
	//	trace("ajaxList.length="+stock.length);
	//	return stock;
	}
	
	
}