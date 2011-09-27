package jquery.nav;

import js.JQuery;

typedef SerialScrollOptions =
{
	var duration:Int;//1000, // how long to animate.
	var axis:String;//'x', // which of top and left should be scrolled
	var event:String;//'click', // on which event to react.
	var start:Int;//0, // first element (zero-based index)
	var step:Int;//1, // how many elements to scroll on each action
	var lock:Bool;//true,// ignore events if already animating
	var cycle:Bool;//true, // cycle endlessly ( constant velocity )
	var constant:Bool;//true // use contant speed ?
	
	var navigation:String;//null,// if specified, it's a selector a collection of items to navigate the container
	var target:String;//window, // if specified, it's a selector to the element to be scrolled.
	var interval:Int;//0, // it's the number of milliseconds to automatically go to the next
	var lazy:Bool;//false,// go find the elements each time (allows AJAX or JS content, or reordering)
	var stop:Bool;//false, // stop any previous animations to avoid queueing
	var force:Bool;//false,// force the scroll to the first element on start ?
	var jump:Bool;// false,// if true, when the event is triggered on an element, the pane scrolls to it
	var items:String;//null, // selector to the items (relative to the matched elements)
	var prev:String;//null, // selector to the 'prev' button
	var next:String;//null, // selector to the 'next' button
	var onBefore:JqEvent->Void;// function(){}, // function called before scrolling, if it returns false, the event is ignored
	var exclude:Int;//0 // exclude the last x elements, so we cannot scroll past the end
}

#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end

extern class SerialScroll extends JQuery {
	
	
	public static function __init__():Void {
  untyped __js__("var SerialScroll = window.jQuery");
	}
	public function serialScroll(?option:SerialScrollOptions) :SerialScroll;
	
}