package monjs;

import microbe.form.AjaxElement;
import microbe.form.elements.TestCrossAjax;
import microbe.form.elements.AjaxInput;
import microbe.form.elements.AjaxEditor;
import microbe.form.elements.RichtextWym;
import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.Microfield;
import microbe.ClassMap;
import microbe.form.IMicrotype;
import microbe.form.MicroFieldList;
import microbe.form.elements.CollectionElement;
import microbe.ClassMapUtils;
import microbe.form.elements.DeleteButton;
import microbe.form.elements.TailleSelector;
import microbe.form.elements.ImageUploader;
import microbe.form.elements.AjaxUploader;
import microbe.form.elements.CheckBox;
import microbe.form.elements.AjaxDate;
import microbe.form.elements.TagView;
using microbe.tools.Debug;

class Ajaxe
{



	private var bop:String;
	public static var instance:Ajaxe;
	
	public var uploadButton:Dynamic;
	public var classMap:ClassMap;
	public var valueList:List<Microfield>;
	public var microbeElements:List<AjaxElement>;
	public var base_url:String;
	public var back_url:String;
	public var currentVo:String;
	
	public static var debug:Bool=true;

	public function new()
	{
	"new".Alerte();
	bop="bulle";
	instance=this;
	base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
	back_url=base_url+"/index.php/myback/";
	
	//trace('bop='+instance);
	//Lib.alert(new JQuery("#uploadButton"));
	
	new JQuery("document").ready(function(e):Void{instance.init();});
	
	}
	static function main(){
		new Ajaxe();
	}

	//function de mapping elements
	//appelé apres mapping
	public function init(){
		//trace("init");
		
		"init".Alerte();
		CollectionElement.deleteSignal.add(deleteCollection); //core
		DeleteButton.sign.add(deleteSpod); //core
		///acive le "bouton" ajoute
		new JQuery(".ajout").click(ajoute); //core
		//var page= new JPagination("#leftCol");
		//DeleteButton.sign.add(testi);
	}
	///utilisé par bouton delete
	function deleteSpod() : Void {
		"sur?".Alerte();
	//Lib.window.location.href="http://localhost:8888/index.php/myback/delete/"+classMap.voClass+"/"+classMap.id;
		Lib.window.location.href=back_url+"delete/"+classMap.voClass+"/"+classMap.id;
	}
	
	function spodDelete(voName:String,id:Int) : Void {
		"".Alerte();
		var reponse=haxe.Http.requestUrl(back_url+"delete/"+voName+"/"+id);
	//	Lib.alert("reponse="+reponse);
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
	
	public function ajoute(e:JqEvent):Void{
		currentVo.Alerte();
		Lib.window.location.replace(back_url+"ajoute/"+currentVo);
	}
	
	
	///appelé en static 
	public function setClassMAp(compressedMap:String){
	//	trace("setClassMAp");
	"".Alerte();
		classMap=haxe.Unserializer.run(compressedMap);
		new JQuery("#"+classMap.submit).click(function(e):Void{instance.clika();});
		
		parseMap();
		//Lib.alert("hello" +classMap);
	}
	//ajoute un element de collection au classmap .. à externaliser
	public function addCollection(liste:MicroFieldList) : Void {
		"".Alerte();
		//chercher la collection dans le classMap
		//integrer le classMap
	}

	
	/// classMAping form_classMAp -> js ClassMAp
	//implementer le recursif....
	//appelé par setClassMAp
	private function parseMap():Void{
	"".Alerte();
	currentVo=classMap.voClass;
	var liste:MicroFieldList=classMap.fields; //Microfields or List<Microfield
	if (liste.taggable==true){
		new TagView(liste);
	}
	microbeElements=recurMap(liste);
	
	//gestion du bouton effacer pas trop la bonne méthode
	//new JQuery("#"+classMap.voClass+"_form_effacer").click(testi);
	var deleteBouton= new DeleteButton(classMap.voClass+"_form_effacer");
	
	}
	//appelé par parseMAp
	function recurMap(liste:MicroFieldList,?stock:List<AjaxElement>):List<AjaxElement>{
		"".Alerte();
	//	var ajaxList:List<AjaxElement>=null;
		if((stock==null)){
		stock= new List<AjaxElement>();
		
		}
		var pos:Int=0;
		for (chps in liste){
			trace("recurMAp"+chps.type);
			if(Std.is(chps,MicroFieldList)){
				///////va falloir trouver une autre solution
				
				if(chps.type==collection){
					
					for (item in cast(chps,MicroFieldList).fields.iterator()){
						trace("hop");
					//	Lib.alert("itemField="+item.toString());
						/*var microChamps:Microfield=new Microfield();//cast chps;
												microChamps.elementId=chps.voName;
												microChamps.field="opo";
												microChamps.value='pum';
												microChamps.element="popopo";
												trace(microChamps.toString());*/
						
						var d:AjaxElement=cast Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[chps,pos]);
						pos++;
					}
					
					trace("colectiiiiiiion");
					
					//var d:AjaxElement=cast Type.createInstance(Type.resolveClass("microbe.form.CollectionElement"),[microChamps]);
				//	stock.add(d);
					trace("good job");
				//	return stock;
				
				}
				recurMap(cast (chps,MicroFieldList),stock);
			}
			
			
			else{
				
				var microChamps:Microfield=cast chps;
				trace("microChamps"+microChamps.value);
			//	trace("microchamp="+microChamps.element);
				var d:AjaxElement=cast Type.createInstance(Type.resolveClass(microChamps.element),[microChamps]);
				trace("d="+d.element);
				stock.add(d);
				//d.focus();
			}
		}
		
	//	trace("ajaxList.length="+stock.length);
		return stock;
	}
	
	
	
	///appelé par bouton enregistrer
	public function clika(){
//		trace("clika");
		"clicka".Alerte();
	//	trace("microbeElements="+microbeElements.length);
		for( mic in microbeElements){
			
		//	Lib.alert(mic.getValue());
		untyped console.log("value="+ mic.microfield +"--"+mic.getValue());
		mic.microfield.value= mic.getValue();
		untyped console.log("microValue="+ mic.microfield.value);
		
		}
		//untyped console.log("micro="+ microbeElements);
		//untyped console.log("recValues="+microbeElements);
		//Lib.alert("testMAp="+classMap.fields.first().value);
		//untyped console.log("map1="+classMap.fields.last());
		//testMap(classMap.fields);
		
	//	DebugClassMap(classMap.fields);
		
		AjaxFormTraitement();
		
	}
	public function delete(id:String) : Void {
		"".Alerte();
		//Lib.alert("delete"+id);
	}
	
	public function PlusCollection(compressedelement:String,liste:String){
		"".Alerte();
		var unelement=haxe.Unserializer.run(compressedelement);
	//	Lib.alert("pluscollection"+unelement);
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
		trace("unliste="+liste);
		var xposint=haxe.Serializer.run(posint);
		//var posliste=r.replace(liste,xposint); // "aaabcbcbcxx"
		//trace("posliste="+posliste);
		var unliste:MicroFieldList=haxe.Unserializer.run(liste);
		parseplusCollec(unliste,Std.int(posint));
		//trace("liste="+cast(unliste.first(),Microfield).elementId);
		trace("liste="+unliste.toString());
		//new JQuery(".collection").last().clone().insertAfter(new JQuery(".collection").last());
	}
	function findcollection(voName:String) : Void {
		"".Alerte();
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
			trace("polo="+cast(microfield,Microfield).elementId);
		}
		var microChamps:Microfield=new Microfield();//cast chps;
		microChamps.elementId=liste.elementId;
		microChamps.field=liste.field;
		microChamps.value=null;
		microChamps.element="microbe.form.elements.CollectionElement";
		
		var d:AjaxElement=cast Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[microChamps,liste.pos]);
		var maputil= new ClassMapUtils(classMap);
		maputil.searchCollec(liste.voName);
		maputil.addInCollec(liste);
		classMap.fields=maputil.mapFields;
		//Lib.alert("classMap="+classMap.fields.getLength());
		microbeElements=recurMap(liste,microbeElements);
		untyped console.log("classmapplus="+classMap.fields.last().fields.last().fields.first().elementId);
	}
	
	function testMap(liste:List<Dynamic>){
		"".Alerte();
			for (t in liste){
				if(Std.is(t,List)){
					testMap(t);
				}else{
					trace(cast(t,Microfield).value);
				}
			}
	}
	//utilisé à l'enregistrement
	public function AjaxFormTraitement(){
		"".Alerte();
	//	Lib.alert("AjaxFormTraitement");
	/*	valueList= new List<Microfield>();
			
			//attention il va falloir triter les types imbriqués
			for( mic in microbeElements){
				 		
				
						//	trace("isString");
							valueList.add(mic.microfield);
					
				}*/
		//untyped console.log("classmaprec="+classMap.fields.last().fields.last().fields.first().value);		
		var compressedValues=haxe.Serializer.run(classMap);
		trace("classMAp="+classMap);
	//	trace("compress="+compressedValues);
	//	var req= new haxe.Http("http://localhost:8888/index.php/rec/microFieldAjaxe/");
		var req= new haxe.Http(back_url+"rec/");
	//	req.setParameter("voName", voName);
		req.setParameter("map", compressedValues);
		//req.url=;
		req.onData=function(d) { trace("onDataAjaxForm" + d);}; 
		req.request(true);
		
	}
	
	public static function testCross(){
		"".Alerte();
	var yo=	new JQuery("#bla").attr("microbe");
	var element:TestCrossAjax = Type.createInstance(Type.resolveClass(yo),[]);

//	Lib.alert(element.getForm());
	
	}
	public static  function domInit(){
	"".Alerte();
//	new JQuery("#uploadButton").click(function(e):Void{testUpload(e);});
//	testCross();
//	document.getElementById('file_upload_form').target = 'upload_target'; //'upload_target' is the name of the iframe
	
	}
	/*public static function testUpload(e:JqEvent){
		//	trace("yo les gars");
			var preview="#upload_image";
			new JQuery("#myForm").attr("target","upload_target");
			new JQuery("#upload_target").load(function(e):Void{onLoad(e,preview);});
			new JQuery("#myForm").submit();
		//e.preventDefault();
		//	e.preventDefault(); //	var filename= new JQuery("#"+input).attr('value');
	//	var field=new JQuery("#"+input).attr('name');
	//	new JQuery("#myForm").submit();
		
		//request("http://localhost:8888/index.php/upload",onUpload);
		}
		static function onLoad(e:JqEvent,preview:String){
		//	Lib.alert("yeah");
	//	Lib.alert(new JQuery("#upload_target").context.innerHTML);
	var p=new JQuery("#upload_target").contents().text() ;// getElementsByTagName("body").length;

	new JQuery(preview).attr("src","imgs/"+p) ;
	new JQuery(preview).fadeTo(0,0);
	new JQuery(preview).fadeTo(600,1);
	//new JQuery(preview).show(600);
	//Lib.alert("p="+p);
		}
		static function onUpload(data):Void{
		//	trace("onUpload" +data);
		}*/
		
/*	public static function request(url:String,callBack:Dynamic){
		var req= new haxe.Http(url);
		//req.url=;
	//	hidden2 => Hello world !, hiddenValue => OK
		req.setParameter("hidden2", "youp");
		req.setParameter("hiddenVAlue", "OK");
	//	req.setParameter("fl",);
		req.onData=function(d){onUpload(d);}
		req.request(true);
	}*/
	
	
	public  function DebugClassMap(map:MicroFieldList){
		"".Alerte();
		for (a in map){
			trace("CMField="+a.type +"-"+a.field+"--"+a.voName);
			if(a.type==collection) DebugClassMap(cast(a).fields);
		}
		trace("afterDebug");
//		Lib.alert("pop");
	}
	
	
	
	public function instanceTest(target:HtmlDom){
	///	trace(target.className);
	"".Alerte();
	var initClass:String=target.className;
	 		//var target = event.target;
	 		//var element=getElementContent(target);
	 		var compressed=target.innerHTML;
		//	new JQuery('.'+target.className).removeClass(initClass).addClass(initClass +"_off");
	
			new JQuery('.'+target.className).fadeToggle();
	 		var decompressed:Array<String>=haxe.Unserializer.run(compressed);
	 		for (a in decompressed){
	 		//Lib.alert(a);
	 }


	}
	function formtraitement(p:String,voName:String) : Void {
		"".Alerte();
		var uncompressed:Iterable<String>=  haxe.Unserializer.run(p);
		var valuesList= new Hash<String>();
		for (a in uncompressed){
		var value:String=new JQuery("#"+ voName+"_form_"+voName+"_"+a ).val();
			valuesList.set(a,value);
			trace("value="+value);
		}
		var compressedValues=haxe.Serializer.run(valuesList);
		var req= new haxe.Http("http://localhost:8888/index.php/fresh/postAjax/");
		req.setParameter("voName", voName);
		req.setParameter("values", compressedValues);
		//req.url=;
		req.onData=function(d) { trace("onData" +d);}; 
		req.request(true);

	}
	//_vofields =hash compressed =arborescence in FormGenerator
	function formTraitementByVoFields(_voFields:String,voName){
		"".Alerte();
		var arborescence:Hash<Dynamic>= haxe.Unserializer.run(_voFields);
	//	trace("arbo="+arborescence);
		var valuesList= new Hash<Dynamic>();
		for (champs in arborescence.keys()){
			//trace("champs="+arborescence.get(champs).hasNext());
	
		if(Std.is(arborescence.get(champs),String)){
		//	trace("isString");
			var value:String=new JQuery("#"+ arborescence.get(champs) ).val();
			valuesList.set(champs,value);
		}
		else
		{
			var depValue=new Hash<String>();
			var dependance:Hash<String>=cast arborescence.get(champs);
			for(dep in dependance.keys()){
				var childVo:String="MonstreChild"; //TODO temporaire à remplacer dynamiquement
				var value:String=new JQuery("#"+dependance.get(dep)).val();
				depValue.set(dep,value);
				valuesList.set(champs+"_"+childVo,depValue);
			}
			
		}
			
			
		}
	//	trace("value="+valuesList);
		var compressedValues=haxe.Serializer.run(valuesList);
		var req= new haxe.Http("http://localhost:8888/index.php/fresh/postAjax/");
		req.setParameter("voName", voName);
		req.setParameter("values", compressedValues);
		//req.url=;
		req.onData=function(d) { trace("onData" +d); }; 
		req.request(true);
		
		
	}
	function platch(p:String): Void {
		"".Alerte();
	//	var decomp= haxe.Unserializer.run(p);
	//	var modif=decomp;
		var reponse=haxe.Http.requestUrl("http://localhost:8888/index.php/fresh/ajaxed/"+p);
		Lib.alert(reponse);
		var nup:JQuery=new JQuery("."+reponse).addClass("piy");
	//	nup.context
		nup.attr("value","popo");
	//	Lib.alert(nup.);
	}
	
	public function pop() : Void {
	"".Alerte();
	}
	private function getElementClass(element:String):Dynamic{
		"".Alerte();
	//	var element=Lib.document.(element);
		return element;
	}
	private function getElementId(element:String):Dynamic{
		"".Alerte();
		var element=Lib.document.getElementById(element);
		return element;
	}
	
	
}