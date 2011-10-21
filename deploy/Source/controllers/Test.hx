package controllers;
/*
import vo.UserVo;
import microbe.backof.Back;*/
import microbe.controllers.GenericController;
import microbe.form.Form;
import microbe.form.elements.Input;
import microbe.form.elements.Button;
import haxigniter.server.request.BasicHandler;
import haxigniter.server.libraries.Url;
class Test extends GenericController

	{
		var url:Url;
		public function new()
		{
			super();
			this.requestHandler= new BasicHandler(this.configuration);
			url = new Url(this.configuration);
		}
		
		private function creeForm():Form {
			var formulaire:Form = new Form("logForm");
			formulaire.addElement(new Input("login", "identifiant"));
			formulaire.addElement(new Input("mdp", "mot de passe"));
			var bouton:Button = new Button("submit", "soumettre", "soumettre");
			formulaire.setSubmitButton(bouton);
			return formulaire;
		}
		 public function index()
		{
			var formulaire:Form = creeForm();
			formulaire.action = url.siteUrl()+"/test/checkid/";
		//	defaultAssign();

			this.view.assign("content", formulaire);
			
			
			// Displays 'start/index.mtt' (className/method, extension is from the ViewEngine.)
			this.view.assign("content",formulaire);
			this.view.display("test/logintest.html");
		}
		public function checkid() : Void {
			var formulaire:Form = creeForm();
			formulaire.populateElements();
			trace("olo"+php.Web.getParams());
		//	formulaire.getElement("login").value=php.Web.getParams().get("login");
			/*for(a in php.Web.getParams().keys()){
							//formulaire.getElement(a).value=php.Web.getParams().get(a);
							trace("a="+a);
						}*/
			
			for (elem in formulaire.getElements() ){
				trace("elem="+elem.value);
			}
		//	formulaire.action = url.siteUrl()+"/test/checkid/";
		//	defaultAssign();

			this.view.assign("content", formulaire);
			
			
			// Displays 'start/index.mtt' (className/method, extension is from the ViewEngine.)
			this.view.assign("content",formulaire);
			this.view.display("test/logintest.html");
		}
		
		
		
}