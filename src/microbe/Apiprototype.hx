package microbe;
/*import microbe.form.MicroFieldList;

//import haxigniter.server.request.BasicHandler;
import php.Lib;
import php.Web;
import microbe.vo.Spodable;
import php.db.Connection;
//import microbe.controllers.GenericController;
import microbe.ClassMap;
import php.db.Manager;
import php.db.Object;*/

/*typedef Compressed=String;

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
}*/

class Apiprototype  {
	
/*	private var map:ClassMap;
	private var voPackage:String;
	private var cnx: Connection;*/
	
	//private constructeur //abstractClass //force override
	 public function new(){
		//super();
		
		//var url = new haxigniter.server.libraries.Url(this.config);
		//this.requestHandler = new BasicHandler(this.config);
		//cnx = Manager.cnx = db.connection;
		//Manager.initialize();
	//	voPackage=this.config.voPackage;
	}
	
	//methodes d'api publiques
	
	
	//-----------READING------------------
	/*public function test(op:String){
			Lib.print("pop"+op);
		}
		public function read(_vo:VoName,?id:Vo_Id,?offset:Offset){
			//	if (id!=null) getOne(_vo,id);
			
			Lib.print("pop");
			}

		function getOne(_vo:VoName,id:Vo_Id) : Void {
			
		}
		public function getAll(_vo:VoName):List<Spodable> {
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
		
		public function rec() : Void {

			parseClassMap(getClassMap());
			var monVo= createInstance(map.voClass);
			spodInsert(monVo,map.fields);
			php.Lib.print("hello from APiProto"+map.voClass);
			
		}
		
		
		
		private  function create(vo:VoName) : Void {
			
		}
		private function delete(vo:VoName,id:Vo_Id) : Void {
			
		}
		private function update(vo:VoName,id:Vo_Id) : Void {
			
		}

		function spodInsert(VoInstance:Spodable,liste:MicroFieldList){
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
						var depVoName=microfield.voName;


						//on doit parser un truc du type Monstre_form_MonstreChild_desc
						//on recupere le nom du vo parent... pas logique si plus de 2 niveaux
						//var parentVoRef:String=Lambda.list(first.elementId.split("_")).first();
						trace("isMicroFieldList"+depVoName);
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
		

		function parseClassMap(map:ClassMap):Void {
		
			//extracction de l'action du classMap?
		//	rec(getAction());
		}
		
		function getAction() :ACTION {
			return CREATE;
		}
		
		function createInstance(_vo:VoName) : Spodable {
			return Type.createInstance(Type.resolveClass(_vo),[]);
		}
		
		*/
	
}