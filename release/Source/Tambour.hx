package;
import jquery.nav.OnePageNav;
import jquery.nav.ScrollTo;
import jquery.image.LightBox;
import jquery.nav.TimeSlider;
import js.JQuery;

import javascriptOutils.Layout;

class Tambour  {
	
	var nav:OnePageNav;
	var scrollSettings:ScrollToSettings;
	var bandScroller:ScrollTo;
	var bandoWidth:Int;
	var gallery:LightBox;
	
	static var bandocoords:Array<Float>=[600.0,1200.0,1800.0];
	
	public function new(){
		trace("hello");
		init();
		initNavPage();
		initBando();
		initGallery();
		initGallerySimple();
		var timeOpt:TimeSliderOptions= cast {};
		timeOpt.containerDiv=".newsblock";
		new TimeSlider("window").timelinr(timeOpt);
		trace("after");
	}
	
	function init() : Void {
		new JQuery(Layout.getWindow()).resize(onResize);
	}
	function onResize(e:JqEvent) : Void {
	//	trace("onResize");
		initBando();
	}


	function initGallery() : Void {
		
		
		var Gatelier= new LightBox("#ateliergallery .lightbox");
		var Gdeambulation= new LightBox("#deambulationgallery .lightbox");
		var Gvegetal= new LightBox("#vegetalgallery .lightbox");
		
		var lightOpt:LightBoxOptions= cast {};
		var lightStrings:LightBoxStringsOptions=cast {};
		lightStrings.closeTitle="fermer";
		lightStrings.prevLinkText="precedent";
		lightStrings.nextLinkText="suivant";
		lightOpt.fileBottomNavCloseImage="/assets/lightbox/closelabel.gif";
		lightOpt.fileLoadingImage="/assets/lightbox/loading.gif";
		lightOpt.slideNavBar=false;
		lightOpt.allSet=true;
		lightOpt.strings=lightStrings;
		
		Gatelier.lightbox(lightOpt);
		Gdeambulation.lightbox(lightOpt);
		Gvegetal.lightbox(lightOpt);
		
		
		
		var atelier= new Slider("#ateliergallery");
		var deambulation= new Slider("#deambulationgallery");
		var vegetal= new Slider("#vegetalgallery");
		
	}
	
	function initGallerySimple() : Void {
		gallery= new LightBox(".lightbox_simple");
		var lightOpt:LightBoxOptions= cast {};
		var lightStrings:LightBoxStringsOptions=cast {};
		lightStrings.closeTitle="fermer";
	
		
		lightOpt.allSet=false;
		lightOpt.strings=lightStrings;
		gallery.lightbox(lightOpt);
		
		//var slide= new Slider("#gallery");
		
	}
	
	
	function initBando() : Void {
		trace("initBandeau"+Layout.getWindow().width());
		///new JQuery("#bando").css("overflow","hidden");
		new JQuery("#bando").css("width",Std.string(Layout.getWindow().width()+"px"));
		//new JQuery("#bando #soubando").css("width",Std.string(getWindow().width()+"px"));
	 	//new JQuery("#bando").css("width","800px");
	/*	scrollSettings= cast {};
			scrollSettings.axis="x";
			scrollSettings.duration=300;*/
		//bandScroller=new ScrollTo("#bando");
		//bandScroller.scrollTo(100, 300, scrollSettings);
		
	}
		
	function initNavPage() : Void {
		nav= new OnePageNav("#nav");
			var navOptions:OnePageNavOptions= cast {};
			navOptions.currentClass="currentNavItem";
			navOptions.changeHash=false;
			nav.onePageNav(navOptions);
			//nav.bind(OnePageNav.adjust, onAdjustScroll);
			//nav.bind(OnePageNav.scrollChange,onScroll);
			Layout.getWindow().scroll(onScroll);
			trace("afterOnePAge");
	}
	function onScroll(e:JqEvent) : Void {
		var ratio=Layout.scrollPercentage();
	//	trace("ratio="+ratio);
		var imgWidth=new JQuery("#bando img").width();
		var modif:Float=(imgWidth-Layout.getWindow().width())*ratio;
		//trace("madif="+modif +"& imgWidth="+imgWidth);
		new JQuery("#bando img").css("left",-modif+("px"));
	}
	

	
function onAdjustScroll(e:JqEvent,data:Dynamic) : Void {
	trace("scroll"+Layout.getWindow().scrollTop());
	//var ratio:Float=(getWindow().scrollTop()+getWindow().height())/getDoc().height();
	var ratio=Layout.scrollPercentage();
	trace("ratio="+ratio);
	var imgWidth=new JQuery("#bando img").width();
	trace("imgW="+imgWidth);
	var section:Int=Std.parseInt(Lambda.list(data.split("section-")).last())-1;
	//trace(Std.string(nav.FonePageNav.sections) + " was the volue for section "); 
	var pos:Float=bandocoords[section];
	trace("pos="+pos);
//	new JQuery("#bando").unbind()
	//bandScroller.scrollTo(pos,scrollSettings.duration,scrollSettings);
	//var ratio = (getDoc().height()/getWindow().height())*new JQuery("#bando img").height();
	var modif:Float=(imgWidth-Layout.getWindow().width())*ratio;
	trace("modif="+modif);
	new JQuery("#bando img").css("left",-modif+("px"));
	trace("after");
	//bandScroller.scrollTo(600,300,scrollSettings);
}

	public static function main(){
		new Tambour();
	}
}