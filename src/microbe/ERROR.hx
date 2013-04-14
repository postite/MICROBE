package microbe;


enum ERROR_TYPE{
	DOUBLON;
	FATAL;
}
class ERROR 
{
	public var message:String;
	public var type:ERROR_TYPE;
	public function new(type:ERROR_TYPE,?message:String)
	{
		this.message=message;
		this.type=type;
	}
}