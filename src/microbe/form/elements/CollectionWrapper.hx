package microbe.form.elements;


#if php
import microbe.form.FormElement;
import microbe.form.elements.CollectionElement;
class CollectionWrapper extends FormElement
{
	var wrapped:List<FormElement>;
	var spod:String;
	public function new(_spod:String)
	{
		spod=_spod;
		super();
		wrapped=new List<FormElement>();
	}
	override function render(?iter:Int) : String {
			var str:String="<div class='collectionWrapper' spod='"+spod+"'>";
			for(item in wrapped){
				str+=item.render();
			//	str+=item.render(2);
			}
			str+="</div>";
			return str;
	}
	
	public function addElement(collecItem:FormElement) : Void {
		collecItem.form=this.form;
		wrapped.add(collecItem);
	}
	public function removeElement(collecItem:FormElement) : Void {
		wrapped.remove(collecItem);
	}
	
}
#end

#if js
	using microbe.tools.Debug;
	import js.JQuery;
	import jquery.ui.Sortable;
	import hxs.Signal1;
	class CollectionWrapper{
		var me:JQuery;
		var plus:JQuery;
		public static var sign:Signal1<String>;
		public static var debug= 1;
		public var spod:String;
		public function new() : Void {
			
			
			me=new JQuery(".collectionWrapper");
			spod=me.attr("spod");
			//var bif :Sortable= 
			createPlusBouton();
			sign= new Signal1<String>();
			var sortoptions:SortableOptions= cast {};
			//sortoptions.grid=[20,50];
			sortoptions.placeholder="placeHolder";
			sortoptions.opacity=.2;
			new Sortable(".collectionWrapper").sortable(sortoptions);

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
			"".Alerte();
			sign.dispatch(spod);
			var clone=me.children(".collection").last().clone();
			me.append(clone);
		}
		
	}
#end