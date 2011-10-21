package microbe;

class Collection< T: Collectable >
{
	public var P:T;
	var liste:List<T>;
	public function new()
	{
	liste= new List<T>();
	}
	public function add(l:T) : Void {
	liste.add(l);	
	}
	
	public function test() : String {
	return "blalala";
	}
	public function getLength():Int{
		return liste.length;
	}
	
}

interface Collectable{

	public function test():String{}
	
}
interface Objet{
	public function test():String{}
}




