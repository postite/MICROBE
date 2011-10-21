package controllers;
import microbe.controllers.GenericController;
import haxigniter.server.request.BasicHandler;
typedef Pop =
{
	var label:String;
	var data:Dynamic;
}
class Terazor extends GenericController
{
	public function new()
	{
		super();
		this.requestHandler = new BasicHandler(this.configuration);
	}
	
	public function index() : Void {
		var liste = new List<Pop>();
		liste.add({label:"UN",data:"one"});
		liste.add({label:"DEUX",data:"two"});
		liste.add({label:"TROIS",data:"three"});
		this.view.assign("test", "heelo world");
		this.view.assign("liste",liste);
		this.view.display("test/ErazorTest.html");
	}
	
}