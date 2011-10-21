package haxigniter.common.libraries;

class ParsedUrl
{
	public var scheme : String;
	public var host : String;
	public var port : Int;
	public var user : String;
	public var pass : String;
	public var path : String;
	public var query : String;
	public var fragment : String;
	
	private inline function ifMatch(input : String, searchFor : String, callBack : Int -> Void)
	{
		var pos = input.indexOf(searchFor);
		if(pos > = 0)
			callBack(pos);
	}
	
	public function new(url : String)
	{
		var self = this;
		
		host = url;
		path = '/';

		// Test for query
		ifMatch(host, '?', function(queryPos)
		{
			self.query = self.host.substr(queryPos + 1);
			self.host = self.host.substr(0, queryPos);
			
			// Test for fragment
			var fragmentPos = self.query.lastIndexOf('#');
			if(fragmentPos >= 0)
			{
				self.fragment = self.query.substr(fragmentPos + 1);
				self.query = self.query.substr(0, fragmentPos);
			}
		});
		
		// Test for scheme
		ifMatch(host, '://', function(schemePos)
		{
			self.scheme = self.host.substr(0, schemePos);
			self.host = self.host.substr(schemePos + 3);
		});

		// Test for username/password
		ifMatch(self.host, '@', function(loginPos)
		{
			self.user = self.host.substr(0, loginPos);
			self.host = self.host.substr(loginPos + 1);
			
			self.ifMatch(self.user, ':', function(passPos)
			{
				self.pass = self.user.substr(passPos + 1);
				self.user = self.user.substr(0, passPos);
			});
		});

		// Test for path
		ifMatch(self.host, '/', function(pathTest)
		{
			self.path = self.host.substr(pathTest);
			self.host = self.host.substr(0, pathTest);
		});

		// If no fragment, it may be left in the path part instead of the query.
		if(fragment == null)
		{
			ifMatch(path, '#', function(fragmentPos)
			{
				self.fragment = self.path.substr(fragmentPos + 1);
				self.path = self.path.substr(0, fragmentPos);
			});
		}

		// Test for port
		var portTest = ~/([^:]+):(\d+)\b/;
		if(portTest.match(self.host))
		{
			self.host = portTest.matched(1);
			port = Std.parseInt(portTest.matched(2));
		}
	}
	
	/**
	 * Parse a query string like name=this&email=that to a hash of key=value.
	 * It also works with full urls, parsing only the query part of it.
	 * @param	queryString
	 * @return
	 */
	public static function parseQuery(queryString : String) : Hash<String>
	{
		var output = new Hash<String>();
		var pairs : Array<String>;
		
		queryString = queryString.substr(queryString.indexOf('?') + 1);
		pairs = queryString.split('&');
		
		for(pair in pairs)
		{
			var keyValue = pair.split('=');
			
			if(keyValue.length == 2)
				output.set(keyValue[0], StringTools.urlDecode(keyValue[1]));
		}
		
		return output;
	}
	
	/**
	 * Parse a query string like name=this&email=that to a hash of key=value.
	 * It also works with full urls, parsing only the query part of it.
	 * @param	queryString
	 * @return
	 */
	public static function queryFromHash(query : Hash<String>) : String
	{
		var output = new List<String>();
		
		for(key in query.keys())
		{
			output.add(key + '=' + StringTools.urlEncode(query.get(key)));
		}
		
		return output.join('&');
	}
}
