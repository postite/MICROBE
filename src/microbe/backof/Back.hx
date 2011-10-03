package microbe.backof;

import vo.UserVo;
import haxigniter.server.request.BasicHandler;
import haxigniter.server.request.AuthRequestDecorator;
import haxigniter.server.libraries.Url;
import microbe.controllers.GenericController;

class Back extends GenericController
{
	public var url:Url;
	private var chemins:Dynamic;
	
	
	public function new(LoginPage:Login)
	{
		super();
	//	spodeur = new Spodeur();
	//pour l'authentification
	this.requestHandler = new AuthRequestDecorator(new 	BasicHandler(this.configuration),LoginPage,session);
	url= new Url(this.configuration);
			//pour le test
	//	var user= new UserVo();
	//	user.nom="pop";
	//	session.user=user;
		//....
//	this.requestHandler=new BasicHandler(this.config);
		//url = new Url(this.config);
		//	chemins = { js:this.config.jsPath, css:this.config.cssPath };
	}
	
/*	function defaultAssign() {

			//createMenu();
			this.view.assign("page", null);
			this.view.assign("link", url.siteUrl());
			this.view.assign("chemins", this.chemins);
			//this.view.assign("menu", menu.items);
			this.view.assign("content", null);
			this.view.assign("titre", "administrationMelle");

		}
	
	
	function loadDesign() {
			this.view.display("back/design.mtt");
	}*/
	
	
	
	public function index(){
	
	//	defaultAssign();
	//	loadDesign();
	this.view.assign("content", "popopopo");
	this.view.display("simple.mtt");
	}
}		