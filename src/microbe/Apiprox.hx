package microbe;
import microbe.MicroCreator;

import microbe.form.IMicrotype;
import microbe.form.MicroFieldList;
import php.Lib;
import php.Web;
import microbe.vo.Spodable;
import php.db.Connection;
import microbe.controllers.GenericController;
import microbe.ClassMap;
import php.db.Manager;
import php.db.Object;

//typedef Compressed=String;

//typedef VoName =String;

//typedef Vo_Id =Int;

/*typedef Offset =
{
	var debut:Int;
	var	fin:Int;
}*/
/*enum ACTION
{
	CREATE;
	UPDATE;
	DELETE;
}*/

class Apiprox implements haxe.rtti.Infos {
	
	private var map:ClassMap;
		private var voPackage:String;
		private var cnx: Connection;
		private var rootSpod:Spodable;
		public function new(){
		cnx = Manager.cnx = GenericController.appDb.connection;
		Manager.initialize();
		voPackage=GenericController.appConfig.voPackage;
	}
	
	
	function parseInstanceType(voInstance:Spodable,imicro:IMicrotype,?voRef:Spodable):Dynamic{
	
	//elemnt.type==InstanceType/enum in Spodable Interface	
		switch ( imicro.type )
		{
			case InstanceType.formElement:return  doFormElement(voInstance,imicro);//"formElement";//doFormElement(liste,element,field,voName,voInstance,form,voRef,voInstanceRef,superfield);
					
			case InstanceType.collection: return doCollection(voInstance,cast imicro);//doCollection(liste,element,field,voName,voInstance,form,voRef,voInstanceRef,superfield);
						
			case InstanceType.spodable:return doSpodable(voInstance,cast imicro,voRef);//doSpodable(liste,element,field,voName,voInstance,form,voRef,voInstanceRef,superfield);
			
		}
		
	}
	
	
	
	function doFormElement(voInstance:Spodable,microfield:IMicrotype)  {
		
		Reflect.setField(voInstance,microfield.field,microfield.value);
		trace("fields="+microfield.field +"value="+microfield.value);
		return voInstance;
		
	}
	function doCollection(voInstance:Spodable,imicro:MicroFieldList)  {
		trace( "this is a collection");
		for( a in imicro){
			trace( "value="+a);
		}
		return return voInstance;
	}
	function doSpodable(voInstance:Spodable,microListe:MicroFieldList,?voRef:Spodable)  {
			
		
		trace("spodable voInstance="+voInstance+"   imicro.voName= "+microListe.voName);
		for (subImicro in microListe){
			if (subImicro.type == spodable){
				var subVo=createInstance(voPackage+subImicro.voName);
				parseInstanceType(subVo,cast subImicro,voInstance);
			}else{
				parseInstanceType(voInstance,cast subImicro);
			}
			
		}
		if(voRef!=null){
			cast(voInstance,Object).insert();
			cast(voInstance,Object).sync();
			trace("beforeReflect"+ microListe.field);
			Reflect.callMethod(voRef, Reflect.field(voRef, "set_"+microListe.field), [voInstance]);
			trace("afterReflect");
		}else{
			cast(voInstance,Object).insert();
			
		}
		cast(voInstance,Object).update();
		cast(voInstance,Object).sync();
			//il faut remplacer set_child par un ref 
		
		return voInstance;
	}
	
	function doRoot(imicro:IMicrotype){
		
	}
	
	function spodRecInit(map:ClassMap) : Spodable {
		var voObject:Object=cast createInstance(map.voClass);
		//voObject.insert();//insert in base 
		//voObject.sync();//synchro pour recupe l'id
		rootSpod=cast voObject;
		return rootSpod;
	}
	function spodRecEnd(voInstance:Object){
		voInstance.update();
	}
	function parseClassMap(voInstance:Spodable,map:MicroFieldList):Void {
	
	
	
	
	 parseInstanceType(voInstance,map);
	/*for( imicro in map ){
			 if(Std.is(imicro,MicroFieldList)){
				parseClassMap(voInstance,cast imicro);
		}else{
			
		}
				parseInstanceType(voInstance,imicro);
		}*/
	for(a in voInstance.getFormule().keys()){
	//trace("voInstance "+ Reflect.field(voInstance,a));
	}
	
	}
		public function test(op:String):String{
			return "hello from Apiprox.test"+op;
		}
		public function read(_vo:String,?id:Vo_Id,?offset:Offset){
			//	if (id!=null) getOne(_vo,id);
			Lib.print("pop"+_vo);
		}

		public function getOne(_vo:VoName,id:Vo_Id) : Spodable {
			//var inst:Object= cast this.createInstance(_vo);
			return cast getManager(_vo).get(id);
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
			if(map.id!=null){
				trace("UPDATE TO DO ");
				update(map.voClass,map.id);
				return;
			}
			//var monVo= createInstance(map.voClass);
			//spodInsert(monVo,map.fields);
		
			parseClassMap(spodRecInit(map),map.fields);
			//testSpodType(map.fields);
			//php.Lib.print("hello from APiProto"+map.voClass);			
		}
		
		
		
		private  function create(vo:VoName) : Void {
			
		}
		private function delete(vo:VoName,id:Vo_Id) : Void {
			
		}
		private function update(vo:VoName,id:Vo_Id) : Void {
			var monVo=  createInstance(map.voClass);
			monVo.id=map.id;
			cast(monVo,Object).sync();
			spodUpdate(cast (monVo,Spodable),map.fields);
		}
		
		
		
		//faut vraiment que je me fasse un classe de parsage de spodable...
		private function parseRootSpod(liste:MicroFieldList){
			//loop in liste
			for(imicro in liste){
				
				//check imbrick
			//	if(Std.is(microfield,MicroFieldList)){
				  //checkType
			//	parseInstanceType(cast (imicro).type);
				
				// check microfield	
	
			}
		}
		
		
		
		
		
		//c'est basiquement la même chose que spodInsert mais pour l'update ... a voir si merge la fonction -> TODO
		function spodUpdate(VoInstance:Spodable,liste:MicroFieldList){
			
				/// attention ça marche que pour une relation 1.1 genre monstre et monstrechild
				//on enregistre monstrechild 
				//puis on enregistre Monstre avec la ref_id de monstreChild géré par les relations

				for( microfield in liste){
					//trace("microfield");
					//si il y a un vo imbriqué
					if(Std.is(microfield,MicroFieldList)){
						
						var microList:MicroFieldList = cast microfield;
						//on recupere le nom du vo dependant
					//	var first:Microfield= cast microList.first();
						var depVoName=microList.voName;


						//on doit parser un truc du type Monstre_form_MonstreChild_desc
						//on recupere le nom du vo parent... pas logique si plus de 2 niveaux
						//var parentVoRef:String=Lambda.list(first.elementId.split("_")).first();
						trace("isMicroFieldList"+microList.first().voName +"---pop");
						
						//instanciation du vo dependant ..abah la faut mettre le package à acaude du Splitage plus haut
						var monChildVo:Spodable=cast Type.createInstance(Type.resolveClass(FormGenerator.voPackage+depVoName),[]);
						monChildVo.id=microList.id;
						cast(monChildVo,Object).sync();
						for( micro in microList){
							if( !Std.is(micro,MicroFieldList))
								Reflect.setField(monChildVo,micro.field,micro.value);	
						}
						
						trace("monChil_id= "+microList.id);
						//cast(monChildVo,Object);
					
						cast(monChildVo,Object).update();
						
						//il faut remplacer set_child par un ref 

						Reflect.callMethod(VoInstance, Reflect.field(VoInstance, "set_"+liste.field), [monChildVo]);

					}
					else
					{
						//trace("else");
						
						Reflect.setField(VoInstance,microfield.field,microfield.value);
					}
				}
				VoInstance.id=liste.id;
				
				
				trace("monVo_id= "+VoInstance.id);
				//trace("monVo - child= "+ Reflect.field(VoInstance, "get_child")[0].first());
				var castedVo:Object=cast VoInstance;
				castedVo.update();
				trace("hello");
	
		}
		
		function spodCollectionInsert(){
			//pour les relations 1:N
			
			
		}
		
		//deprecated
		/*function testSpodType(liste:MicroFieldList) : Void {
						for( microfield in liste){
							trace("1-");
							//trace(parseInstanceType(microfield));
							trace("type="+microfield.type);
								if(Std.is(microfield,MicroFieldList)){
							//	trace(parseInstanceType(microfield));
								   testSpodType( cast microfield );
								}
						}
				}
				*/


		function spodInsert(VoInstance:Spodable,liste:MicroFieldList){
				/// attention ça marche que pour une relation 1.1 genre monstre et monstrechild
				//on enregistre monstrechild 
				//puis on enregistre Monstre avec la ref_id de monstreChild géré par les relations

				for( microfield in liste){
					//trace("microfield");
					//si il y a un vo imbriqué

					
					if(Std.is(microfield,MicroFieldList)){
						
						//check type ...
					
					//	return;
						var microList:MicroFieldList = cast microfield;
					
						//on recupere le nom du vo dependant
					//	var first:Microfield= cast microList.first();
						var depVoName=microList.voName;

						//on doit parser un truc du type Monstre_form_MonstreChild_desc
						//on recupere le nom du vo parent... pas logique si plus de 2 niveaux
						//var parentVoRef:String=Lambda.list(first.elementId.split("_")).first();
						trace("isMicroFieldList"+microList.first().voName +"---pop");
						//instanciation du vo dependant ..abah la faut mettre le package à acaude du Splitage plus haut
						var monChildVo:Object=cast Type.createInstance(Type.resolveClass(FormGenerator.voPackage+depVoName),[]);
						

						for( micro in microList){
							if( !Std.is(micro,MicroFieldList))
								Reflect.setField(monChildVo,micro.field,micro.value);	
						}

						monChildVo.insert();
						monChildVo.sync();
						//il faut remplacer set_child par un ref 

						Reflect.callMethod(VoInstance, Reflect.field(VoInstance, "set_"+liste.field), [monChildVo]);

					}
					else
					{
						//trace("else");
						Reflect.setField(VoInstance,microfield.field,microfield.value);
					}
				}
				cast (VoInstance,Object).insert();
		}
		//methodes utiles privées
		
		//recup classMap from web params
		private function act(ACTION){
			
		}
		
		//recuper la valeur de "map" passée en POST dans l'appel sous forme Serialisée
		function getClassMap():ClassMap{
			var cmap:Compressed= Web.getParams().get("map");
			map = haxe.Unserializer.run(cmap);
			return map;
		}
		

		
		
		function getAction() :ACTION {
			return CREATE;
		}
		
		function getManager(_vo:VoName):Manager<Object>{
			var stringVo = voPackage+_vo; 
			//var manager =  Type.createInstance(
			return cast Reflect.field(Type.resolveClass(stringVo),"manager");
		}
		
		function createInstance(_vo:VoName) : Spodable {
			return Type.createInstance(Type.resolveClass(_vo),[]);
		}
	
}