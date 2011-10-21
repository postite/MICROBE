package microbe.form.elements;

#if js
import microbe.form.AjaxElement;
import js.Lib;
import js.JQuery;
import js.Dom.HtmlDom;
class CheckBox extends AjaxElement{
	
	
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
			//Lib.alert("getposl="+pos);
			
			
			//this.fucking JQuery has changed his implementation of attr("checked") > check the version my friend > http://api.jquery.com/prop/
			// BOOL or String that is the question man ! c'est des malades ...
			
			var valeur:Bool=cast new JQuery(".checkBox"+pos).attr("checked");
			//Lib.alert("checked="+valeur);
			var val:String;
			if (valeur == true){
			 val="true"; 
			}else{
			 val="false";
			}
			//Lib.alert("getVal="+val);
			return val;
		}
		
		override public function setValue(val:String):Void{
			//Lib.alert("setpos="+pos);
			var etat:String;
			if (val=="true"){
			etat="checked"	;
			} else{
			etat="";	
			} 
			//Lib.alert("etat="+etat);
			var valeur=new JQuery(".checkBox"+pos).attr("checked",etat);
			//Lib.alert("valeur="+valeur);
			
		}
	
}
#end

	#if php

	import microbe.form.FormElement;

	class CheckBox extends FormElement
	{

		public function new(name:String, ?label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
		{
			super();
			this.name=name;
			this.label=Lambda.list(name.split("_")).last();

		}
		override public function render(?iter:Int):String{
			if (iter==null)iter=0;
				var n = name;

				var str ="<div id="+n+" class='check'>";

			//	str+='<label for="check'+iter+'">'+name+'</label>';
				str+='<input id="check'+iter+'" name="pipo" class="checkBox'+iter+'" value="'+name+'" type="checkbox" checked="checked" /> '; 


				str+="</div>";
				return str;
			//	return '<input id="one" name="pipo" class=polo"  type="checkbox"  /> ';
		}
	}
	#end