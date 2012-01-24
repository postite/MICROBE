package microbe.form.elements;

#if js
import microbe.form.AjaxElement;
import js.Lib;
import js.JQuery;
import js.Dom.HtmlDom;
using microbe.tools.Debug;
class CheckBox extends AjaxElement{
	
	public static var debug:Bool=false;
	public function new(?_microfield,?_iter) : Void {
	//	//Lib.alert("checkBox");
		////Lib.alert("gasp");
	
		super(_microfield,_iter);	
		this.id.Alerte();
	}

		
		override public function getValue():String{	

			
			//this.fucking JQuery has changed his implementation of attr("checked") > check the version my friend > http://api.jquery.com/prop/
			// BOOL or String that is the question man ! c'est des malades ...
			
			var valeur:Bool=cast new JQuery("#"+this.id).attr("checked");
			
			
			var val:String;
			if (valeur == true){
			 val="true"; 
			}else{
			 val="false";
			}
			
			return val;
		}
		
		override public function setValue(val:String):Void{
			//Lib.alert("setpos="+pos);
			"set_"+val.Alerte();
			var etat:String;
			if (val=="true"){
			etat="checked"	;
			} else{
			etat="";	
			} 
			//Lib.alert("etat="+etat);
			//Std.string(new JQuery("#"+this.id)).Alerte();
			new JQuery("#"+this.id).attr("checked",etat);
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

				//var str ="<div id="+n+" class='check'>";
var str="";
			//	str+='<label for="check'+iter+'">'+name+'</label>';
				str+='<input id="'+n+'" name="pipo" class="checkBox" value="'+name+'" type="checkbox" checked="checked" /> '; 


				//str+="</div>";
				return str;
			//	return '<input id="one" name="pipo" class=polo"  type="checkbox"  /> ';
		}
	}
	#end