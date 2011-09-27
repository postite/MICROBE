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
								//	session.user=user;
				//	session.user=null;
			//spodeur= new Spodeur();	
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
		 return api.getAll(voName);
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
		
		
		public function ajoute(voName:String):Void{
			trace("ajoute");
			generator.generateComplexClassMapForm(voName);
			jsLib.add(backjs);
			//jsScript.add("pop();");
			jsScript.add(backInstance+".instance.setClassMAp('"+generator.compressedClassMap+"');");
			//jsScript.add("alert('popop');");
			defaultAssign();
			this.view.assign("currentVo",voName);	
			this.view.assign("content", generator.formulaire);
		//	this.view.assign("content", "popopo");
			this.view.display("back/design.html");

		}
		public function rec(){
		  return api.rec();
		}

		public function delete(voName:String,id:Int):Void{
			api.delete(voName,id);
			nav(voName);
		}
		
	
		
		
}