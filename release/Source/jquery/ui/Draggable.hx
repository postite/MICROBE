package jquery.ui ;
import js.JQuery;


//fakeEnum ne marche pas ...
extern enum DraggableMethods
{
	destroy;
	enable;
	disable;
	
}
extern enum DraggableEvent{
create;
start;
drag;
stop;
}


typedef DraggableOptions =
{
	var addClasses:Bool;// default:true,
	var appendTo:String;// "parent", selector
	var axis:String; //x,y Default:false,
	var connectToSortable:String;// false,selector
	var containment:Dynamic;// Element, String, Array Default:false
	var cursor:String;// "auto",
	var cursorAt:Bool; //false,
	var grid:Bool;// false,
	var handle:Bool;// false,
	var helper:String;// "original",
	var iframeFix:Bool;// false,
	var opacity:Float;// false,
	var refreshPositions:Bool;// false,
	var revert:Bool;// false,
	var revertDuration:Float;// 500,
	var scope:String;// "default",
	var scroll:Bool;// true,
	var scrollSensitivity:Float;// 20,
	var scrollSpeed:Float;// 20,
	var snap:Bool;// false,
	var snapMode:String;// "both",
	var snapTolerance:Float;// 20,
	var stack:Bool;// false,
	var zIndex:Bool;// false
}


#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end


extern class Draggable extends JQuery
{
	public static function __init__():Void {
        untyped __js__("var Draggable = window.jQuery");
		untyped __js__('DraggableMethods = { destroy : "destroy", enable : "enable", disable : "disable" };');
    untyped __js__('DraggableEvent={create:"create",start:"dragstart",drag:"drag",stop:"dragstop"}');
}
		//public function pajinate(?options:Poption):JQuery;
		@:overload(function(methode:DraggableMethods,?opt:Dynamic):Draggable{})
		public function draggable(?option:DraggableOptions):Draggable; 
	
	
	
	
	
	//public function draggable(option:Dynamic):JQuery ;
		//public function destroy():JQuery;
}