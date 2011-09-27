package controllers;
//import microbe.Apiprox;

import haxigniter.server.request.BasicHandler;
import haxigniter.server.request.ApiDecorator;
//import microbe.vo.Spodable;
//import microbe.ApiPop;
import microbe.Apiprototype;
import microbe.controllers.GenericController;


class Gap extends GenericController  {
	
	
	public function new(){
	super();
	
	this.requestHandler = new ApiDecorator(new BasicHandler(this.configuration),this.configuration);
	}
	
	function index(d:Dynamic){
		
			this.view.assign("content",d.toString());
			this.view.display("simple.mtt");
	}
	
	
	
	/*public function index(){
			php.Lib.print("hello from GAp");
		}*/
/*	override public function rec(){
		super.rec();
		//php.Lib.print("hello from Api");
	}*/
	/*override public function getAll(_vo:String):List<Spodable>{
				return super.getAll(_vo);
		}
		override public function test(op:String){
			try
			{
			super.test(op);
			}catch (e:Dynamic)
			{
			php.Lib.print("erreur");
			}
			
		}*/

	
}