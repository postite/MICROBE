package microbe.jsTools;
import msignal.Signal;
class BackSignal extends Signal1<String>
{
	public static  var preredirect:Signal1<Int>;
	public static  var preredirectomplete:Signal1<String>;
	
	public function new()
	{
		preredirect= new Signal1();
		preredirectomplete= new Signal1();
		super(String);
	}
}