package controllers;

import vo.UserVo;
import microbe.backof.Back;
class Test


	extends Back
	{
		public function new()
		{
			// Call the superclass to set up database, configuration, etc
			super(new Login());

			var url = new haxigniter.server.libraries.Url(this.configuration);
			var user= new UserVo();
			user.nom="pop";
			session.user=user;
			// Some default view assignments for every page
			//this.view.assign('application', 'haXigniter');

			// The siteUrl() method creates a link to the web directory haXigniter is currently
			// located, so links won't be broken if moved somewhere else.
			//this.view.assign('link', url.siteUrl());

		//	this.view.assign('id', null);
		}

		override public function index()
		{
			// Displays 'start/index.mtt' (className/method, extension is from the ViewEngine.)
			this.view.display("test/index.mtt");
		}
}