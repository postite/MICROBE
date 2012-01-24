package microbe.form.elements;



#if php

import microbe.form.FormElement;
class TailleSelector extends FormElement
{
	public static var tailles:Array<Int>=[34,35,36,38,40,42,44,46];
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
	{
		super();
		this.name=name;
		
	}
	override public function render(?iter:Int):String{
		var n = name;
		var str ="<div id="+n+" class='tailleSelector'>";
		var incr:Int=0;
		var boule:Bool=false;
		var checked="";
		for( a in tailles) {
		/*if( boule){
					checked='checked="checked"';
				}else{
					checked='';
				}*/
		str+='<label for="pipo'+incr+'_'+iter+'">'+a+'</label>';
		str+='<input id="pipo'+incr+'_'+iter+'" name="pipo" class="taillebox'+iter+'" value="'+a+'" '+checked+' type="checkbox"  /> '; 
		incr++;
		boule=!boule;
		}
		
		str+="</div>";
		return str;
	}
}
#end


#if js
import microbe.form.AjaxElement;
import js.Lib;
import js.JQuery;
import js.Dom.HtmlDom;
class TailleSelector extends AjaxElement{
	
	var doms:Array<HtmlDom>;
	var tab:Array<Int>;
	public function new(?_microfield,?_iter) : Void {
		
		////Lib.alert("gasp");
		id=cast (_microfield).elementId;
		pos=Std.parseInt(getCollectionContainer());
		//Lib.alert("gasp"+ id + "--"+pos);
		super(_microfield,_iter);
	
		//Lib.alert("tailleSelector" );
	}
	function traite() : Void {
		
 
//	//Lib.alert(untyped __js__("$(this).attr('value')"));
	//function():Void{tab.push (untyped __js__("$(this).attr('value')"));}
	}
		public function getCollectionContainer():String{
		var p:JQuery =new JQuery("#"+this.id).parents(".collection");
	//	//Lib.alert("parent="+p.attr("name"));
			if( p.attr("pos")!=null){
				return p.attr("pos");
			}
		return "";
		}
	override public function getValue():String{
		tab=new Array<Int>();
	//	//Lib.alert("tailleSelector");
	//	self=this;
		doms=new JQuery(".taillebox"+pos).filter(":checked").toArray();
	//	//Lib.alert("pos="+pos);
		Lambda.iter(doms,extractValue);
	//	//Lib.alert("tailleSelectorafter"+tab);
		return haxe.Serializer.run(tab);
	}
	override public function setValue(val:String):Void{
		//Lib.alert("val="+val);
		if(val!=null){
		tab=haxe.Unserializer.run(val);
		
		doms=new JQuery(".taillebox"+pos).toArray();
	//	//Lib.alert("setvalue"+ ".taillebox"+pos);
		Lambda.iter(doms,assignValue);
		}
		//new JQuery("#"+id).attr("value",val);
	}
	function extractValue(d:HtmlDom) : Void {
		tab.push(Std.parseInt(d.getAttribute("value")));
	}
	function assignValue(d:HtmlDom) : Void {

		for (a in tab){
			if( d.getAttribute("value")==Std.string(a)){
				d.setAttribute("checked","checked");
			}
		}
	}
	
	
	
	
	
}
#end