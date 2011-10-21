package jquery.nav;
import js.JQuery;

//@require modifyied version of jquery.nav.min.js


typedef OnePageNavOptions =
{
var	currentClass:String;//"current" Class to add to the list item when the navigation item is selected
var changeHash:Bool;//false If you want the hash to change when the user clicks on the navigation, change this to true
var scrollSpeed:Int;//750 Speed to scroll the page when the navigation is clicked
}
typedef ScrollEventDef =
{
	var data:Dynamic;
	var event:String;
}
typedef OnePageEx =
{
	var sections:List<Dynamic>;
	var data:String;
	var scrollEvent:ScrollEventDef;
}



#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end

extern class OnePageNav extends JQuery
{
//	public var scrollEventEx:ScrollEventDef;
	//public var sections:Dynamic;
	public inline static var scrollChange:String="scrollChange";
	public inline static var adjust:String="adjustNav";
	public var FonePageNav:OnePageEx;///fake scope to access insiders variables inside onPageNav
	public static function __init__():Void {
  untyped __js__("var OnePageNav = window.jQuery");

	//untyped __js__("scrollEventEx = OnePageNav.scrollEvent");
	//untyped __js__("OnePageNav.scrollEvent={event:'pop',data:'kilo'};");
//	untyped __js__('DraggableMethods = { destroy : "destroy", enable : "enable", disable : "disable" };');
//   untyped __js__('OnePageNavEvent={create:"create",start:"dragstart",drag:"drag",stop:"dragstop"}');
}


	
	public function onePageNav(?option:OnePageNavOptions):OnePageNav; 
	/*public function test():String;
		public function adjustNav() : Void ;
		public function getPositions() : Void ;
		
	//	public function scrollChange(): Void; //event?*/
	public inline function getSection(windowPos:Int) : Int  {return 						untyped(this.FonePageNav.getSection(windowPos));}
	}
	
	
