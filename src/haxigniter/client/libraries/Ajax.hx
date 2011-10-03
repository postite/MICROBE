#if js
package haxigniter.client.libraries;

class Ajax 
{
	public static function xmlHttpRequest() : js.XMLHttpRequest
	{
		return untyped __js__('window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Msxml2.XMLHTTP")');
	}
	
}
#end