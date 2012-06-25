package microbe;
import microbe.vo.Taggable;
import microbe.vo.Spodable;
using microbe.tools.Debug;


#if php

import vo.Taxo;
import php.Lib;
#end

#if js
import js.Lib;
#end


class TagManager
{
	
	public static var debug=1;
	public function new()
	{
		
	}
	#if php
		public static function getSpodsbyTag(tag:String,?spod:String):List<Spodable>{
			var liste = cast Taxo.manager.getSpodsByTag(tag,spod);
		
			return liste;
		}
		
	public static function getTags(spod:String,?spodId:Int):List<Tag>{
		
		var liste:List<Dynamic>;
		if( spodId !=null){
		
		liste = Taxo.manager.getTagsBySpodID(spod, spodId);
		
		}else{
			
		liste = Taxo.manager.getTags(spod);
		
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
	
	public static function getTagsById(spod:String,spodId:Int):List<Tag>{	
		var liste = Taxo.manager.getTagsBySpodID(spod, spodId);
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
	#end
	
	#if js
	public static function getTags(spod:String,?spodId:Int):List<Tag>{
		Std.string(spodId).Alerte();
		microbe.jsTools.BackJS.base_url.Alerte();
		
		/*try
								{*/  var Xreponse=haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url+"/index.php/gap/tags/spod/"+spod+"/id/"+spodId);
			/*throw "error";
									}
									catch ( msg:String )
									{
										trace("msg"+msg);
									}*/
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