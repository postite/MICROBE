package monjs;
import js.JQuery;
import js.Lib;
//import monjs.TestExtern;
import Paginate;
using microbe.tools.Debug;

class JPagination 
{
	static var debug:Bool=true;
public function new(cssId:String) : Void {
	//new JQuery("#leftCol").append("<div class='pop'>pop<div>");
var liste=new Paginate(".itemslist");
	//Std.string(liste).Alerte();
//untyped __js__(liste.reverseText());
//untyped __js__("$('#leftCol ul li').reverseText()");
var option:Poption=cast {};
/*option.item_container_id=".itemslist";
option.items_per_page=3;
option.nav_panel_id=".pop";*/
option.perPage=2;

liste.sweetPages(option);
new JQuery('.itemslist').css("overflow","hidden");
new JQuery('.itemslist').css("width","110");

var controls = new JQuery('.swControls');//.detach();

controls.appendTo('#leftCol');

/*option.width=300;
option.height=300;
liste.wslide(option);*/

	//liste.boum();
}
    
}