package javascriptOutils;

import js.JQuery;
//require JQuery.js
class Layout 
{

	public function new()
	{
		
	}
	
	public static function getWindow() : JQuery {
		return cast untyped __js__("$(window)");
	}
public static function getDoc() : JQuery {
		return cast untyped __js__("$(document)");
	}
	
public	static function scrollPercentage(?viewableAreaHeight) : Float {
	var viewable_area:Float=getWindow().height();
	var total_height:Float;
		var scroll_top = getWindow().scrollTop();
	//	var   total_height = getDoc().height();//$w.find(".content").height(),        
		 //var   total_height = new JQuery("").height();    
		if(viewableAreaHeight != null ){
			total_height=viewableAreaHeight;
		}else{
		 total_height =getDoc().height();
		}
		 var  scroll_percent = (scroll_top / (total_height-viewable_area)) ;
		//return untyped __js__("((document.documentElement.scrollTop + document.body.scrollTop) / (document.documentElement.scrollHeight - document.documentElement.clientHeight) * 100)");
		return scroll_percent;
	}
	/*public static function scrollPercentageRelatif(viewableArea):FLoat{
			scrollPercentage(getWindow(scrollTop))
			
		}*/
}