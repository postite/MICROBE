#if php
package haxigniter.server.libraries;

import php.Lib;
import php.NativeArray;

class CurlOpt
{
	public static var AUTOREFERER = 58;
	public static var BINARYTRANSFER = 19914;
	public static var BUFFERSIZE = 98;
	public static var CAINFO = 10065;
	public static var CAPATH = 10097;
	public static var CLOSEFUNCTION = 20073;
	public static var CLOSEPOLICY = 72;
	public static var CONNECTTIMEOUT = 78;
	public static var COOKIE = 10022;
	public static var COOKIEFILE = 10031;
	public static var COOKIEJAR = 10082;
	public static var COOKIESESSION = 96;
	public static var CRLF = 27;
	public static var CUSTOMREQUEST = 10036;
	public static var DNS_CACHE_TIMEOUT = 92;
	public static var DNS_USE_GLOBAL_CACHE = 91;
	public static var EGDSOCKET = 10077;
	public static var ENCODING = 10102;
	public static var ERRORBUFFER = 10010;
	public static var FAILONERROR = 45;
	public static var FILE = 10001;
	public static var FILETIME = 69; // 10069 ?
	public static var FOLLOWLOCATION = 52;
	public static var FORBID_REUSE = 75;
	public static var FRESH_CONNECT = 74;
	public static var FTPAPPEND = 50;
	public static var FTPASCII = 53;
	public static var FTPLISTONLY = 48;
	public static var FTPPORT = 10017;
	public static var FTPSSLAUTH = 129;
	public static var FTP_SSL = 119;
	public static var FTP_USE_EPRT = 106;
	public static var FTP_USE_EPSV = 85;
	public static var HEADER = 42;
	public static var HEADERFUNCTION = 20079;
	public static var HTTP200ALIASES = 10104;
	public static var HTTPAUTH = 107;
	public static var HTTPGET = 80;
	public static var HTTPHEADER = 10023;
	public static var HTTPPOST = 10024;
	public static var HTTPPROXYTUNNEL = 61;
	public static var HTTPREQUEST = 10035;
	public static var HTTP_VERSION = 84;
	public static var INFILE = 10009;
	public static var INFILESIZE = 14;
	public static var INTERFACE = 10062;
	public static var KRB4LEVEL = 10063;
	public static var LOW_SPEED_LIMIT = 19;
	public static var LOW_SPEED_TIME = 20;
	public static var MAXCONNECTS = 71;
	public static var MAXREDIRS = 68;
	public static var MUTE = 55;
	public static var NETRC = 51;
	public static var NOBODY = 44;
	public static var NOPROGRESS = 43;
	public static var NOSIGNAL = 99;
	public static var NOTHING = 0;
	public static var PASSWDDATA = 10067;
	public static var PASSWDFUNCTION = 20066;
	public static var PORT = 3;
	public static var POST = 47;
	public static var POSTFIELDS = 10015;
	public static var POSTFIELDSIZE = 60;
	public static var POSTQUOTE = 10039;
	public static var PREQUOTE = 10093;
	public static var PROGRESSDATA = 10057;
	public static var PROGRESSFUNCTION = 20056;
	public static var PROXY = 10004;
	public static var PROXYPORT = 59;
	public static var PROXYTYPE = 101;
	public static var PROXYUSERPWD = 10006;
	public static var PUT = 54;
	public static var QUOTE = 10028;
	public static var RANDOM_FILE = 10076;
	public static var RANGE = 10007;
	public static var READFUNCTION = 20012;
	public static var REFERER = 10016;
	public static var RESUME_FROM = 21;
	public static var RETURNTRANSFER = 19913;
	public static var SSLCERT = 10025;
	public static var SSLCERTPASSWD = 10026;
	public static var SSLCERTTYPE = 10086;
	public static var SSLENGINE = 10089;
	public static var SSLENGINE_DEFAULT = 90;
	public static var SSLKEY = 10087;
	public static var SSLKEYPASSWD = 10026;
	public static var SSLKEYTYPE = 10088;
	public static var SSLVERSION = 32;
	public static var SSL_CIPHER_LIST = 10083;
	public static var SSL_VERIFYHOST = 81;
	public static var SSL_VERIFYPEER = 64;
	public static var STDERR = 10037;
	public static var TELNETOPTIONS = 10070;
	public static var TIMECONDITION = 33;
	public static var TIMEOUT = 13;
	public static var TIMEVALUE = 34;
	public static var TRANSFERTEXT = 53;
	public static var UPLOAD = 46;
	public static var URL = 10002;
	public static var USERAGENT = 10018;
	public static var USERPWD = 10005;
	public static var VERBOSE = 41;
	public static var WRITEFUNCTION = 20011;
	public static var WRITEHEADER = 10029;
	public static var WRITEINFO = 10040;
}

class CurlAuth
{
	public static var ANY = -1;
	public static var ANYSAFE = -2;
	public static var BASIC = 1;
	public static var DIGEST = 2;
	public static var GSSNEGOTIATE = 4;
	public static var NTLM = 8;
	
	public static var FTPAUTH_DEFAULT = 0;
	public static var FTPAUTH_SSL = 1;
	public static var FTPAUTH_TLS = 2;
}

class CurlInfo
{
	public static var EFFECTIVE_URL = 1;
	public static var HTTP_CODE = 2;
	public static var FILETIME = 14; // 2097166 ?
	public static var TOTAL_TIME = 3;
	public static var NAMELOOKUP_TIME = 4;
	public static var CONNECT_TIME = 5;
	public static var PRETRANSFER_TIME = 6;
	public static var STARTTRANSFER_TIME = 17;
	public static var REDIRECT_TIME = 19;
	public static var REDIRECT_COUNT = 20;
	public static var SIZE_UPLOAD = 7;
	public static var SIZE_DOWNLOAD = 8;
	public static var SPEED_DOWNLOAD = 9;
	public static var SPEED_UPLOAD = 10;
	public static var HEADER_SIZE = 11;
	public static var REQUEST_SIZE = 12;
	public static var SSL_VERIFYRESULT = 13;
	public static var CONTENT_LENGTH_DOWNLOAD = 15;
	public static var CONTENT_LENGTH_UPLOAD = 16;
	public static var CONTENT_TYPE = 18;
}

class CurlMisc
{
	public static var CLOSEPOLICY_LEAST_RECENTLY_USED = 2;
	public static var CLOSEPOLICY_OLDEST = 1;
	public static var PROXY_HTTP = 0;
	public static var PROXY_SOCKS5 = 5;
	public static var HTTP_VERSION_1_0 = 1;
	public static var HTTP_VERSION_1_1 = 2;
	public static var HTTP_VERSION_NONE = 0;
	public static var TIMECOND_IFMODSINCE = 1;
	//public static var TIMECOND_ISUNMODSINCE =
}


class LibCurl 
{
	private var handle : Dynamic;
	private var returnTransfer : Bool;
	
	public static function isAvailable() : Bool
	{
		return untyped __call__('extension_loaded', 'curl');
	}
	
	public function new(?url : String, ?returnHeader = false, ?verifySSL = false)
	{
		if(url != null)
			this.handle = untyped __call__('curl_init', url);
		else
			this.handle = untyped __call__('curl_init');
	
		// Need to keep track of the returntransfer value for the exec() method.
		setOpt(CurlOpt.RETURNTRANSFER, true);
		this.returnTransfer = true;
		
		setOpt(CurlOpt.HEADER, returnHeader);
		
		if(!verifySSL)
		{
			setOpt(CurlOpt.SSL_VERIFYHOST, false);
			setOpt(CurlOpt.SSL_VERIFYPEER, false);
		}
	}
	
	public function setOpt(option : Int, value : Dynamic) : Bool
	{
		if(option == CurlOpt.RETURNTRANSFER)
			returnTransfer = untyped __call__('empty', value);
		
		return untyped __call__('curl_setopt', handle, option, value);
	}
	
	public function close() : Void
	{
		untyped __call__('curl_close');
	}
	
	public function copyHandle() : LibCurl
	{
		var output = Type.createEmptyInstance(LibCurl);
		
		Reflect.setField(output, 'handle', untyped __call__('curl_copy_handle', handle));
		Reflect.setField(output, 'returnTransfer', returnTransfer);
		
		return cast output;
	}
	
	public function errNo() : Int
	{
		return untyped __call__('curl_errno', handle);
	}
	
	public function error() : String
	{
		return untyped __call__('curl_error', handle);
	}
	
	public function exec() : String
	{
		var output = untyped __call__('curl_exec', handle);
		
		if(!returnTransfer || untyped __physeq__(output, false))
			return null;
		else
			return output;
	}
	
	public function getInfo(opt : Int) : Hash<Dynamic>
	{
		return Lib.hashOfAssociativeArray(untyped __call__('curl_getinfo', handle, opt));
	}
	
	public function version() : Hash<Dynamic>
	{
		return Lib.hashOfAssociativeArray(untyped __call__('curl_version', opt));
	}
	
	///// Http implementation ///////////////////////////////////////
	
	public function get(url : String, ?data : Dynamic) : String
	{		
		setOpt(CurlOpt.POST, false);		
		return sendRequest(url, data);
	}
	
	public function post(url : String, ?data : Dynamic) : String
	{
		setOpt(CurlOpt.POST, true);
		return sendRequest(url, data);
	}
	
	public function put(url : String, ?data : Dynamic) : String
	{
		return sendRequest(url, data, 'PUT');
	}
	
	public function delete(url : String, ?data : Dynamic) : String
	{
		return sendRequest(url, data, 'DELETE');
	}
	
	/////////////////////////////////////////////////////////////////
	
	private function sendRequest(url : String, ?data : Dynamic, ?method : String)
	{
		setOpt(CurlOpt.URL, url);

		if(data != null)
		{
			if(!Std.is(data, String))
				data = toQueryString(data);
		
			setOpt(CurlOpt.POSTFIELDS, data);
		}
		
		if(method != null)
		{
			setOpt(CurlOpt.POST, false);
			setOpt(CurlOpt.CUSTOMREQUEST, method);
		}

		return this.exec();
	}
	
	// Thanks to John A. De Goes for this useful method.
	private function toQueryString(data:Dynamic):String
	{
	    if (data == null) return "";
	    
	    var fieldNames:Iterator<String>;
	    var valueOf:   String -> String;
	    
        if (Std.is(data, String)) return data;
        
	    if (Std.is(data, Hash)) {
	        var hash = cast(data, Hash<Dynamic>);
	        
	        fieldNames = hash.keys();
	        valueOf    = function(fieldName) return Std.string(hash.get(fieldName));
	    }
	    else {
	        fieldNames = Reflect.fields(data).iterator();
	        valueOf    = function(fieldName) return Reflect.field(data, fieldName);
	    }
        
	    var buf = new StringBuf();
        var isFirst = true;
	    
	    for (fieldName in fieldNames) {
	        var fieldValue = valueOf(fieldName);
	        
	        if (isFirst) isFirst = false;
	        else buf.add('&');
	        
	        buf.add(fieldName);
	        buf.add('=');
	        buf.add(StringTools.urlEncode(Std.string(fieldValue)));
	    }

        return buf.toString();
	}
}
#end
