package monjs;
import haxe.remoting.ExternalConnection;
import haxe.Http;
import js.JQuery;
import js.Lib;
import js.SWFObject;
using microbe.tools.Debug;
class FrontJs
{
	static var instance:FrontJs;
	static var debug:Bool=true;
	var cnx:ExternalConnection;
	
	//htmlname for swf used in SWFObject & remoting
	var swfName:String;
	public function new()
	{	
		new JQuery("document").ready(init);

	}
	
	public static function main() : Void {
		instance=new FrontJs();
		/*Créez une nouvelle instance de la classe Context*/
		//new FrontJs();
	}
	function embedSWF() : Void {
			swfName="monswf";
			var swf= new SWFObject("/swf/melle.swf",swfName,960,540,"10","#ffffff");
		//	swf.addParam("allowScriptAccess","always"); // apaprement pas besoin de le mettre 
			swf.write("flasheader");
			trace("embeded");
	}
	
	function initConnection() : Void {
		var context = new haxe.remoting.Context();
		context.addObject("api",this); 
		cnx = ExternalConnection.flashConnect("api",swfName,context);
	}
	public function test(str:String) : String {
	//	Lib.alert("fromjs"+str);
	return "fromFrontJS"+str;
	}
	
	////////function appelées par Flash////////
	public function flashNav(voName:String) : Void {
	//	Lib.alert("vo="+voName);
		navigue(voName);
	}
	
	
	///////////////////////////////////////////
	
	
	public static function testTag(e){
		
		var tag=new JQuery(e.currentTarget).text();
		navByTag("blog",tag);
		
	}
	
	
	public function expand(e:JqEvent){
	Lib.alert("click"+e.target);
	Lib.alert(	new JQuery(cast(e.currentTarget)).attr("id"));
	
	}
	public function init(e:JqEvent){
		"init".Alerte();
		embedSWF();
		initConnection();
		Coupon.ONBUY.add(onBuy);
	//	new JQuery(".spod").click(expand);
	}
	public static function request(voName:String,?id:Int,?element:String) : Void {
	//	Lib.alert("reponse"+"http://127.0.0.1/index.php/myfront/h/"+voName+"/"+id);
	//	var reponse = Http.requestUrl("http://localhost:8888/index.php/myfront/h/"+voName+"/"+id);
		var r = new haxe.Http("http://localhost:8888/index.php/myfront/h/"+voName+"/"+id);
		    r.onError = js.Lib.alert;
		    r.onData = function(r) { changerContenu("contenu",r); }
		    r.request(false);
		//var uno=haxe.Unserializer.run(reponse);
	//	Lib.alert("pif="+uno);
		//changerContenu('panel', reponse);
	}
	static function nav(voName:String):Void{
		//Lib.alert("nav="+voName);
		request(voName,1,"contenu");
	}
	
	function onBuy(s:String) : Void {
		cnx.api.goto.call(["commande"]);
		var r=new haxe.Http("http://localhost:8888/index.php/myfront/loadCommande/"+ haxe.Serializer.run(Coupon.instance.liste)+"/"+Coupon.instance.total);
		 r.onError = js.Lib.alert;
		 r.onData = function(r) { changerContenu("contenu",r); }
		 r.request(false);
		Coupon.instance.reInit();
		//make call to SWF
		
	}
	
	
	static function navigue(voName:String,?tag:String) : Void {
		var r = new haxe.Http("http://localhost:8888/index.php/myfront/contenu/"+voName+"/"+tag);
		    r.onError = js.Lib.alert;
		    r.onData = function(r) { changerContenu("contenu",r);}
		    r.request(false);
	}
	
	static function navByTag(voName:String,tag){
		
	navigue(voName,tag);
	
	}
	static function side(voName:String):Void{
			var r = new haxe.Http("http://localhost:8888/index.php/myfront/side/"+voName);
			    r.onError = js.Lib.alert;
			    r.onData = function(r) { changerContenu("side",r);}
			    r.request(false);
	}
	static function changerContenu(idElement,contenu)
	      		{
					//Lib.alert("changerContenu"+contenu);
					//var yo=haxe.Unserializer.run(contenu);
					//Lib.alert("yo="+yo);
	new JQuery("#"+idElement).css("opacity","0");				
	var element = new JQuery("#"+idElement).html(contenu);
	new JQuery("#"+idElement).animate({opacity:1},500);
	      		   // if(element == null) Lib.alert('Element inconnu : '+idElement);
	      		   // element.innerHTML = contenu;

	      		}
	public function mail(elId:String,Sid:String,Mid:String):Void{
				Lib.alert("mail");
				var contenu:String=new JQuery("#"+elId).html();
				var sign= new JQuery('#'+Sid).val();
				var courriel= new JQuery('#'+Mid).val();
				contenu+="<p>"+sign+"</p><p>"+courriel+"</p>";
				//var Xcontenu = haxe.Serializer.run(StringTools.urlEncode(contenu));
				var r = new haxe.Http("http://localhost:8888/index.php/myfront/mail/");
				r.setParameter("contenu", contenu);
				r.setParameter("signature", sign);
				r.setParameter("courriel", courriel);
			    r.onError = js.Lib.alert;
			    r.onData = function(r) { Lib.alert("frap"+r);}
			    r.request(true);
	}
}