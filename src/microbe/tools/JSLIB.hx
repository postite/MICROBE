package microbe.tools;

class JSLIB
{
	var liste:List<String>;
	
	public function new()
	{
		liste= new List<String>();
		
	}
	public function add(s:String):Void{
		liste.add(s);
	}
	public function addOnce(s:String):Void{
		if(Lambda.has(liste, s)==true)return;
		add(s);
	}
	public function iterator():Iterator<String>{
		return liste.iterator();
	}
	public function first(){
		return liste.first();
	}
	public function last(){
		return liste.last();
	}
	public function remove( v : Dynamic ) : Bool {
		return liste.remove(v);
	}
}