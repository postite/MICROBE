package microbe.tools;

#if js
import js.Lib;
#end

class Debug
{
	public  static var debug:Bool=false;
	public static function Alerte(str:String,?pos:haxe.PosInfos){
		
		// if (debug==true){
		//  	var instance=Type.resolveClass(pos.className);
		//  			if(Reflect.field(instance,"debug")==true){
		//  				#if js Lib.alert(str+"\nclass="+pos.className+" n° "+pos.lineNumber +"\n"+"methode:"+pos.methodName  );#end
		//  			}
		// } 
	}
}