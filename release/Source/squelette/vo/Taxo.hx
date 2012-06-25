package vo;
import microbe.vo.Taggable;
import microbe.vo.Spodable;
	import sys.db.Types;
	import sys.db.Object;
	import sys.db.Manager;
	import sys.db.SpodInfos;

import php.Lib;


@:table('taxo')
@:id(taxo_id)
class Taxo extends Object
{
	
	public var taxo_id:SId;
	public var tag:SString<250>;
	public var spodtype:SString<250>;
//	static var TABLE_IDS =["taxo_id"];
//	static var TABLE_NAME = "taxo";
	
	/*static function RELATIONS() {
		    return[ {prop:"child", key:"child_id", manager:CrossVo.manager}];
	}*/
	
	public static var manager = new TagManager();
	
}

class TagManager extends Manager<Taxo>
{
	 var currentspod:String;
	public function new()
	{
	super(Taxo);
	//ChapterManager.amgr = this;
	}
public function getTags( spod:String ) : List <Taxo >
{
	
	var spodTable=getSpodTable(spod);
	var resultSet=Manager.cnx.request("
		SELECT distinct TX.* from taxo AS TX
		JOIN tagSpod AS TS ON TS.tag_id=TX.taxo_id
		JOIN "+spodTable+" AS SP ON SP.id=TS.spod_id
		WHERE TX.spodtype='"+spod.toLowerCase()+"'"
		);
		
		
		
		
		
	return cast resultSet.results();
	//return search({spodtype:spod});
}
public function getTag( tag:String , ?spod:String ) : Taxo
{
	return search({ tag : tag, spodtype:spod}).first();
}

public function getSpodsByTag(tag:String,?spodstring:String) : List < Spodable >
{
	currentspod=firstUpperCase(spodstring);
	trace("currentSpod="+currentspod);
	var liste= new List<Spodable>();
	var tag_id=getTag(tag,spodstring.toLowerCase()).taxo_id;
	trace("tag_id="+tag_id);
	var spodTable=getSpodTable(spodstring);
trace("spodtabble="+spodTable);
var resultSet=Manager.cnx.request("
	SELECT  DISTINCT B.* from  "+spodTable+" AS B
	LEFT JOIN `tagSpod` AS TS ON TS.`spod_id`=B.id 
	LEFT JOIN  `taxo` AS TX ON TX.`taxo_id`= TS.`tag_id`  
	WHERE TX.taxo_id="+tag_id
	);
	

	var maped:List<Spodable>= resultSet.results().map(maptoSpod);
trace("maped="+maped);
	//Lib.print(liste);
	//Object
	//return cast(resultSet.results());
	return maped;
//	Lib.print("resultSet="+resultSet.results().toString());
//	return new List<Spodable>();
//	return cast liste;
}

 function maptoSpod(res:Dynamic) :Spodable{
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

public function getTagsBySpodID(spod:String,spod_id:Int) : List < Taxo >
{
	var spodTable=getSpodTable(spod);
	var resultSet=Manager.cnx.request("
	SELECT DISTINCT TX.taxo_id , TX.tag from `taxo` AS TX
	LEFT JOIN `tagSpod` AS TS ON TS.`tag_id`=TX.`taxo_id`
	LEFT JOIN "+spodTable+" AS B ON TS.`spod_id`= B.`id`
	WHERE B.id="+spod_id+" AND TX.spodtype='"+spod+"'"
	);
	return cast (resultSet.results());
}


public function associate(tag:String,spod:String,spodId:Int){
	var id=getTag(tag,spod).taxo_id;
	Manager.cnx.request("insert into tagSpod (tag_id,spod_id) VALUES ("+id+","+spodId+") ");
	//object("insert into tagSpod (tag_id,spod_id) VALUES ("+id+","+spodId+") ",true);
}
public function dissociate(tag:String,spod:String,spodId:Int) : Void {
	var id=getTag(tag,spod).taxo_id;
	Manager.cnx.request("DELETE  FROM tagSpod  WHERE tag_id="+id+" and spod_id="+spodId );
}
private function getSpodTable(spod:String):String{
	var voPackage="vo.";
	var cap= firstUpperCase(spod);
	var spodable:Spodable=cast Type.resolveClass(voPackage+cap);
	var manager= cast Reflect.field(spodable,"manager");
	var spodinfos:SpodInfos= manager.dbInfos();
	return spodinfos.name; /// added spod_macro specific getTble name via dbInfos

	
}
function firstUpperCase(str:String) : String {
var firstChar:String = str.substr(0, 1);
var restOfString:String = str.substr(1, str.length);
return firstChar.toUpperCase()+restOfString.toLowerCase();
}



}