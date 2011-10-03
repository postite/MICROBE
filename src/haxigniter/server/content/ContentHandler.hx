package haxigniter.server.content;

typedef ContentData = {
	var mimeType : String;
	var charSet : String;
	var encoding : String;
	var data : String;
}

interface ContentHandler
{
	/**
	 * Modify the incoming content based on the meta data (web headers).
	 * @param	content
	 * @return  Any data transformation. For no changes, return content.data.
	 */
	function input(content : ContentData) : Dynamic;

	/**
	 * Format a response according to an output format.
	 * @param	content
	 * @return  Data output, or return null to avoid outputting anything.
	 */
	function output(content : Dynamic) : ContentData;
}
