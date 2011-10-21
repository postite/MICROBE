package haxigniter.server.session; 

class SessionObject
{
	///// Static stuff for the wrapper //////////////////////////////

	private static var session : Session;	
	private static var sessionName : String = '_haxigniter_session_';

	private static var flashName = '_flash';
	
	public static function restore<T>(session : Session, classType : Class<T>, ?classArgs : Array<Dynamic>) : T
	{
		if(SessionObject.session != null && SessionObject.session != session)
			throw 'Cannot change session handler for SessionObject.';
		else
			SessionObject.session = session;
		
		var object = objectName(classType);
		
		if(!session.exists(object))
		{
			session.set(object, Type.createInstance(classType, classArgs == null ? [] : classArgs));
		}
		
		var output = cast session.get(object);
		
		if(Reflect.hasField(output, 'flashVar'))
		{
			Reflect.setField(output, 'flashVar', getObjFlash(classType));
			
			// Set flashvar to null, so it's gone on the next request.
			setObjFlash(classType, null);
		}
		
		return output;
	}
	
	private static function objectName(classType : Class<Dynamic>) : String
	{
		return sessionName + Type.getClassName(classType);
	}

	private static function setObjFlash(classType : Class<Dynamic>, value : Dynamic) : Void
	{
		var object = objectName(classType);
		session.set(object + flashName, value);
	}
	
	private static function getObjFlash(classType : Class<Dynamic>) : Dynamic
	{
		var object = objectName(classType);
		return session.exists(object + flashName) ? session.get(object + flashName) : null;
	}
	
	/////////////////////////////////////////////////////////////////
	
	public var flashVar(default, setFlash) : Dynamic;
	private function setFlash(value : Dynamic)
	{
		setObjFlash(Type.getClass(this), value);
		this.flashVar = value;
	}
	
	/**
	* This class should only be created with the restore() factory method, so constructor is private.
	*/
	private function new() { }
}
