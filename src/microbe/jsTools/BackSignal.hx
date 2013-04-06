package microbe.jsTools;
import msignal.Signal;
class BackSignal extends Signal1<String>
{
	public static  var preredirect:Signal1<String>;
	public static  var complete:Signal1<String>;
	
	public function new()
	{
		preredirect= new Signal1();
		complete= new Signal1();
		super(String);
	}
}