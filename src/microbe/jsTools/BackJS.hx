package microbe.jsTools;
import microbe.form.AjaxElement;
import microbe.form.Microfield;
import microbe.form.MicroFieldList;
import microbe.ClassMap;
import microbe.jsTools.ElementBinder;
using microbe.tools.Debug;
import js.JQuery;
import js.Lib;


import microbe.form.elements.TagView;
import microbe.form.elements.CollectionElement;
import microbe.form.elements.DeleteButton;
import microbe.form.elements.PlusCollectionButton;

class BackJS
{
	
	public static var debug=0;
	//singleton instance
	public static var instance(getInstance,null):BackJS;
	
	//config
	public var base_url:String;
	public var back_url:String;
	
	//position
	public var currentVo:String;
	public var classMap:ClassMap;
	
	//model
	public var microbeElements:ElementBinder;
	public static function main() : Void {
		//à voir avec cette histoire de Singleton
		instance=new BackJS();
	}
	//getter for singleton
	public static function getInstance() : BackJS {
		"".Alerte();
		if( instance==null){
			instance= new BackJS();
		}
		return instance;
	}
	
	//constriucteur
	private function new()
	{
	"new".Alerte();
	base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
	back_url=base_url+"/index.php/pipo/"; //TODO replace pipo par config
	
	new JQuery("document").ready(function(e):Void{instance.init();});
	}
	
	//initialisation du Dom
	function init() : Void {
		"init".Alerte();
		start();
	}
	public function start():Void{
		//c'est moche
		"".Alerte();
		new JQuery("#"+classMap.submit).click(function(e):Void{instance.record();});
		
	//	parseMap();
		currentVo=classMap.voClass;
		
		////binding des tags
		
		if (classMap.fields.taggable==true){
			new TagView(classMap.fields);
		}
		
		microbeElements=new ElementBinder();
		var deleteBouton= new DeleteButton(classMap.voClass+"_form_effacer");
		var parser=new MapParser(microbeElements);
		parser.parse(classMap);
		listen();
	}
	
	
	///appelé en static 
	public function setClassMap(compressedMap:String){
	//	trace("setClassMAp");
		"".Alerte();
		classMap=haxe.Unserializer.run(compressedMap);
		//Lib.alert("hello" +classMap);
	}
	
	//ecoute les evenements des Elements statiques
	function listen() : Void {
		
		CollectionElement.deleteSignal.add(deleteCollection); //core
		DeleteButton.sign.add(deleteSpod); //core
		new JQuery(".ajout").click(onAjoute);
		if(PlusCollectionButton.sign !=null)
		PlusCollectionButton.sign.add(PlusCollection);
		
	}
	
	function onAjoute(e:JqEvent):Void{
		"ajoute".Alerte();
		trace("yo");
		Lib.window.location.href=back_url+"ajoute/"+currentVo;
	}

	///utilisé par bouton delete
	function deleteSpod() : Void {
		"sur?".Alerte();
	//Lib.window.location.href="http://localhost:8888/index.php/myback/delete/"+classMap.voClass+"/"+classMap.id;
		Lib.window.location.href=back_url+"delete/"+classMap.voClass+"/"+classMap.id;
	}
	
	/// autre comportement .. utilisé par deletecollection
	function spodDelete(voName:String,id:Int) : Void {
		"".Alerte();
		var reponse=haxe.Http.requestUrl(back_url+"delete/"+voName+"/"+id);
	//	Lib.alert("reponse="+reponse);
	}
	
	
	///appelé par bouton enregistrer
   public function record(){
   	trace("clika"+microbeElements);
   	
   	for( mic in microbeElements){
		//	mic.getValue().Alerte();
			trace("micVAlue="+mic.getValue());
   		mic.microfield.value= mic.getValue();
   	}
		AjaxFormTraitement();
		trace("finrecord");
   }

   	//utilisé à l'enregistrement
	public function AjaxFormTraitement(){
		Std.string(classMap).Alerte();
		
		var compressedValues=haxe.Serializer.run(classMap);
		back_url.Alerte();
		trace("classMAp="+classMap +"back_url="+back_url);
		var req= new haxe.Http(back_url+"rec/");
	//	req.setParameter("voName", voName);
		req.setParameter("map", compressedValues);
		req.onData=function(d) { trace("onDataAjaxForm" + d);}; 
		req.request(true);
	}
	
	
	function deleteCollection(id:String,voName:String,pos:Int) : Void {
		"".Alerte();
		//Lib.alert("popSignal"+id +"voName="+voName);
		var maputil= new ClassMapUtils(classMap);
		maputil.searchCollec(voName);
		var microListe=maputil.searchinCollecByPos(pos);
		var spodid=microListe.id;
		maputil.removeInCurrent(microListe);
		//maputil.addInCollec(liste);
		new JQuery("#"+id).fadeOut(1000, function ():Void{new JQuery("#"+id).remove();});
		//Lib.alert("afterdelete"+classMap);
		spodDelete(voName,spodid);
	//	Lib.alert("afterdeleteId"+id);
		//new JQuery("#"+id).remove();
	}
	
	
	
	///attention faut revoir ça c'est trop complexe
	//attention bordel le trucdu pithecantrope , va vraiment falloir trouver autre chose.
	public function PlusCollection(transport:Transport/*PLUSCollectionBUTTON*/){
		"".Alerte();
		//var transport:Transport =cast haxe.Unserializer.run(xtransport);
		//**var unelement=haxe.Unserializer.run(compressedelement);
		var unelement=transport.data;
	    //Lib.alert("pluscollection"+unelement);
		unelement.Alerte();
		
			var lastpos=new JQuery(".collection").last().attr("pos");	
			var posint=Std.parseFloat(lastpos);
			posint++;
				var str = unelement;
			   	var r = ~/(pitecanthrope)/g; // g : replace all instances
				var element=r.replace(str,Std.string(posint)); // "aaabcbcbcxx"
			//var unCollec:MicroFieldList=haxe.Unserializer.run(collec);
			//Lib.alert("type="+unCollec.type);
			
			new JQuery(".collection").last().after(element);
		//new JQuery(".collectionWrapper").insertAfter(element,new JQuery(".collection").last());	
			//	var unliste:MicroFieldList=haxe.Unserializer.run(liste);
			var liste=transport.collec;
			//var xposint=haxe.Serializer.run(posint);
			//var posliste=r.replace(liste,xposint); // "aaabcbcbcxx"
			//trace("posliste="+posliste);
			//var unliste:MicroFieldList=haxe.Unserializer.run(liste);
			parseplusCollec(cast liste,Std.int(posint));
			//trace("liste="+cast(unliste.first(),Microfield).elementId);
			"liste="+liste.toString().Alerte();
			//new JQuery(".collection").last().clone().insertAfter(new JQuery(".collection").last());
	}
	
	function parseplusCollec(liste:MicroFieldList,pos:Int) : Void {
		"".Alerte();
		//trace("before");
		liste.pos=pos;
		var r = ~/(pitecanthrope)/g; // g : replace all instances
	 // "aaabcbcbcxx"
		for(microfield in liste){
			var element=r.replace(cast(microfield,Microfield).elementId,Std.string(pos));
			cast(microfield,Microfield).elementId=element;
			microbeElements.createElement(cast microfield);
			
		}
		var microChamps:Microfield=new Microfield();//cast chps;
		microChamps.elementId=liste.elementId;
		microChamps.field=liste.field;
		microChamps.value=null;
		microChamps.element="microbe.form.elements.CollectionElement";
		
		
		
		microbeElements.createCollectionWrapper(microChamps,liste.pos);
		var maputil= new ClassMapUtils(classMap);
		maputil.searchCollec(liste.voName);
		maputil.addInCollec(liste);
		classMap.fields=maputil.mapFields;
		

	}


	
}