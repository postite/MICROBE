package haxigniter.server.routing;

/**
 * The Alias class uses regexps to rewrite the url. Each regexp is followed by a string
 * that determines how the url should be rewritten if the regexp matches the url.
 */
class Alias
{
	private var regexps : Array<EReg>;
	private var rewrites : Array<String>;

	public function new()
	{
		this.regexps = new Array<EReg>();
		this.rewrites = new Array<String>();
	}
	
	public function add(regexp : EReg, rewrite : String)
	{
		this.regexps.push(regexp);
		this.rewrites.push(rewrite);
	}

	public function remove(i : Int) : Bool
	{
		if(regexps.length <= i) return false;
		
		this.regexps.splice(i, 1);
		this.rewrites.splice(i, 1);
		return true;
	}

	public function rewriteUrl(url : String) : String
	{
		for(i in 0 ... regexps.length)
		{
			if(regexps[i].match(url))
				return regexps[i].replace(url, rewrites[i]);
		}
		
		return url;
	}
}