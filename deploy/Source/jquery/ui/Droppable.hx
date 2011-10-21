package jquery.ui ;
import js.JQuery;


/*//fakeEnum ne marche pas ...
extern enum DraggableMethods
{
	destroy;
	enable;
	disable;
	
}
*/




typedef DroppableOptions =
{
	 	var hoverClass:String;
		var accept:Dynamic;  //selector function
		var disabled:Bool;
		var drop:JqEvent->Void;
}

#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end


extern class Droppable extends JQuery
{
	public static function __init__():Void {
        untyped __js__("var Droppable = window.jQuery");
	//	untyped __js__('DraggableMethods = { destroy : "destroy", enable : "enable", disable : "disable" };');
   // untyped __js__('DraggableEvent={create:"create",start:"dragstart",drag:"drag",stop:"dragstop"}');
}
		//public function pajinate(?options:Poption):JQuery;
		public function droppable(options:DroppableOptions):JQuery; 
	
}