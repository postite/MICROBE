package microbe;
import microbe.form.MicroFieldList;
import microbe.form.Microfield;
import microbe.form.IMicrotype;

class MicroParser
{
	private var source: IMicrotype;
	public function new(_source:IMicrotype)
	{
		source=cast _source;
	}
	public function parse() : Void {
	//	for (a in source.iterator()){
			//trace(a.type);
			var factory = new TypeFactory();
			var behaviour=factory.create(source.type);
			trace(behaviour.parse(source));
	//	}
	}
	
}