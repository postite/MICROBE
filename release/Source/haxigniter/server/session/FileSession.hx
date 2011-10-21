package haxigniter.server.session; 

#if php
typedef InternalSession = php.Session;
#elseif neko
typedef InternalSession = haxigniter.server.session.NekoSession;
#end

class FileSession implements Session
{
	public function new(savePath : String)
	{
		InternalSession.setSavePath(savePath);
	}

	public function start() : Void
	{
		InternalSession.start();
	}
	
	public function close() : Void
	{
		#if php
		untyped __call__("session_write_close");
		#elseif neko
		InternalSession.close();
		#end
	}

	public function clear() : Void
	{
		#if php
		untyped __call__("session_unset");
		#elseif neko
		InternalSession.clear();
		#end
	}

	public function get(name : String) : Dynamic
	{
		return InternalSession.get(name);
	}

	public function set(name : String, value : Dynamic) : Void
	{
		InternalSession.set(name, value);
	}

	public function exists(name : String) : Bool
	{
		return InternalSession.exists(name);
	}

	public function remove(name : String) : Void
	{
		InternalSession.remove(name);
	}
}
