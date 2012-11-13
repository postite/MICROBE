package microbe;
import microbe.vo.Taggable;
import microbe.vo.Spodable;
using microbe.tools.Debug;


#if php

import vo.Taxo;
import php.Lib;
import sys.db.Manager;
import sys.db.SpodInfos;
import vo.Traductable;
import config.Config;
#end

#if js
import js.Lib;
#end


class TagManager
{
	static var currentspod:String;
	static var voPackage="vo.";
	public static var debug=1;
	public function new()
	{
		
	}
	#if php
	static var currentInstance:Spodable;

	public static function getSpodsByTag(tag:String,?spodstring:String):List<Spodable>{

	currentspod=firstUpperCase(spodstring);
	//trace("currentSpod="+currentspod);
	
	var tag_id=getTaxo(tag,spodstring.toLowerCase()).taxo_id;
	//trace("tag_id="+tag_id);
	
	var spodTable=getSpodTable(spodstring);

	var resultSet=Manager.cnx.request("
	SELECT  DISTINCT B.* from  "+spodTable+" AS B
	LEFT JOIN `tagSpod` AS TS ON TS.`spod_id`=B.id 
	LEFT JOIN  `taxo` AS TX ON TX.`taxo_id`= TS.`tag_id`  
	WHERE TX.taxo_id="+tag_id
	);
	

	var maped:List<Spodable>= resultSet.results().map(maptoSpod);

	//Lib.print(liste);
	//Object
	//return cast(resultSet.results());
	return maped;
//	Lib.print("resultSet="+resultSet.results().toString());
//	return new List<Spodable>();
//	return cast liste;
		}
	
	public static function getTags(spod:String,?spodId:Int):List<Tag>{
		
		var liste:List<Dynamic>;
		if( spodId !=null){
		liste = getTaxoBySpodID(spod, spodId);
		}else{
		liste = getTaxos(spod);
		}
		

		var tags= new List<Tag>();
		for (tax in liste ){
			var tag= new Tag();
			tag.id=tax.taxo_id;
			tag.tag=tax.tag;
			tags.add(tag);
		}
		return tags;
	//	return new List<Taxo>();	
	}

	public static function getTaxo( tag:String , ?spod:String ) : Taxo
	{
	return Taxo.manager.search({ tag : tag, spodtype:spod}).first();
	}

	private static  function getTaxos( spod:String ) : List <Taxo >
	{
	
	var spodTable=getSpodTable(spod);
	trace("spodTAble="+spodTable);
	var resultSet=Manager.cnx.request("
		SELECT distinct TX.* from taxo AS TX
		JOIN tagSpod AS TS ON TS.tag_id=TX.taxo_id
		JOIN "+spodTable+" AS SP ON SP.id=TS.spod_id
		WHERE TX.spodtype='"+spod.toLowerCase()+"'"
		);
		 
		trace("resultSet="+resultSet +"spodTAble="+spodTable);

	return cast resultSet.results();
	//return search({spodtype:spod});
	}
	private static function GetTradRef(spod:String,spod_id:Int):Int 
	{

		/// un peu limite comme condition....
		if (Config.traductable){
			//Lib.print("config.traductable");
			var cap= firstUpperCase(spod);
			var spodable:Spodable=new Api().getOne(cap,spod_id);
			if(Std.is(spodable,Traductable)){
		 		if( cast(spodable,Traductable).id_ref!=null){
		 		return cast(spodable,Traductable).id_ref;
		 		}
			}
		}
	return spod_id;
	}
	private static function getTaxoBySpodID(spod:String,spod_id:Int) : List < Taxo >
	{


	var spodId:Int=spod_id;
	var spodTable=getSpodTable(spod);
	var cap= firstUpperCase(spod);
	//trace("spodableid="+voPackage+cap);

	spodId=GetTradRef(spod,spod_id);
	
	trace("before");
	//Lib.print( "spodID="+spod_id+"spodTable="+spodTable+"cap="+spod);
	var resultSet=Manager.cnx.request("SELECT DISTINCT TX.taxo_id, TX.tag FROM taxo AS TX LEFT JOIN tagSpod AS TS ON TS.tag_id=TX.taxo_id LEFT JOIN "+spodTable+" AS B ON TS.spod_id= B.id	WHERE B.id="+spodId+" AND TX.spodtype='"+spod+"'");
	
	//Lib.print(resultSet.results().length);
	return cast (resultSet.results());
	trace("after");
	return null;
	}
	
	
	public static function getTagsById(spod:String,spodId:Int):List<Tag>{	
		trace("getTags");
		var liste = getTaxoBySpodID(spod, spodId);
		var tags= new List<Tag>();
		for (tax in liste ){
			var tag= new Tag();
			tag.id=tax.taxo_id;
			tag.tag=tax.tag;
			tags.add(tag);
		}

	
		return tags;
	//	return new List<Taxo>();
	}

	//return spods id for a tag and a spodtype 
	public static function getIDS(tag:String,spod:String):List<Int>{
	//var listeTagID=this.search({tag:tag,spodtype:spod.toLowerCase()});
	//return listeTagID;
	var result:sys.db.ResultSet=Manager.cnx.request("Select spod_id 
from tagSpod 
where tag_id 
in (
Select taxo_id 
from taxo 
where tag='"+tag+"' and spodtype='"+spod+"')");
	 var map:List<Int>= new List();
	 while (result.hasNext()){
	 	map.add(result.next().spod_id);
	 }
	return map;
}


 public static function specialcount(tag:String,spod:String,_search:Dynamic):Int
{
	var langRef=false;
	var table=getSpodTable(spod);
	currentspod=firstUpperCase(spod);
	var str= new StringBuf();
	str.add("Select count(*) from "+table);
 	str.add(" ");
 	str.add(" Where ");
  	if (_search!=null){
  	
    var first = true;
   		for (key in Reflect.fields(_search)){
   		  //if(!first) ;
   		  //trace(key +"="+Reflect.field(_search,key));
   		  var value=Reflect.field(_search,key);
   		 	 if( Std.is(value,String)){
   		 	 	if(key=="lang" && value!="fr")langRef=true;
   		 	str.add(key +"='"+value+"'");
   		 	 }else{
   		 	   str.add(key +"="+value);
   		 	 }
   		  first=false;
   		  str.add(" AND ");
   		}
    
    str.add(" ");
	}
if (!langRef){str.add(" id in ");}else{str.add(" id_ref in ");}
str.add("(Select `spod_id`
from tagSpod 
where tag_id 
in (
Select taxo_id 
from taxo 
where tag='"+tag+"' and spodtype='"+spod.toLowerCase()+"')) ");


var  result:sys.db.ResultSet=Manager.cnx.request(str.toString());


///why? 
//Lib.print(result.getIntResult(0));
//return  result.results();
return result.getIntResult(0);
}
public static function specialsearch(tag:String,spod:String,_search:Dynamic,tri:{ ?orderBy : Array<String>, ?limit : Array<Int> },?generateSpods:Bool=true):List<microbe.vo.Spodable> 
{
	var langRef=false;
	var table=getSpodTable(spod);
	currentspod=firstUpperCase(spod);
	var str= new StringBuf();
	str.add("Select * from "+table);
 	str.add(" ");
 	str.add(" Where ");
  	if (_search!=null){
  	
    var first = true;
    for (key in Reflect.fields(_search)){
      //if(!first) ;
      //trace(key +"="+Reflect.field(_search,key));
      var value=Reflect.field(_search,key);
      if( Std.is(value,String)){
      	if(key=="lang" && value!="fr")langRef=true;
     str.add(key +"='"+value+"'");
      }else{
        str.add(key +"="+value);
      }
      first=false;
      str.add(" AND ");
    }
    
    str.add(" ");
}
if (!langRef){str.add(" id in ");}else{str.add(" id_ref in ");}
str.add("(Select `spod_id` 
from tagSpod 
where tag_id 
in (
Select taxo_id 
from taxo 
where tag='"+tag+"' and spodtype='"+spod.toLowerCase()+"')) ");
if (tri!=null){
if (tri.orderBy!=null)
str.add(" ORDER BY "+tri.orderBy.join(","));
if (tri.limit!=null)
str.add(" LIMIT "+tri.limit.join(","));
}
var  result:sys.db.ResultSet=Manager.cnx.request(str.toString());
if (generateSpods)return  result.results().map(maptoSpod);
	return cast result.results();
}




///rec / delete

public static function associate(tag:String,spod:String,spod_id:Int){
	var id=getTaxo(tag,spod).taxo_id;

	var spodId=GetTradRef(spod,spod_id);
	Manager.cnx.request("insert into tagSpod (tag_id,spod_id) VALUES ("+id+","+spodId+") ");
	//object("insert into tagSpod (tag_id,spod_id) VALUES ("+id+","+spodId+") ",true);
}

public static function dissociate(tag:String,spod:String,spod_id:Int) : Void {
	var id=getTaxo(tag,spod).taxo_id;
	var spodId=GetTradRef(spod,spod_id);
	Manager.cnx.request("DELETE  FROM tagSpod  WHERE tag_id="+id+" and spod_id="+spodId );
}


//////outils

static function maptoSpod(res:Dynamic) :Spodable{
	var spod:Spodable= Type.createInstance(Type.resolveClass("vo."+currentspod),[]);
	var formule= spod.getFormule();
	Reflect.setField(spod, "id",Reflect.field(res,"id"));
	for (key in formule.keys()){
		trace("key="+key);
		
	//	if( Reflect.field(res,key)!=null)
		Reflect.setField(spod, key,Reflect.field(res,key));
	}
	return spod;
	}

// retourne la table du spod en question
 static function getSpodTable(spod:String):String{
	trace("getSpoTable"+spod);
	var voPackage="vo.";
	var cap= firstUpperCase(spod);
	var spodable:Spodable=cast Type.resolveClass(voPackage+cap);
	currentInstance=spodable;
	trace("spodable"+spodable);
	var manager:Manager<sys.db.Object>= cast Reflect.field(spodable,"manager");
	trace("manager"+manager);
	var spodinfos:SpodInfos= manager.dbInfos();

	return spodinfos.name; /// added spod_macro specific getTble name via dbInfos

	
}
// mets la premiere lettre en majustucule afin d'etre Resolvée par Type.resolveClass
static function firstUpperCase(str:String) : String {
var firstChar:String = str.substr(0, 1);
var restOfString:String = str.substr(1, str.length);
return firstChar.toUpperCase()+restOfString.toLowerCase();
}



	#end
	
	#if js
	public static function getTags(spod:String,?spodId:Int):List<Tag>{
		
		Std.string(spodId).Alerte();
		microbe.jsTools.BackJS.base_url.Alerte();
		var Xreponse:String=null;
		  Xreponse=haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url+"/index.php/gap/tags/spod/"+spod+"/id/"+spodId);
			//throw "error";
			
		var reponse = haxe.Unserializer.run(Xreponse);
		Std.string(reponse).Alerte();
		return reponse;
	}
	
	public static function addTag(spod:String,spodID:Int,tag:String):String{
		var reponse=haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url+"/index.php/gap/recTag/"+StringTools.urlEncode(tag)+"/"+spod+"/"+spodID);
		return("reponse="+reponse);
	}
	
	public static function getTagsById(spod:String,spodId:Int):List<Tag>{	
		//var reponse=haxe.Http.requestUrl("http://localhost:8888/index.php/gap/recTag/"+tag+"/"+spod+"/"+spodID);
		return(new List<Tag>());	
	}
	public static function removeTagFromSpod(spod:String,spodID:Int,tag:String):String{
		var reponse=haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url+"/index.php/gap/dissociateTag/"+StringTools.urlEncode(tag)+"/"+spod+"/"+spodID);
		return("reponse="+reponse);
	}

	#end
	
	public static function recTag(s:String):String{
		return s;
	}
	public static function recTags(listTag:List<Tag>):Void{
		
	}
	public static function getSpodName(spod:Spodable):String{
	//	return "blog";
		return Type.getClassName(cast spod).split(".").slice(-1).toString();
	}
	
}
class Tag{
	public var tag:String;
	public var id:Int;
	public function new() : Void {
		
	}
	
	
	
}