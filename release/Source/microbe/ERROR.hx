package microbe;


enum ERROR_TYPE{
	DOUBLON;
	FATAL;
}
class ERROR 
{
	public var message:String;
	public var type:ERROR_TYPE;
	public var forfield:String;
	public function new(type:ERROR_TYPE,?message:String,?forfield:String)
	{
		this.message=message;
		this.type=type;
		this.forfield=forfield;
	}
}