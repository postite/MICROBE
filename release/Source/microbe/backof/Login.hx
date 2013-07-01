package microbe.backof;
import haxigniter.server.Controller;
import haxigniter.server.libraries.Url;
import haxigniter.server.request.BasicHandler;
import microbe.form.elements.Button;
import microbe.form.elements.Input;
import microbe.form.Form;

import haxigniter.server.libraries.DebugLevel;
import vo.UserVo;
import microbe.controllers.GenericController;
import php.Lib;


import sys.db.ResultSet;

/**

 * ...
 * @author postite

*/


typedef Utilisateur = {
    var mdp : String;
    var nom : String;
}

class Login extends GenericController, implements Controller
{
	private var url:Url;
	
	public function new() 
	{
		super();
		this.requestHandler = new BasicHandler(this.configuration);
		url = new Url(this.configuration);
	}
	function defaultAssign() {
		this.view.assign("customLogo",null);
		this.view.assign("page", null);
		this.view.assign("link", url.siteUrl());
		this.view.assign("backpage",url.siteUrl()+"/"+config.Config.backPage);
		this.view.assign("title","microbe admin");
		this.view.assign("localClass","login");
		this.view.assign("custom",true);
		/*this.view.assign("chemins", this.chemins);
		this.view.assign("menu", null);*/
		//this.view.assign("content", null);
		this.view.assign("menu",null);
		this.view.assign("currentVo",null);
		this.view.assign("jsScript",null);
		this.view.assign("jsLib",null);
		this.view.assign("titre", "Microbe admin");
		this.view.assign("scope",this);
		this.view.assign("contenttype",null);
	/*	this.view.assign("page", "login");
			this.view.assign("link", url.siteUrl());
			this.view.assign("chemins", { js:this.configuration.jsPath, 		css:this.configuration.cssPath });
			this.view.assign("menu",null);
			this.view.assign("content", null);
			this.view.assign("commentaire", "nul");
			this.view.assign("titre", "administrationMelle");*/
		
	}
	private function creeForm():Form {
		var formulaire:Form = new Form("logForm");
		formulaire.addElement(new Input("login", "identifiant"));
		formulaire.addElement(new Input("mdp", "mot de passe"));
		var bouton:Button = new Button("submit", "soumettre", "soumettre");
		formulaire.setSubmitButton(bouton);
		return formulaire;
	}
	public function index() {
	//	Lib.print("popopop");
	//	trace("login"+"index");
		var formulaire:Form = creeForm();
		formulaire.action = url.siteUrl()+"/login/checkid/pop";
		defaultAssign();
	
		this.view.assign("content", formulaire);
		this.view.assign("commentaire","rien");
		this.view.display("back/design.html");
		
	}
	public function checkid(?pop:String){
	//	trace("youhou"+"checkID");
		var formulaire:Form = creeForm();
		formulaire.populateElements();
		defaultAssign();
		this.view.assign("content",formulaire);
	//	this.view.display("back/design.html");
		
	//return 	erreur("pop="+pop);
		var result:ResultSet = this.db.query("SELECT * FROM user WHERE nom LIKE '" + formulaire.getValueOf('login') + "' AND mdp LIKE '" + formulaire.getValueOf('mdp')+"'");
		if (result.length > 0) {
			var u:UserVo=result.next();
		//	trace("mdpop=" + u.mdp);
			/*var user:Utilisateur= cast {};
						user.mdp=u.mdp;
						user.nom=u.nom;
						trace("user=" + user);*/
			success(u);
		}else {
			erreur("pop="+pop);
		}
		
	}
	public function erreur(?param) {
		trace("errur"+param);
		var formulaire:Form = creeForm();
		formulaire.populateElements();
		defaultAssign();
		
		this.view.assign("content", formulaire);
		this.view.assign("commentaire", "erreur d'identification");
		this.view.display("back/design.html");
	}
	
	public function success(result:UserVo) {
		
		/*var user:UserVo= new UserVo();
				user.mdp=result.mdp;
				user.nom=result.nom;*/
		
		// this.trace("result.next="+result);
		
		// defaultAssign();
		// 		var formulaire2:Form = new Form("cool");

			session.user = result;
			
		// 		formulaire2.submitButton=new Button("continuer", "continuer", "continuer");
		// 		formulaire2.action = url.siteUrl() + "/"+config.Config.backPage+"/";
				
		// 		this.view.assign("content", formulaire2);
		// 		this.view.assign("commentaire", "merci de vous etre identifie ");
		// 		this.view.display("back/design.html");

				php.Web.redirect( url.siteUrl() + "/"+config.Config.backPage+"/");
		
		
		
	}
}