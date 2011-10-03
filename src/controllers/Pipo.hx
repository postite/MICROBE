package controllers;

import vo.UserVo;
import microbe.backof.Back;
import microbe.controllers.GenericController;
import microbe.FormGenerator;
import microbe.Api;
import microbe.vo.Page;
import microbe.vo.Spodable;
import microbe.tools.JSLIB;
import microbe.backof.Navigation;
import php.Web;
import php.Lib;
import sys.db.Manager;
import sys.db.Object;
import microbe.MicroCreator;
class Pipo extends Back
	{
		
		//config
		
		public static var backjs:String=GenericController.appConfig.jsPath+GenericController.appConfig.backjs;
		public static var backInstance:String="microbe.jsTools.BackJS";
		public var api:Api;
		public var jsScript:List<String>;
		public var jsLib:JSLIB;
		
		var generator:FormGenerator;
		
		public function new()
		{
			super(new Login());
			
			jsScript=new List<String>();
			jsLib= new JSLIB();
			
		generator= new FormGenerator();
		FormGenerator.voPackage="vo.";
		
			chemins="popopop";
			var user= new UserVo();
			user.nom="pop";
			
			//session.user=user;
			//session.user=null;
			//spodeur= new Spodeur();
			
					//	new vo.News();
			sys.db.Manager.cnx = this.db.connection;
			sys.db.Manager.initialize();
		//	sys.db.TableCreate.create(vo.ChildTest.manager);
		//	sys.db.TableCreate.create(vo.RelationTest.manager);
			
		//	new vo.Edito();
			api= new Api();	
			this.view.assign("contenttype",null);
		}
		
		public function defaultAssign() 
		{
			//	createMenu();
				this.view.assign("page", null);
				this.view.assign("link", url.siteUrl());
				this.view.assign("backpage",url.siteUrl()+"/pipo");
				this.view.assign("titre","microbe admin");
				
				this.view.assign("menu", getMenu());
				/*this.view.assign("chemins", this.chemins);
				this.view.assign("menu", null);*/
				//this.view.assign("content", null);
				this.view.assign("contentype",null);
				this.view.assign("currentVo",null);
				this.view.assign("jsScript",jsScript);
				this.view.assign("jsLib",jsLib);
				
				this.view.assign("title", "Microbe admin");
				this.view.assign("scope",this);

		}
		
		public function nav(voName:String){
			trace("voName="+voName);
			defaultAssign();
			jsLib.addOnce(backjs);
			jsLib.addOnce(GenericController.appConfig.jsPath+"jquery-ui-1.8.14.custom.min.js");	
			this.view.assign("currentVo",voName);
			/////// not ready specific renderer pour les pages ...ou autres
			var content:String="";
			return choix(null,voName);
			////.....end
			this.view.assign("content", content);
			this.view.display("back/design.html"); 
			return;
		}
		
		public function choix(?id:Int,voName:String){

			trace("choix id="+id+" vo="+voName);
			var data:Spodable=null;
			if(id==null){
			data=api.getLast(voName);
			}else{
			data=api.getOne(voName,id);
			}
			if( Std.is(data,Page))this.view.assign("contenttype","page");
			generator.generateComplexClassMapForm(voName,data);
			jsLib.addOnce(GenericController.appConfig.jsPath+"jquery-ui-1.8.14.custom.min.js");
			jsLib.addOnce(backjs);//TODO verif si besoin est ! commenté pour eviter doublon...
			
			jsScript.add(backInstance+".instance.setClassMap('"+generator.compressedClassMap+"');");
			//jsScript.add("alert('popop');");
			defaultAssign();
			this.view.assign("currentVo",voName);
			this.view.assign("content", generator.render());
			this.view.display("back/design.html");
		}
		
		public function getVoList(voName:String):List<Spodable>{
		//	return 	spodeur.getRecordList(voName);
		 return api.getAllorded(voName);
		}
		
		public function getMenu():List<NavItem>{
			var navig= new Nav();
			return navig.items;		
		}
		
		override function index() : Void {
			trace("index");
			jsLib.add(backjs);
			//session.user=null;
			defaultAssign();		
			this.view.assign("content", "popopo");
			this.view.display("back/design.html");
			trace("after");
		}
		
		///////CRUD///////
	

		public function getPage(voName:String):Spodable{
			return api.getOne(voName,1);
		}
		public function addCollectItem():Void{
			var params=Web.getParams();
			var voName:String=params.get("voName");
			var voParent:String= params.get("voParent");
			var parentId:Int= Std.parseInt(params.get("voParentId"));
			
			
			var newCollectItem:Object= cast Type.createInstance(Type.resolveClass(GenericController.appConfig.voPackage+voName),[]);
					var parentClass=Type.resolveClass(GenericController.appConfig.voPackage+voParent);
					var parentSpod:Object=cast Type.createInstance(parentClass,[]);
						
					var Pmanager:Manager<Object>=Reflect.field(parentClass,"manager");
					var parent:Object=Pmanager.unsafeGet(parentId);
					
						
					Reflect.callMethod(newCollectItem, "set_rel", [parent]);
					newCollectItem.insert();
					var newID=cast(newCollectItem).id;
					var creator:MicroCreator= new MicroCreator();
					var microFieldItem=creator.justGet(voName,cast(newCollectItem,Spodable).getFormule());
					microFieldItem.id=newID;
					microFieldItem.voName=voName;
					microFieldItem.type= collection;
				//	microFieldItem.field=
					
					var XmicroFieldItem= haxe.Serializer.run(microFieldItem);
					Lib.print(XmicroFieldItem);
		}
		
		public function ajoute(voName:String):Void{
			trace("ajoute");
			generator.generateComplexClassMapForm(voName);
			jsLib.addOnce(backjs);
			
			jsScript.add(backInstance+".instance.setClassMap('"+generator.compressedClassMap+"');");
		
			defaultAssign();
			this.view.assign("currentVo",voName);	
		
			this.view.assign("content",generator.render());
		
		
			this.view.display("back/design.html");

		}
		public function rec(){
		  return api.rec();
		}

		public function delete(voName:String,id:Int):Void{
			api.delete(voName,id);
			nav(voName);
		}
		public function reorder(voName:String){
			var manager:Manager<sys.db.Object>=cast (Type.resolveClass(GenericController.appConfig.voPackage+voName)).manager;
			var table=manager.dbInfos().name;
			trace("currentVo"+voName);
			var data=Web.getParams().get("orderedList");
			var tab:Array<Int>=haxe.Unserializer.run(data);
			
			//when then en php ... ça marche pas avec haxe 
			//$liste=(1,3,6,9)// liste of spod_ids
			//$ordre= poz
		/*	function updateListe($liste){

									    $ids = implode(',', $liste);
									    $sql = "UPDATE favoris SET ordre = CASE id_album ";
									    foreach ($liste as $ordre => $id_album) {
									      $sql .= sprintf("WHEN %d THEN %d ", $id_album, $ordre);
									    }
									    $sql .= "END WHERE id_album IN ($ids)";
											$sqlQuery = new SqlQuery($sql);
											$ret = $this->executeUpdate($sqlQuery);
									    return $ret;

									}*/
			
						///ça peut etre plus efficace avec un When then
						for (i in 0...tab.length) {  
						           db.query("UPDATE "+table+" SET poz = "+i+" WHERE id = "+tab[i]+" ");
						          }
						
			
		
			Lib.print("lkl"); //TODO :retourner un truc plus parlant genre success or not

		}
		
	
		
		
}