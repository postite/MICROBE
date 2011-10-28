package controllers;

import microbe.backof.Back;
/*import microbe.controllers.GenericController;
import microbe.FormGenerator;
import microbe.Api;
import microbe.vo.Page;
import microbe.vo.Spodable;
import microbe.tools.JSLIB;

import microbe.backof.Navigation;*/
import vo.UserVo;

class Myback extends Back {
	
	
/*	public var spodeur:Spodable;
	var generator:FormGenerator;
	public var api:Api;
	
		//config
		public static var backjs:String="/js/backjs.js";
		public static var backInstance:String="microbe.jsTools.BackJS";
		public var jsScript:List<String>;
		public var jsLib:JSLIB;*/
		
		
	public function new(){
		super(new Login());
		
		/*jsScript=new List<String>();
				jsLib= new JSLIB();
				
				generator= new FormGenerator();
				FormGenerator.voPackage="vo.";
				chemins="popopop";*/
		var user= new UserVo();
		user.nom="pop";
		//session.user=user;
		
		/*api= new Api();	*/
		this.view.assign("contenttype",null);
	}
	public function defaultAssign() 
	{
		//	createMenu();
			this.view.assign("page", null);
			this.view.assign("link", url.siteUrl());
			this.view.assign("backpage",url.siteUrl()+"/myback");
			
			/*this.view.assign("chemins", this.chemins);
			this.view.assign("menu", null);*/
			//this.view.assign("content", null);
			
			/*this.view.assign("currentVo","Monstre");
						this.view.assign("jsScript",jsScript);
						this.view.assign("jsLib",jsLib);*/
			this.view.assign("titre", "administrationMelle");
			this.view.assign("scope",this);
			
			
	}

	
	override function index() : Void {
	//	php.Lib.print('yo');
		trace("index");
		//	trace("session="+session.user.nom);
			//jsLib.add(backjs);
			//session.user=null;
			defaultAssign();		
			this.view.assign("content", "popopo");
			this.view.display("back/design.mtt");
	}
	
	
	
}		