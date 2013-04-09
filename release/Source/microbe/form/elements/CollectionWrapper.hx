package microbe.form.elements;


#if php
import microbe.form.FormElement;
import microbe.form.elements.CollectionElement;
class CollectionWrapper extends FormElement
{
	var wrapped:List<FormElement>;
	var field:String;
	public function new(_field:String)
	{
		trace("new Collection Wrapper"+_field);
		field=_field;
		super();
		this.label=_field;
		wrapped=new List<FormElement>();
		trace("after new Collection Wrapper"+_field);

	}
	override function render(?iter:Int) : String {
			var str:String="<div class='collectionWrapper' spod='"+field+"'>";
			for(item in wrapped){
				//str+= "<li>";
				str+=item.render();
				
			//	str+="</li>";
			//	str+=item.render(2);
			}
			str+="</div>";
			return str;
	}
	
	public function addElement(collecItem:FormElement) : Void {
		trace("addElement"+collecItem);
		collecItem.form=this.form;
		wrapped.add(collecItem);
	}
	public function removeElement(collecItem:FormElement) : Void {
		wrapped.remove(collecItem);
	}
	
}
#end

#if js
import js.Lib;
using microbe.tools.Debug;
import js.JQuery;
import postite.jquery.ui.Sortable;
import hxs.Signal1;
import microbe.jsTools.BackJS;
typedef PlusInfos =
{
	var collectionName:String;
	var graine:Int;
	var target:CollectionWrapper;
}


	class CollectionWrapper{
		var me:JQuery;
		var plus:JQuery;
		var clone:JQuery;
		var sort:Sortable;
		public static var plusInfos:Signal1<PlusInfos>;
		public static var debug=1;
		var spod:String;
		public function new() : Void {
			
			
			me=new JQuery(".collectionWrapper");
			spod=me.attr("spod");
			//var bif :Sortable= 
			createPlusBouton();
			plusInfos= new Signal1<PlusInfos>();
			var sortoptions:SortableOptions= cast {};
			//sortoptions.grid=[20,50];
			sortoptions.update=onSortChanged;
			sortoptions.start=onSortStart;
			sortoptions.placeholder="placeHolder";
			sortoptions.opacity=.2;
		//	if(me.children(".collection").length>1)
			sort=new Sortable(".collectionWrapper").sortable(sortoptions); //TODO //pose un probleme sur ajoute et PLUS
			
		//	Std.string(collec).Alerte();
		}

		function createPlusBouton():Void{
			var plusString=PlusCollectionButton.create("plusbutton");
			me.append(plusString);
			var plus:PlusCollectionButton=new PlusCollectionButton(me.find(".plusbutton"));
			PlusCollectionButton.sign.add(onPLUS);
			plus.init();
		}
		function onPLUS(s:String):Void{
			"onPlus".Alerte();
			//plusInfos.dispatch({collectionName:"pop",graine:2,target:me});
			clone=me.children(".collection").last().clone();
			var collength:Int= me.children(".collection").length; //comme la collection commence à zero  pas besoin d'incrrrr
			clone.attr("id",clone.attr("name"));
			plusInfos.dispatch({collectionName:clone.attr("name"),graine:collength,target:this});
			
		}
		public function notify(newColl:String){
			"notify".Alerte();
			me.append(newColl);
		}
		private function onSortStart(e:JqEvent,ui:UI) : Void {
		//	"onsortstart".Alerte();
			var childs:JQuery=me.children(".collection");
			for ( a in childs){
			var value:Int=Lambda.list(a.attr("tri").split("_")).last().length;
			if( value==0)return dispatchError();
			}
			return;
		}
		private function dispatchError(){
			sort.disable();
			Lib.alert("Veuilez enregistrer avant de réarranger l'ordre !");
		}
		private function onSortChanged(e:JqEvent,ui:UI):Void{
			var pop=sort.sortSerialize({attribute:'tri',key:'id'});
			trace(pop);
			var liste:Array<String>=pop.split("&id=");
			 liste[0]=liste[0].split("id=")[1];

			//Lib.alert(pop);
			//sort.disable();
			var req= new haxe.Http(BackJS.back_url + "reorder/"+this.spod);
		//	req.setParameter("voName", voName);
			req.setParameter("orderedList",haxe.Serializer.run(liste));
			req.onData=function(d) { trace(d);}; 
			req.request(true);
			trace("afterreorder");
		}
		
	}
#end