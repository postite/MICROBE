package vo;
import sys.db.Types;

interface Traductable 
{
	public var lang:SString<11>;
	public var id_ref:Int;
	public function getTrad(lang:String):Int;


	///have to move it to Enum
// public function getTrad(lang:String):Int
// {
// 	try{ 
// 		return Microbenews.manager.search({id_ref:this.id,lang:lang}).first().id;
// 		}catch(e:String){
// 		return 0;
// 	}
// }
}
