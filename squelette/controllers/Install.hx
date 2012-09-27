package controllers;


import microbe.Api;
import haxigniter.server.libraries.Url;
import microbe.controllers.GenericController;
import haxigniter.server.request.BasicHandler;

import php.Lib;
import microbe.vo.Spodable;
import php.Utf8;
import sys.db.TableCreate;


class Install extends GenericController
{
	function new()
	{
		super();
		this.requestHandler = new BasicHandler(this.configuration);
		sys.db.Manager.cleanup();
					//	new vo.News();
			sys.db.Manager.cnx = this.db.connection;
			sys.db.Manager.initialize();
	}

	function index(){
		// TableCreate.create(vo.News.manager);
		// TableCreate.create(vo.UserVo.manager);
		// TableCreate.create(vo.Taxo.manager);
		//TableCreate.create(vo.TagSpod.manager);

	}
}