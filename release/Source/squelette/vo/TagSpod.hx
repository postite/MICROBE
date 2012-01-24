package vo;
import sys.db.Object;
import sys.db.Manager;
import sys.db.SpodInfos;
import sys.db.Types;

//@:id(tag_id) ne pas metter d'id pour ne pas generer de primary key...
@:table('tagSpod')
class TagSpod extends Object
{
	
	
		public var tag_id:SInt;
		public var spod_id:SInt;
}