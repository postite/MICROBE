package microbe.jsTools;
import microbe.form.AjaxElement;
import microbe.form.Microfield;
import microbe.form.MicroFieldList;
import microbe.ClassMap;
import microbe.jsTools.ElementBinder;
using microbe.tools.Debug;
import microbe.notification.Note;
import js.JQuery;
import js.Lib;
import postite.jquery.ui.Sortable;
import microbe.macroUtils.Imports;
import microbe.form.elements.TagView;
import microbe.form.elements.CollectionElement;
import microbe.form.elements.CollectionWrapper;
import microbe.form.elements.DeleteButton;
import microbe.form.elements.PlusCollectionButton;

#if elements 
import microbe.ImportHelper;
#else
  #error "add imports in microbe.ImportHelper.hx and compile with -D elements"
#end

@:expose("microbe.jsTools.BackJS")
class BackJS
{
	
	public static var debug=1;
	//singleton instance
	public static var instance(getInstance,null):BackJS;
	
	//config
	//public static var base_url:String=MicrobeConfig.siteRoot;
	public static var base_url:String=Lib.window.location.protocol+"//"+Lib.window.location.host;
	public static var back_url:String=base_url+"/index.php/pipo/";
	
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
	

	//taken from element Binder to allow lightJSBAck
	
	microbe.tools.Mytrace.setRedirection();

	Imports.pack("microbe.form.elements",false);
	//base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
	//back_url=base_url+"/index.php/pipo/"; //TODO replace pipo par config
	new JQuery("document").ready(function(e):Void{instance.init();});
	}
	
	//initialisation du Dom
	function init() : Void {
	//	"init".Alerte();
		start();
	}
	
	public function start():Void{
		//c'est moche
		if( classMap!=null){
		//Std.string(classMap.submit).Alerte();
		new JQuery("#"+classMap.submit).click(function(e):Void{instance.record();});
		
	//	parseMap();
		currentVo=classMap.voClass;
		
		////binding des tags
		
		if (classMap.fields.taggable==true){
			
			//mettre une condition si pas de Tag

			new TagView(classMap.fields);
			
		}
	
		//"".Alerte();
		
		microbeElements=new ElementBinder();
		//"".Alerte();
		var deleteBouton= new DeleteButton(classMap.voClass+"_form_effacer");
		var parser=new MapParser(microbeElements);
		
		//"beforeparse".Alerte();
		parser.parse(classMap);
		//"afterparse".Alerte();
		var wrapper= new CollectionWrapper(); /// added dans la new version plus
		CollectionWrapper.plusInfos.add(PlusCollection);
		var sortoptions:SortableOptions= cast {};
		//sortoptions.grid=[20,50];
		sortoptions.placeholder="placeHolder";
		sortoptions.opacity=.2;
		
		//sortoptions.deactivate=ondeactivate;
		sortoptions.update=onSortChanged;
		
		sort=new Sortable("#leftCol .itemslist").sortable(sortoptions);
		//var note= new Note("hello",alerte);
		//note.execute();
		listen();
		//"endStart".Alerte();
	}
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
		//"".Alerte();
		//Lib.alert("hello" +classMap);
	}
	
	//ecoute les evenements des Elements statiques
	function listen() : Void {
		"listen".Alerte();
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
		
		if(mic.element!=null){
   		mic.microfield.value= mic.getValue();
   		}
   		//Lib.alert("mic="+mic.microfield.value);
   	}

		AjaxFormTraitement();
		trace("finrecord");
   }

   	//utilisé à l'enregistrement
	public function AjaxFormTraitement(){
		Std.string(classMap).Alerte();
		trace("classMAp="+classMap);
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
		Lib.window.location.href=back_url+"nav/"+classMap.voClass+"/"+classMap.id;
	}
	
	
	
	function deleteCollection(id:String,voName:String,pos:Int,collecItemId) : Void {
	//	"".Alerte();
		//Lib.alert("popSignal"+id +"voName="+voName);
		var maputil= new ClassMapUtils(classMap);
	//	Lib.alert("coolec="+);
	maputil.searchCollec(voName);
	//	Lib.alert("maputil"+classMap);
		var microListe=maputil.searchinCollecById(collecItemId);
		//Lib.alert("search");
		var spodid=microListe.id;
	//	Lib.alert("spodid"+spodid);
		maputil.removeInCurrent(microListe);
	//	Lib.alert("remove");
		//maputil.addInCollec(liste);
		new JQuery("#"+id).fadeOut(1000, function ():Void{new JQuery("#"+id).remove();});
	//	Lib.alert("afterdelete"+classMap);
		spodDelete(voName,spodid);
	//	Lib.alert("afterdeleteId"+id);
		//new JQuery("#"+id).remove();
	}
	
	var _plusInfos:PlusInfos;
	


	
	
	public function PlusCollection(plusInfos:microbe.form.elements.PlusInfos){
		_plusInfos=plusInfos;
		Std.string("name"+plusInfos.collectionName +"graine="+plusInfos.graine ).Alerte();
	
				var req= new haxe.Http(BackJS.back_url+"addCollectServerItem/");
				BackJS.back_url.Alerte();
				req.setParameter("name",plusInfos.collectionName );
				req.setParameter("voParent", classMap.voClass);
				req.setParameter("voParentId",Std.string(classMap.id));
				req.setParameter("graine",Std.string(plusInfos.graine));
				req.onError=Lib.alert;
				req.onData=function(x) {onAddItemPlus(x,this._plusInfos);}; 
				req.request(true);
				"end".Alerte();
			
	}
	function onAddItemPlus( x:String ,PI:PlusInfos) : Void {
		
			var raw:Dynamic=null;
			try
			{
				
			raw=haxe.Unserializer.run(x);
			
			}catch ( err:String )
			{
				err.Alerte();
			}
			///dabord notify> append element 
			PI.target.notify(raw.element);
			//puis ajax binding
			parseplusCollec(raw.microliste,PI.graine);
			
	}
	
	
	function parseplusCollec(liste:MicroFieldList,pos:Int) : Void {

		var microfield:MicroFieldList=cast liste.fields.first();
		for(elements in microfield){
			microbeElements.createElement(cast elements);
		}
		microbeElements.createCollectionElement(microfield,pos);
		var maputil= new ClassMapUtils(classMap);
		maputil.searchCollec(microfield.voName);
		maputil.addInCollec(microfield);
		classMap.fields=maputil.mapFields;
		Std.string(microfield).Alerte();

	}


	
}