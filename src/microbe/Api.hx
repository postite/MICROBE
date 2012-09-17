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


class Api implements haxe.rtti.Infos
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
 	public function spodByTag(s:String):List<Spodable>{
		var spods=Taxo.manager.getSpodsByTag(s);
		Lib.print(spods);
		
		/*for (a in spods){
			Lib.print(a.titre);
		}*/
		
		return spods;
	}
	
	
	
	//à privatiser 
	public function recTag(tag:String,spod:String,spod_id:Int){
		tag=StringTools.urlDecode(tag);
		if( Taxo.manager.getTag(tag,spod) ==null){
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
		Taxo.manager.dissociate(tag,spod,spod_id);
	}
	public function associateTag(tag:String,spod:String,spodId:Int){
		Taxo.manager.associate(tag,spod,spodId);
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
						
							spods=microbe.TagManager.getSpodsbyTag(tagName,spodName);
						
						
					
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
	public function trigger(_voName:String,functionName:String,?params:Array<String>):Dynamic
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
			public function getLast(_vo:String) : Spodable {
				//var inst:Object= cast this.createInstance(_vo);
				//trace("getOne="+_vo+"id="+id);
				var all=null;
				try {
				    // ...
				all= cast getManager(_vo).all();
				
				} catch( msg : String ) {
				    trace("Error occurred: " + msg);
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
		
		public function getAllorded(_vo:String):List<Spodable>{
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
					liste= Reflect.callMethod( Type.resolveClass(stringVo), "getAllorded", []);
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
	
	public function rec():Void {
		getClassMap();
		recClassMap();			
	}
	
	function recClassMap() : Void {
		trace("record"+map.id);
		var voInstance:Spodable= null;
		if( map.id!=null){
			trace("map.id!=null");
		voInstance=getOne(map.voClass,map.id);
		
		}else{
		voInstance=Type.createInstance(Type.resolveClass(voPackage +map.voClass),[]);
		
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
		fullSpod.insert();
		}else{
		fullSpod.update();
		}
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