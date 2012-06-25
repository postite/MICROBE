package microbe.form.elements;
using microbe.tools.Debug;

#if js
import js.JQuery;
import microbe.form.AjaxElement;
import js.Lib;
import microbe.TagManager;
class TagView extends AjaxElement
{
	static var debug=1;
	var spodTags:List<Tag>;
	var contextTags:List<Tag>; 
	var fullTags:List<String>;
	
	var filtre:String;
	public function new(?_microfield,?_iter)
	{
		super(_microfield,_iter);
		new JQuery("#addTag").click(onAdd);
		new JQuery("#tagSelector select").change(onSelect);
		//new JQuery("#tagSelector select").change(onSelect);
		
	//	createResultsDiv();
	"new".Alerte();
		init();
		
	}

	function init() : Void {
		getTags(this.voName,this.spodId);
		Std.string(spodTags).Alerte();
		afficheTags();
		Std.string(contextTags).Alerte();
		populateTags();
		Std.string(fullTags).Alerte();
		
		new JQuery("#tagSelector #pute").keyup(onType);
		new JQuery("#tagSelector #results").blur(onBlur);
	}
	function onBlur(e:JqEvent) : Void {
		new JQuery('#tagSelector #results').hide();
	}
	
	function onType(e:JqEvent) : Void {
		
	//	e.preventDefault();

		var filtered=findinSpodTags();
		///Lib.alert("onType");
		showResults(filtered);
	}
	function findinSpodTags() : List<String> {
	//	Lib.alert("find");
		return Lambda.filter(fullTags,subFind);
	}
	function subFind(item:String) : Bool {
		//Lib.alert("subFind");
		var filtre=new JQuery("#tagSelector #pute").val();
		//Lib.alert("subFind"+filtre+"_"+Std.string(item).substr(0,1)+"after substr");
		if(Std.string(item).substr(0,filtre.length)==filtre)return true;
		return false;
	}

	function showResults(data:List<String>){
	//Lib.alert("data="+data);
		if(data.length>0){
	           var resultHtml = '';
	            for (tag in data){
	                /*resultHtml+='<li class="result">';
	                	                resultHtml+=tag;
	                	                resultHtml+='</li>';*/
				resultHtml+='<option class="result">';
				resultHtml+=tag;
				resultHtml+='</option>';
	            }

	            new JQuery('#tagSelector #results').html(resultHtml);

	            new JQuery('#tagSelector #results').css("display","block");
	
   				new JQuery("#tagSelector #results .result").click(onSelect);
				}else{
	  				new JQuery('#tagSelector #results').css("display","none");
				}
	   }
	function onSelect(e:JqEvent) : Void {
		Lib.alert("pop");
	//	e.preventDefault();
		//var selected = new JQuery("#tagSelector select option:selected");    
		//Lib.alert(new JQuery(e.currentTarget).text());
		   /* if(selected.val() != 0){
		 // $("#output").html(output);*/
		var selected = new JQuery("#tagSelector select option:selected"); 
		new JQuery("#tagSelector #pute").val(selected.text());
		
	}
	function reload():Void {
		//// reactualise les tags et le select ... puatin de bordel ... va falloir cleaner ...
	}
	function createResultsDiv() : Void {
		var str ="<div id='results'></div>";
		var div =new JQuery("#tagSelector").append(str);
		
	}
	
	function getTags(spod:String,?spodId:Int) : Void {
		//Lib.alert("voNAme="+spod+"id="+spodId);
		"".Alerte();
		
		if( spodId!=null){
			spod.Alerte();
		var context=TagManager.getTags(spod,spodId);
		"".Alerte();
		var tags=TagManager.getTags(spod);
		"".Alerte();
		contextTags=cast context;
		"".Alerte();
		spodTags=cast tags;
	}else{
		"".Alerte();
		contextTags=new List<Tag>();
		spodTags=new List<Tag>();
	}
		//spodTags=cast contextTags;
	}
	function afficheTags() : Void {
		new JQuery("#tagSelector .tagitem").remove();
		var str:String="";
		str+="<ul class='tags'>";
			for (tag in contextTags){
			str+="<li class='tagitem'><div class='tag'>"+tag.tag+"</div><div class='minus'></div></li>";
			}
		str+="</ul>";
		new JQuery("#tagSelector").append(str);
		new JQuery("#tagSelector .tagitem .minus").click(remove);
	}
	
	function remove(e:JqEvent) : Void {
		var tag=new JQuery(cast e.currentTarget).parent(".tagitem").children(".tag").text();
		TagManager.removeTagFromSpod(this.voName,this.spodId,tag);
		init();
	}
	
	//marche pas 
	function compareTags() : Void {
		for (dispo in spodTags){
			if(Lambda.has(contextTags,dispo)) {
				//Lib.alert("dsipo="+dispo);
				spodTags.remove(dispo);
			}
		}
	}
	
	function populateTags() : Void {
		//compareTags();
		new JQuery("#tagSelector select").empty();
		fullTags= new List<String>();
		var str="";
		for( tag in spodTags){
			//str+="<option>"+tag.tag+"</option>";
			fullTags.add(tag.tag);
		}
		new JQuery("#tagSelector select").append(str);
	}
	
	
	function onAdd(e:JqEvent){
	
//	var newTag=TagManager.recTag(new JQuery("#tagSelector #pute").val());
	var newTag=new JQuery("#tagSelector #pute").val();
	//	new JQuery("#tagSelector #tags").append("<option>"+newTag+"</option>");
	////Lib.alert( "spodId="+this.spodId);
//Lib.alert(this.voName+"_"+this.spodId+"_"+newTag);
	Lib.alert("add"+newTag);
	Lib.alert(TagManager.addTag(this.voName,this.spodId,newTag));
	Lib.alert("afetr");
	init();

	}
	
}

#end

#if php

import microbe.form.FormElement;
import microbe.TagManager;
class TagView extends FormElement
{
	var spodTags:List<Tag>;
	var contextTags:List<Tag>;
	public function new(name:String,?label:String,?tags:String,?tagsbyId:String)
	{
		super();
		spodTags=new List<Tag>();
		contextTags=new List<Tag>();
		//spodTags=haxe.Unserializer.run(tags);
		//contextTags=haxe.Unserializer.run(tagsbyId);
		this.name=name;
	}
/*	override public function render(?iter:Int):String{
		var str:String="<div id='tagSelector'>";
		
		//str+="<SELECT SIZE='1' id='tags'>";
		
	//	str+="</SELECT >";
		str+="<div id='instantag'>";
		str+="<input type=text id='pute'></input>";
		str+="<ul id='results'></ul>";
		str+="<button type='button' id='addTag' >add</button>";
		str+="</div>";
		
		
		str+="</div>";
		return str;
		
	}*/
	
	override public function render(?iter:Int):String{
		var str:String="<div id='tagSelector'>";
		
		
		str+="<div id='instantag'>";
		str+="<input type=text id='pute'></input>";
	//	str+="<ul id='results'></ul>";
		str+="<SELECT SIZE='10' id='results'>";
		str+="</SELECT >";
		str+="<a id='addTag'>+ TAG</a>";
		str+="</div>";
		
		
		str+="</div>";
		return str;
		
	}
	
}	

#end