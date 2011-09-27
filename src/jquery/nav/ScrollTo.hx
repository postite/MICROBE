package jquery.nav;
import js.JQuery;

typedef ScrollToSettings =
{
	var axis:String ;//Axes to be scrolled, 'x', 'y', 'xy' or 'yx'. 'xy' is the default.
	var duration:Int;//Length of the animation, none (sync) by default.
	var easing:String;//Name of the easing equation.
	var margin:Bool;//If true, target's border and margin are deducted.
	var offset:Dynamic;//Number or hash {left: x, top:y }. This will be added to the final position(can be negative).
	var over:Float;//Add a fraction of the element's height/width (can also be negative).
	var queue:Bool;//If true and both axes are scrolled, it will animate on one axis, and then on the other. Note that 'axis' being 'xy' or 'yx', concludes the order
	
	var onAfterFirst:JqEvent->Void; //If queing, a function to be called after scrolling the first axis.
	var	onAfter:JqEvent->Void;//A function to be called after the whole animation ended.
}


/*There are many different ways to specify the target position.
These are:
A raw number
A string('44', '100px', '+=30px', etc )
A DOM element (logically, child of the scrollable element)
A selector, that will be relative to the scrollable element
The string 'max' to scroll to the end.
A string specifying a percentage to scroll to that part of the container (f.e: 50% goes to to the middle).
A hash { top:x, left:y }, x and y can be any kind of number/string like above.*/

#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end

extern class ScrollTo extends JQuery{
	
	
	public static function __init__():Void {
  untyped __js__("var ScrollTo = window.jQuery");
	}
	
	public function scrollTo(target:Dynamic, duration:Float, ?settings:ScrollToSettings) : ScrollTo ;
	
	
	
	
	
	
	
}
