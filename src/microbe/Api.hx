package microbe;
import microbe.vo.Taggable;
import microbe.MicroCreator;
import php.Web;
import microbe.controllers.GenericController;
//
/*#if !spod_macro
import php.db.Object;
import php.db.Manager;
import php.db.Connection;
#else*/
import sys.db.Manager;
import sys.db.Object;
import sys.db.Connection;
/*#end*/
import microbe.vo.Spodable;
import php.Lib;
import vo.Taxo;
import haxigniter.server.libraries.Url;
import microbe.TagManager;

import microbe.form.Microfield;


typedef Compressed=String;

typedef VoName =String;

typedef Vo_Id =Int;

typedef Offset =
{
	var debut:Int;
	var	fin:Int;
}
enum ACTION
{
	CREATE;
	UPDATE;
	DELETE;
}

  #if haxe3 @:rttiInfos #end
class Api #if !haxe3  implements haxe.rtti.Infos #end
{
	
		private var map:ClassMap;
		private var voPackage:String;
		private var cnx: Connection;
		private var rootSpod:Spodable;
		
		
	public function new()
	{
		microbe.tools.Mytrace.setRedirection();
		cnx = Manager.cnx = GenericController.appDb.connection;
		Manager.initialize();
		voPackage=GenericController.appConfig.voPackage;
	}
	
	//tags
	function _xml(data:String){
		Lib.print("<data>"+data+"</data>");
	}
	function _json(data:String){
		
	}
	/*public function tags(s:String,?format:String):List<Taxo>{
			if(format!=null)return Reflect.callMethod(this,"_"+format,[s]);
			var tags=Taxo.manager.getTags(s);
			for (a in tags){
				Lib.print(a.tag);
			}
			//var tags=Taxo.m
			return tags;
		}*/

		/// mmm pas normal cette function .. getSpodsBytags devrait avoir un spodstring en arg
		//par qui est elle appelée

 	public function spodByTag(s:String):List<Spodable>{
		var spods=TagManager.getSpodsByTag(s);
		Lib.print(spods);
		
		/*for (a in spods){
			Lib.print(a.titre);
		}*/
		
		return spods;
	}
	
	
	
	//à privatiser 
	public function recTag(tag:String,spod:String,spod_id:Int){
		tag=StringTools.urlDecode(tag);
		if( TagManager.getTaxo(tag,spod) ==null){
		var neotag= new Taxo();
		neotag.tag=tag.toLowerCase();
		neotag.spodtype=spod.toLowerCase();
		neotag.insert();
		}
		
		associateTag(tag,spod,spod_id);
		Lib.print(tag);
	}
	
	
	public function dissociateTag(tag:String,spod:String,spod_id:Int){
		tag=StringTools.urlDecode(tag);
		TagManager.dissociate(tag,spod,spod_id);
	}
	public function associateTag(tag:String,spod:String,spodId:Int){
		TagManager.associate(tag,spod,spodId);
	}
	
	
	
	/// tentative d'implementation d'une api publique rest pour les tags
	public function tags(){
		
		//Lib.print("format="+format);
		//parsing the url
				var url= new Url(GenericController.appConfig);
				var segments= url.segmentString();
				var slip=url.split(segments);
				var rest=slip.slice(2);
		//popoop
				//Reflect.callMethod(this,rest[0],rest.slice(1));
				var action = rest[0];
				switch ( action )
				{
					case "tag":
					//on attends une url de ce type...
					//http://localhost:8888/index.php/gap/tags/tag/bim/spod/paf
						//Lib.print("tag"+rest.slice(1));
						var args=rest.slice(1);
						var tagName=args[0].toLowerCase();
						var spodName= args.slice(2)[0];
						var spods=null;
						
							spods=microbe.TagManager.getSpodsByTag(tagName,spodName);
						
						
					
							Lib.print(haxe.Serializer.run(spods));

							//Lib.print(haxe.Serializer.run("heho"));
					case "spod":
					trace("spod");
					//on attends une url de ce type...
					//http://localhost:8888/index.php/gap/tags/spod/blog
						var args=rest.slice(1);
						var spodName=args[0].toLowerCase();
						trace("spod"+spodName);
						var spodId= Std.parseInt(args.slice(2)[0]);
						
						
						var tags=microbe.TagManager.getTags(spodName,spodId);
						trace("microbe.TagManager.getTags"+tags);
						trace("length="+tags.length);
						
						//Lib.print("zouhhhhha"+"spodName="+spodName+"spodId="+spodId+"----");
						Lib.print(haxe.Serializer.run(tags));
						//Lib.print(haxe.Serializer.run("heho"+spodName));
					default:
					Lib.print("ooups");
				}
				
	    		//associateTag(_tag,2);
	}
	public function test(arg:String) 
	{
		Lib.print(arg);
	}
	//test access specifique method on Spod
	public function trigger(_voName:String,functionName:String,?params:Array<String>)
	{
		//return _voName;
		var instance=createInstance(voPackage+_voName);
		//return instance;
		Lib.print( Reflect.callMethod(instance,functionName,params));
	}



	//recuper la valeur de "map" passée en POST dans l'appel sous forme Serialisée
	function getClassMap():ClassMap{
		var cmap:Compressed= Web.getParams().get("map");
		map = haxe.Unserializer.run(cmap);
		trace( "map="+map);
		return map;
	}
	
		public function read(_vo:String,?id:Vo_Id,?offset:Offset){
			//	if (id!=null) getOne(_vo,id);
			Lib.print("pop"+_vo);
		}

		public function getOne(_vo:String,id:Int) : Spodable {
			//var inst:Object= cast this.createInstance(_vo);
			//trace("getOne="+_vo+"id="+id);
			return cast getManager(_vo).unsafeGet(id);
		}
			public function getLast(_vo:String,?search:Dynamic) : Spodable {
				//var inst:Object= cast this.createInstance(_vo);
				//trace("getOne="+_vo+"id="+id);
				var all=null;
				try {
				    // ...
				    if( search!=null){
				    	all= cast getManager(_vo).dynamicSearch(search);
				    	}else{
					all= cast getManager(_vo).all();
					}
				} catch( msg : String ) {
				    Lib.print(msg);
				}
				
			
				
				if(all.length>0){
					trace("micrabeLast");
				return all.last();
				}else{
					trace("null");
				return null;
				}
			}
	
		
		public function getOneH(_vo:String,id:Int):String{
			var spod=getOne(_vo,id);
			var out=new Output(spod);
			var compressed=haxe.Serializer.run(out.render());
			//trace("getOneH="+compressed);
			return compressed;
		//	Lib.print(compressed);
		}
		
		public function getAllorded(_vo:String,?arg:Array<Dynamic>):List<Spodable>{
		//public function getAllorded(_vo:String):Dynamic{

			var stringVo = voPackage+_vo; 
			var liste:List<Object>=new List<Object>();
			//var manager =  Type.createInstance(

			var manager:Manager<Object>=cast Reflect.field(Type.resolveClass(stringVo),"manager");
			
			//var manager= vo.RelationTest.manager;
			//var liste:List<Dynamic> = manager.all(true);
			var table=manager.dbInfos().name;
			
			//trace("table="+table);
			//var liste:List<Dynamic> = manager.all(true);

			for (a in Type.getClassFields(Type.resolveClass(stringVo))){
				if (a=="getAllorded"){
					liste= Reflect.callMethod( Type.resolveClass(stringVo), "getAllorded", arg);
					return  cast liste;
				}
			}
			
				
			 liste =cast manager.unsafeObjects("SELECT * FROM "+table+" ORDER BY poz",true);
			
			return  cast liste;
			
		}

		public function getSearch(_vo:String,search:Dynamic):List<Spodable>
		{
			var stringVo = voPackage+_vo; 
			var liste:List<Object>=new List<Object>();
			//var manager =  Type.createInstance(

			var manager:Manager<Object>=cast Reflect.field(Type.resolveClass(stringVo),"manager");
			
			//var manager= vo.RelationTest.manager;
			//var liste:List<Dynamic> = manager.all(true);
			var table=manager.dbInfos().name;
			
			//trace("table="+table);
			//var liste:List<Dynamic> = manager.all(true);

			for (a in Type.getClassFields(Type.resolveClass(stringVo))){
				
				if (a=="getAllorded"){

					liste= Reflect.callMethod( Type.resolveClass(stringVo), "getAllorded", []);
					return  cast liste;
				}
			}
			
				
			 liste =cast manager.dynamicSearch(search);
			
			return  cast liste;
		}
		
		public function getAll(_vo:String):List<Spodable> {
			var stringVo = voPackage+_vo; 
			//var manager =  Type.createInstance(
			var manager=cast Reflect.field(Type.resolveClass(stringVo),"manager");
			var liste:List<Dynamic> = manager.all(true);
			return  cast liste;
			//return new List<Spodable>();
		}
		function getPages(vo:VoName,offset:Int) : Void {
			
		}
	
	
	
	//-----------WRITING-----------------
	
	public function rec():Dynamic {
		getClassMap();
		return recClassMap();	

	}

	// solo recording field
	public function microRec():Spodable{
		var cmap:Compressed= Web.getParams().get("micromap");
		var micromap:Microfield=haxe.Unserializer.run(cmap);
		var voInstance=getOne(micromap.voName,micromap.voId);
		Reflect.setField(voInstance,micromap.field,micromap.value);
		cast(voInstance,sys.db.Object).update();
		return voInstance;
	}
	function recClassMap() : Dynamic {
		trace("record"+map.id);
		var voInstance:Spodable= null;
		if( map.id!=null){
			trace("map.id!=null");
		voInstance=getOne(map.voClass,map.id);
		}else{
		voInstance=Type.createInstance(Type.resolveClass(voPackage +map.voClass),[]);
		var manager=Reflect.field(Type.resolveClass(voPackage +map.voClass),"manager");

		var dbInfos:sys.db.SpodInfos=manager.dbInfos();
		trace("DBINFOS"+dbInfos);
		var indexes:Array<{ unique : Bool, keys : Array<String> }>=dbInfos.indexes;
		for ( index in dbInfos.indexes){
			if (index.unique)
			for ( key in index.keys){
				trace( "unique="+key);
				//trace("classMap="+map.fields);
				for ( f in map.fields){
					if( f.field ==key) {
						trace("found unique KEY");
					
					var pip:sys.db.ResultSet=manager.unsafeExecute("Select * from "+dbInfos.name+" where "+key+"='"+f.value+"'");
					trace("pip="+pip.length);
					if (pip.length>0)
					return new microbe.ERROR(microbe.ERROR.ERROR_TYPE.DOUBLON);
					
					}

				}
				
			}
		}
		try{
		cast (voInstance).insert();
		}catch(err:String){
			return new microbe.ERROR(microbe.ERROR.ERROR_TYPE.DOUBLON);
		}
			cast(voInstance).id= microbe.controllers.GenericController.appDb.connection.lastInsertId();
			
			//trace("MONID="+cast(voInstance).id);
		//voInstance.update();
		}
		trace("after");
	//cast(voInstance).insert();
	//cast(voInstance).sync();
		var creator:MicroCreator = new MicroCreator();
		creator.source=map.fields;
		creator.data=voInstance;
		var fullSpod:Object=cast creator.record();
		// trace("beforeRec="+Type.typeof(cast(fullSpod).date));
		// trace("beforeReccheck date="+cast(fullSpod).date.getTime());

		cast(fullSpod).date=Date.now();
		if(cast(fullSpod).id==null){
			try{
			fullSpod.insert();
			}catch(msg:String){
			return "erreur "+msg;
			}
		}else{
		fullSpod.update();
		}
		return cast(fullSpod);
	}
	
	public function delete(voName:String,id:Int):Void{
		var spodadelete:Object=cast(getManager(voName).unsafeGet(id));
		//return spodadelete.id;
		spodadelete.delete();
	}
	
	//-----------OUTILS------------------
	function getManager(_vo:VoName):Manager<Object>{
		var stringVo = voPackage+_vo; 
		//trace("strinvo="+stringVo);
		//var manager =  Type.createInstance(
		return cast Reflect.field(Type.resolveClass(stringVo),"manager");
	}
	
	function createInstance(_vo:VoName) : Spodable {
		return Type.createInstance(Type.resolveClass(_vo),[]);
	}
	
}