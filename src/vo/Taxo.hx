package vo;
import microbe.vo.Taggable;
import microbe.vo.Spodable;
/*#if !spod_macro
import php.db.Object;
import php.db.Manager;
#else*/
import sys.db.Manager;
import sys.db.Object;
import sys.db.Types;
//#end
import php.Lib;
class Taxo extends Object
{
	
	@:id public var taxo_id:SId;
	public var tag:String;
	public var spodtype:String;
	static var TABLE_IDS =["taxo_id"];
	static var TABLE_NAME = "taxo";
	
	/*static function RELATIONS() {
		    return[ {prop:"child", key:"child_id", manager:CrossVo.manager}];
	}*/
	
	public static var manager = new TagManager();
	
}

class TagManager extends Manager<Taxo>
{
	public function new()
	{
	super(Taxo);
	//ChapterManager.amgr = this;
	}
public function getTags( spod:String ) : List <Taxo >
{
	var resultSet=Manager.cnx.request("
	SELECT distinct TX.* from taxo AS TX
	JOIN tagSpod AS TS ON TS.tag_id=TX.taxo_id 
	WHERE TX.spodtype='"+spod.toLowerCase()+"'"
	);
	return cast resultSet.results();
	//return search({spodtype:spod});
}
public function getTag( tag:String , ?spod:String ) : Taxo
{
	return search({ tag : tag, spodtype:spod}).first();
}

public function getSpodsByTag(tag:String,?spod:String) : List < Spodable >
{
	var liste= new List<Spodable>();
	var tag_id=getTag(tag,spod).taxo_id;
	var spodTable=getSpodTable(spod);

var resultSet=Manager.cnx.request("
	SELECT  DISTINCT B.* from  "+spodTable+" AS B
	LEFT JOIN `tagSpod` AS TS ON TS.`spod_id`=B.id 
	LEFT JOIN  `taxo` AS TX ON TX.`taxo_id`= TS.`tag_id`  
	WHERE TX.taxo_id="+tag_id 
	);
	/*for ( res in resultSet.results()){
			liste.add(cast res);
		}*/
	//Lib.print(liste);
	//Object
//	return cast(resultSet.results());
//	Lib.print("resultSet="+resultSet.results().toString());
//	return new List<Spodable>();
	return cast resultSet.results();
}

public function getTagsBySpodID(spod:String,spod_id:Int) : List < Taxo >
{
	var spodTable=getSpodTable(spod);
	var resultSet=Manager.cnx.request("
	SELECT DISTINCT TX.taxo_id , TX.tag from `taxo` AS TX
	LEFT JOIN `tagSpod` AS TS ON TS.`tag_id`=TX.`taxo_id`
	LEFT JOIN "+spodTable+" AS B ON TS.`spod_id`= B.`id`
	WHERE B.id="+spod_id
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
return 	Reflect.field(spodable, "TABLE_NAME");
	
}
function firstUpperCase(str:String) : String {
var firstChar:String = str.substr(0, 1);
var restOfString:String = str.substr(1, str.length);
return firstChar.toUpperCase()+restOfString.toLowerCase();
}



}