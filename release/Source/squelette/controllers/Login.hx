
package controllers;
import php.Lib;
import vo.UserVo;
class Login extends microbe.backof.Login

{

	public function new()
	{
		
		super();
		
		
	}
	
	override public function index():Void{
			super.index();
		}
		
	override public function checkid(?param:String):Void{
				super.checkid();
	}
	
	override public function success(result:UserVo) {
		super.success(result);
	}
	override public function erreur(?p){
	super.erreur(p);
	}	

}
	


