package haxigniter.common.exceptions;

class Exception
{
	public var message(getMessage, null) : String;
	private var my_message : String;
	private function getMessage() { return this.my_message; }

	public var code(getCode, null) : Int;
	private var my_code : Int;
	private function getCode() { return this.my_code; }
	
	public var stack(getStack, null) : haxe.PosInfos;
	private var my_stack : haxe.PosInfos;
	private function getStack() { return this.my_stack; }
	
	public function new(message : String, ?code : Int = 0, ?stack : haxe.PosInfos)
	{
		message = StringTools.htmlEscape(message);

		this.my_message = message;
		this.my_code = code;
		this.my_stack = stack;
	}
	
	public function toString() : String
	{
		var msg : String = '[' + this.stack.className + " -> ";
		msg += this.stack.methodName + "() line ";
		msg += this.stack.lineNumber + "] " + this.message;

		return msg;
	}
}
