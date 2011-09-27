package microbe.vo;
import php.db.Object;
import php.db.Manager;
import microbe.vo.Spodable;

class PositionManager extends Manager<Object>
{
	public var positions:IntHash<Dynamic>;
	public function new(spod:Object)
	{
		trace("newPositionMAnager");
		super(cast spod);
	//	positions= new IntHash<Int>();
	//	positions.set(1,2);
	}
	
	override function make( a:Object ):Void
	{
		php.Lib.print("make"+ positions);
		if( positions==null)positions= new IntHash<Int>();
		cast(a).positions=positions;
		//a.chapters = new List<Chapter>();//
		//a.voitures= VoitureVo.manager.search({id_prop:a.id}); //Chapter.manager.getAuthorChapters( a.id );
	}
	override function unmake(a:Object):Void{
		
		positions=cast(a).positions;
		php.Lib.print("unmake"+ positions);
		//php.Lib.print("unmake");
	//	a.voitures= VoitureVo.manager.search({id_prop:a.id});
	//	a.chapters = cmgr.getAuthorChapters( a.id );
	}
}