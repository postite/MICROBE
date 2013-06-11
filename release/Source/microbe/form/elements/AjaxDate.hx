package microbe.form.elements;

#if js
import microbe.form.AjaxElement;
import js.Lib;
import js.JQuery;
import js.Dom.HtmlDom;
@:keep
class AjaxDate extends AjaxElement{
	
	
	public function new(?_microfield,?_iter) : Void {
		//Lib.alert("checkBox");
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
					trace("get value valeur="+valeur);
					//Lib.alert("get date"+valeur);
					var _date=Date.fromString(valeur);
					var format=DateTools.format(_date,"%Y-%m-%d");
					trace("getValue after format"+format);
					//Lib.alert("true date"+format);
					trace("format="+format.toString());
					return format.toString();
						//return "poop";
		}
	
	override public function setValue(valeur:String):Void{
			//Lib.alert("#madate_"+pos +"date val="+valeur);
			trace("date="+valeur);
			var _date:Date=null;
				if( valeur==null){
					trace ( "date nulle -> date.now()");
					valeur= DateTools.format(Date.now(),"%Y-%m-%d").toString();
					
				}
				try{
					_date=Date.fromString(valeur);
					trace ( "parsage de date"+ _date);
					}catch(e:String){
						Lib.alert("erreur de parsage de Date "+e);
						var fake=DateTools.format(Date.now(),"%Y-%m-%d").toString();
						_date=Date.fromString(fake);
					}
				
				//Lib.alert("date="+_date);
				var format=DateTools.format(_date,"%Y-%m-%d");
				//Lib.alert("format="+format);
				new JQuery("#madate_"+pos).val(format);
				//return valeur;
			}

	
}
#end

	#if php

	import microbe.form.FormElement;

	class AjaxDate extends FormElement
	{

		public function new(name:String,?label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="")
		{
			super();
			this.name=name;
			this.label="date de publication";

		}
		override public function render(?iter:Int):String{
			if (iter==null)iter=0;
			
			 var str="<input id='madate_"+iter+"' type='date' name='madate_"+iter+"' value='2012-12-11' />";
			return str;
		}
	}
	#end