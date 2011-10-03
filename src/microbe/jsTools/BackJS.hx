package microbe.jsTools;
import microbe.form.AjaxElement;
import microbe.form.Microfield;
import microbe.form.MicroFieldList;
import microbe.ClassMap;
import microbe.jsTools.ElementBinder;
using microbe.tools.Debug;
import js.JQuery;
import js.Lib;
import jquery.ui.Sortable;


import microbe.form.elements.TagView;
import microbe.form.elements.CollectionElement;
import microbe.form.elements.CollectionWrapper;
import microbe.form.elements.DeleteButton;
import microbe.form.elements.PlusCollectionButton;

class BackJS
{
	
	public static var debug=1;
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
	
	
	var sort:Sortable;
	
	public static function main() : Void {
		//à voir avec cette histoire de Singleton
		instance=new BackJS();
	}
	//getter for singleton
	public static function getInstance() : BackJS {
	//	"".Alerte();
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
	//	"init".Alerte();
		start();
	}
	public function start():Void{
		//c'est moche
	Std.string(classMap).Alerte();
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
		
		//"beforeparse".Alerte();
		parser.parse(classMap);
	//	"afterparse".Alerte();
		var wrapper= new CollectionWrapper(); /// added dans la new version plus
		CollectionWrapper.sign.add(PlusCollection);
		var sortoptions:SortableOptions= cast {};
		//sortoptions.grid=[20,50];
		sortoptions.placeholder="placeHolder";
		sortoptions.opacity=.2;
		
		//sortoptions.deactivate=ondeactivate;
		sortoptions.update=onSortChanged;
		
		sort=new Sortable("#leftCol .itemslist").sortable(sortoptions);
		
		listen();
	}
	
	public function onSortChanged(e:JqEvent,ui:UI):Void{
		var pop=sort.sortSerialize({attribute:'tri',key:'id'});
		trace(pop);
		var liste:Array<String>=pop.split("&id=");
		 liste[0]=liste[0].split("id=")[1];
		
		//Lib.alert(pop);
		//sort.disable();
		var req= new haxe.Http(back_url+"reorder/"+this.currentVo);
	//	req.setParameter("voName", voName);
		req.setParameter("orderedList",haxe.Serializer.run(liste));
		req.onData=function(d) { trace(d);}; 
		req.request(true);
		trace("afterreorder");
	}
	///appelé en static 
	public function setClassMap(compressedMap:String){
	//	trace("setClassMAp");
	//	compressedMap.Alerte();
		classMap=haxe.Unserializer.run(compressedMap);
	//	"".Alerte();
		//Lib.alert("hello" +classMap);
	}
	
	//ecoute les evenements des Elements statiques
	function listen() : Void {
		
		CollectionElement.deleteSignal.add(deleteCollection); //core
		DeleteButton.sign.add(deleteSpod); //core
		new JQuery(".ajout").click(onAjoute);
	/*if(PlusCollectionButton.sign !=null)
			PlusCollectionButton.sign.add(PlusCollection);
			*/
		}
	
	function onAjoute(e:JqEvent):Void{
		"ajoute".Alerte();
	//	trace("yo");
		Lib.window.location.href=back_url+"ajoute/"+currentVo;
	}

	///utilisé par bouton delete
	function deleteSpod():Void{
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
	//	back_url.Alerte();
		trace("classMAp="+classMap +"back_url="+back_url);
		var req= new haxe.Http(back_url+"rec/");
	//	req.setParameter("voName", voName);
		req.setParameter("map", compressedValues);
		req.onData=function(d) { afterRecord(d);}; 
		req.request(true);
	}
	function afterRecord(d) : Void {
		trace("Fter Record");
		//Lib.window.location.href=back_url+"nav/"+classMap.voClass+"/"+classMap.id;
	}
	
	
	
	function deleteCollection(id:String,voName:String,pos:Int) : Void {
	//	"".Alerte();
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
	public function PlusCollection(collectionVoName:String/*PLUSCollectionBUTTON*/){
		
	/*	"".Alerte();
			var maputil= new ClassMapUtils(classMap);
			var currentCollec=maputil.searchCollec(collectionVoName);
			var mock:MicroFieldList=cast currentCollec.first();
			parseplusCollec(mock,10);*/
				var req= new haxe.Http(back_url+"addCollectItem/");
			//	req.setParameter("voName", voName);
		//	voName:String,voParent:String,voParentId:Int
				req.setParameter("voName", collectionVoName);
				req.setParameter("voParent", classMap.voClass);
				req.setParameter("voParentId", Std.string(classMap.id));
				req.onData=function(x) {onAddItemPlus(x); }; 
				req.request(true);
			
	}
	function onAddItemPlus(x:String) : Void {
		Std.string(x).Alerte();
		var d:MicroFieldList=haxe.Unserializer.run(x);
		Std.string(d).Alerte();
	}
	
	
	function parseplusCollec(liste:MicroFieldList,pos:Int) : Void {
	//	"".Alerte();
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
		
		
		
		microbeElements.createCollectionElement(microChamps,liste.pos);
		var maputil= new ClassMapUtils(classMap);
		maputil.searchCollec(liste.voName);
		maputil.addInCollec(liste);
		classMap.fields=maputil.mapFields;
		

	}


	
}