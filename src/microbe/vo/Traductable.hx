package microbe.vo;
import sys.db.Types;

interface Traductable 
{
	public var lang:Null<SString<11>>;
	public var id_ref:Int;
	public function getTrad(lang:String):Int;
}
