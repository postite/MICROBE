package jquery.nav;

import js.JQuery;
typedef Selector =String

typedef TimeSliderOptions =
{
		var orientation: String;//			'horizontal',		// value: horizontal | vertical, default to horizontal
		var containerDiv:Selector;// 				'#timeline',		// value: any HTML tag or #id, default to #timeline
		var datesDiv:String;// 					'#dates',			// value: any HTML tag or #id, default to #dates
		var datesSelectedClass:String;// 		'selected',			// value: any class, default to selected
		var datesSpeed: Int;//				500,				// value: integer between 100 and 1000 (recommended), default to 500 (normal)
		var issuesDiv: Selector;//					'#issues',			// value: any HTML tag or #id, default to #issues
		var issuesSelectedClass:String;// 		'selected',			// value: any class, default to selected
		var issuesSpeed: 	Int;//			200,				// value: integer between 100 and 1000 (recommended), default to 200 (fast)
		var issuesTransparency:Float;// 		0.2,				// value: integer between 0 and 1 (recommended), default to 0.2
		var issuesTransparencySpeed:Int;// 	500,				// value: integer between 100 and 1000 (recommended), default to 500 (normal)
		var prevButton: Selector;//				'#prev',			// value: any HTML tag or #id, default to #prev
		var nextButton: Selector;//				'#next',			// value: any HTML tag or #id, default to #next
		var arrowKeys:Bool;// 					'false',			// value: true | false, default to false
		var startAt: 		Int;//			1,					// value: integer, default to 1 (first)
		var autoPlay: Bool;//					'false',			// value: true | false, default to false
		var autoPlayDirection:String;// 			'forward',			// value: forward | backward, default to forward
		var autoPlayPause: Int;//				2000				// value: integer (1000 = 1 seg), default to 2000
}

#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end

extern class TimeSlider extends JQuery
{

	public static function __init__():Void {
  untyped __js__("var TimeSlider = window.jQuery");
	}
	public function timelinr(?option:TimeSliderOptions) :TimeSlider;
	function autoPlay() : Void ;
		
	
}