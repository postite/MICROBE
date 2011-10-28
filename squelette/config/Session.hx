package config;
import vo.UserVo;
/**
 * By inheriting from haxigniter.server.libraries.SessionObject, 
 * this class is automatically retained by PHP or Neko session.
 *
 * Just add and set the variables you like. Very useful for shopping carts, user data, etc.
 * You can also make it implement Dynamic so it can be done on-the-fly.
 */
class Session extends haxigniter.server.session.SessionObject
{
	public var name : String;
	public var user:UserVo;
	public function new()
	{	
		super(); // This is required.
	}
}
