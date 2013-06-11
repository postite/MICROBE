package microbe.notification;
import javascriptOutils.Layout;
import js.JQuery;
import js.Lib;

enum NoteType
{
	alerte;
	message;
	erreur;
	
}
class Note

{
	public var _text:String;
	public var box:String;
	var jBox:JQuery;
	var noteType:NoteType;
	var color:String;
	
	function getType() : String {
		switch ( noteType )
		{
			case alerte:
				color="#0af";
			case message:
				color="#33cc33";
			case erreur:
				color="#cc3300";
		}
		return color;
	}
	
	public function new(?texte:String,type:NoteType)
	{
			noteType=type;
		if( texte !=null)text(texte);
	
	}
	private  function createBox():JQuery{
		
		var _box:String= "<div class='note'>"+_text+"</div>";
		box=_box;
		var winPos =new JQuery(Lib.window).scrollTop();
		jBox= new JQuery(box);
		jBox.css("position","absolute");
		jBox.css("background-color",getType());
		jBox.css("width","400px");
		jBox.css("right","-400px");
		jBox.css("top",winPos+400+"px");
		jBox.css("font-size","33px");
		jBox.css("display","block");
		return jBox;
	}
	
	public function text(val:String){
		_text=val;
		createBox();
	}
	
	public function execute() : Void {
		//Lib.alert("execute" +box);
		new JQuery("body").append(jBox);
		jBox.animate({right:0}, 300, onNote);
	//	Lib.alert("after execute");
	}
	
	function onNote() : Void {
	//	Lib.alert("animated");
		new JQuery("body").animate({top:0},3000,onDone);
	}
	function onDone() : Void {
	//	Lib.alert("OnDone");
		jBox.animate({right:-400}, 300,finsished);
		
	}
	function finsished():Void 
	{
		jBox.remove();
	}

	
}

