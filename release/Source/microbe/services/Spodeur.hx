package microbe.services;


import microbe.controllers.GenericController;
import haxigniter.server.request.BasicHandler;
//import php.db.Connection;
/*#if !spod_macro
import php.db.Object;
import php.db.Manager;
#else*/
import sys.db.Manager;
import sys.db.Object;
import sys.db.Connection;
/*#end*/

import microbe.vo.Spodable;


class Spodeur extends GenericController
{
	private var currentSpod:Spodable;
	private var cnx:Connection;
	public static var voPackage:String = "vo.";
	
	public function new() 
	{
		super();
		this.requestHandler = new BasicHandler(this.configuration);
		cnx = Manager.cnx = db.connection;
		Manager.cleanup();
		//cnx.close();
		Manager.initialize();
	}
	
	
	public function getVoData(id:Int, nomVo:String):Spodable {
			
			var spodvo = cast createVoInstance(nomVo);
			var res = spodvo.manager.get(id, true);
			return res;
	}
	
	public function effaceVo(id:Int, nomVo:String ) {
			
			var manager =  Type.createInstance(Type.resolveClass(voPackage+nomVo),[]).manager;
			//Manager.cnx = db.connection;
			var spodVo:Object = cast  manager.get(id,true);
			spodVo.delete();
			
	}
	
	public function insert(spod:Spodable) {
		var spodObject:Object = cast spod;
			spodObject.insert();
			
	}
	public  function getRecordList(nomVo:String):List<Spodable> {
		
		var stringVo = voPackage+nomVo; /// à remplacer par le package vo
		//var manager =  Type.createInstance(
	var manager=cast Reflect.field(Type.resolveClass(stringVo),"manager");
		var liste:List<Dynamic> = manager.all(true);
		return  cast liste;
	}
	
	//cree un voAbstrait en fonction du nom
	public function createVoInstance(voType:String):Spodable {
			return cast Type.createInstance(Type.resolveClass(voPackage+voType),[]);
	}
	
	public function getFields(nomVo:String):List<String> {
		var stringVo = voPackage+nomVo;
		var cls:Dynamic =cast  Type.resolveClass(stringVo);
		var stub = Type.createEmptyInstance(Type.resolveClass(stringVo));
		var instance_fields = Type.getInstanceFields(Type.resolveClass(stringVo));
		var champsPublic:List<String> = new List();
		// get the list of private fields
		var apriv : Array<String> =  cls.PRIVATE_FIELDS;
		apriv = if( apriv == null ) new Array() else apriv.copy();
		apriv.push("__cache__");
		apriv.push("__noupdate__");
		apriv.push("__manager__");
		apriv.push("update");
		
		
		for( f in instance_fields ) {
			var isfield = !Reflect.isFunction(Reflect.field(stub,f));
			if( isfield )
			for( f2 in apriv ) {
					if(f == f2 ) {
						isfield = false;
						break;
					}
				}
			if ( isfield ) {
				//trace( f );
				champsPublic.add(f);
				
			}
		}
		return champsPublic;
	}
	
}