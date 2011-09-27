
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
		
		override public function checkId():Void{
			super.checkId();
		}
	
	override public function success(result:UserVo) {
		super.success(result);
	}
	
}