package jquery.image;

import js.JQuery;

typedef LightBoxStringsOptions =
{
	var help:String; //' \u2190 / P - previous image\u00a0\u00a0\u00a0\u00a0\u2192 / N - next image\u00a0\u00a0\u00a0\u00a0ESC / X - close image gallery',
	var prevLinkTitle:String;// 'previous image',
	var nextLinkTitle:String;// 'next image',
	var prevLinkText:String;//  '&laquo; Previous',
	var nextLinkText:String;//  'Next &raquo;',
	var closeTitle:String;// 'close image gallery',
	var image:String;// 'Image ',
	var of:String;// ' of ',
	var download:String;// 'Download'
}
typedef LightBoxOptions =
{
	var allSet:Bool;// false,
	var fileLoadingImage:String;// 'images/loading.gif',
	var fileBottomNavCloseImage:String;// 'images/closelabel.gif',
	var overlayOpacity:Float;// 0.6,
	var borderSize:Int;// 10,
	var imageArray:Array<String>;// new Array,
	var activeImage:String;// null,
	var inprogress:Bool;// false,
	var resizeSpeed:Int;// 350,
	var widthCurrent:Int;// 250,
	var heightCurrent:Int;// 250,
	var scaleImages:Bool;// false,
	var xScale:Float;// 1,
	var yScale:Float;// 1,
	var displayTitle:Bool;// true,
	var navbarOnTop:Bool;// false,
	var displayDownloadLink:Bool;// false,
	var slideNavBar:Bool;// false, 
	var navBarSlideSpeed:Int;// 350,
	var displayHelp:Bool;// false,
	var strings:LightBoxStringsOptions;
	var fitToScreen:Bool;// false,		
	var disableNavbarLinks:Bool;// false,
	var loopImages:Bool;// false,
	var imageClickClose:Bool;// true,
	var jsonData:String;// null,
	var jsonDataParser:String;// null
}

#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end

extern class LightBox extends JQuery
{
	public static function __init__():Void {
  untyped __js__("var LightBox = window.jQuery");
	}
	public function lightbox(?options:LightBoxOptions) : Void ;
	
	
}