package microbe.jsTools;
import msignal.Signal;
import microbe.ERROR;
class BackSignal extends Signal1<String>
{
	public static  var preredirect:Signal1<Int>;
	public static  var preredirectomplete:Signal1<String>;

	public static  var requestSaving:Signal1<microbe.form.Microfield>;
	public static  var requestSavingComplete:Signal1<String>;

	public static var  erreur:Signal1<microbe.ERROR>;
	public static var  tryAgain:Signal0;
	public function new()
	{
		preredirect= new Signal1();
		preredirectomplete= new Signal1();
		requestSaving= new Signal1();
		requestSavingComplete= new Signal1();
		erreur= new Signal1();
		tryAgain= new Signal0();
		super(String);
	}
}