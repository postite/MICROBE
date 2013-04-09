package microbe.jsTools;
import msignal.Signal;
class BackSignal extends Signal1<String>
{
	public static  var preredirect:Signal1<Int>;
	public static  var preredirectomplete:Signal1<String>;

	public static  var requestSaving:Signal1<microbe.form.Microfield>;
	public static  var requestSavingComplete:Signal1<String>;
	public function new()
	{
		preredirect= new Signal1();
		preredirectomplete= new Signal1();
		requestSaving= new Signal1();
		requestSavingComplete= new Signal1();
		super(String);
	}
}