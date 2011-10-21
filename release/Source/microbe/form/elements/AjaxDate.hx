package microbe.form.elements;

#if js
import microbe.form.AjaxElement;
import js.Lib;
import js.JQuery;
import js.Dom.HtmlDom;
class AjaxDate extends AjaxElement{
	
	
	public function new(?_microfield,?_iter) : Void {
	//	//Lib.alert("checkBox");
		////Lib.alert("gasp");
		id=cast (_microfield).elementId;
		pos=Std.parseInt(getCollectionContainer());
		super(_microfield,_iter);	
	}

		public function getCollectionContainer():String{
			var p:JQuery =new JQuery("#"+this.id).parents(".collection");
		//	//Lib.alert("parent="+p.attr("name"));
				if( p.attr("pos")!=null){
					return p.attr("pos");
				}
			return "0";
			}
		override public function getValue():String{	
	
					var valeur=new JQuery("#madate_"+pos).val();
					return valeur;
						//return "poop";
			}
		
	override public function setValue(val:String):Void{
			//	Lib.alert("setpos="+pos);
				if( val==null){
					val= Date.now().toString();
					
				}
			
				var valeur=new JQuery("#madate_"+pos).val(val);
				//Lib.alert("valeur="+valeur);
				
			}
	
}
#end

	#if php

	import microbe.form.FormElement;

	class AjaxDate extends FormElement
	{

		public function new(name:String, ?label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
		{
			super();
			this.name=name;
			this.label="date de publication";

		}
		override public function render(?iter:Int):String{
			if (iter==null)iter=0;
			
			 var str="<input id='madate_"+iter+"' type='date'  name='madate_"+iter+"' value='' />";
			return str;
		}
	}
	#end