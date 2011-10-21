package jquery.ui;
import js.JQuery;
import js.Dom;



extern enum SortableEvent{
	create;
	//Type:sortcreate
	
					/*This event is triggered when sortable is created.
					
						Code examples
					
						Supply a callback function to handle the create event as an init option.
						$( ".selector" ).sortable({
						   create: function(event, ui) { ... }
						});
						Bind to the create event by type: sortcreate.
						$( ".selector" ).bind( "sortcreate", function(event, ui) {
						  ...
						});*/
	start;
	//Type:sortstart
	
				/*This event is triggered when sorting starts.
				
					Code examples
				
					Supply a callback function to handle the start event as an init option.
					$( ".selector" ).sortable({
					   start: function(event, ui) { ... }
					});
					Bind to the start event by type: sortstart.
					$( ".selector" ).bind( "sortstart", function(event, ui) {
					  ...
					});*/
		
	sort;	
	//Type:sort
				/*This event is triggered during sorting.
				
					Code examples
				
					Supply a callback function to handle the sort event as an init option.
					$( ".selector" ).sortable({
					   sort: function(event, ui) { ... }
					});
					Bind to the sort event by type: sort.
					$( ".selector" ).bind( "sort", function(event, ui) {
					  ...
					});*/
	change;	
	//Type:sortchange
	
				/*This event is triggered during sorting, but only when the DOM position has changed.
				
					Code examples
				
					Supply a callback function to handle the change event as an init option.
					$( ".selector" ).sortable({
					   change: function(event, ui) { ... }
					});
					Bind to the change event by type: sortchange.
					$( ".selector" ).bind( "sortchange", function(event, ui) {
					  ...
					});*/
		
		
	beforeStop;
	//Type:sortbeforestop
					/*This event is triggered when sorting stops, but when the placeholder/helper is still available.
					
						Code examples
					
						Supply a callback function to handle the beforeStop event as an init option.
						$( ".selector" ).sortable({
						   beforeStop: function(event, ui) { ... }
						});
						Bind to the beforeStop event by type: sortbeforestop.
						$( ".selector" ).bind( "sortbeforestop", function(event, ui) {
						  ...
						});*/
		
	stop;
	//Type:sortstop
					/*This event is triggered when sorting has stopped.
					
						Code examples
					
						Supply a callback function to handle the stop event as an init option.
						$( ".selector" ).sortable({
						   stop: function(event, ui) { ... }
						});
						Bind to the stop event by type: sortstop.
						$( ".selector" ).bind( "sortstop", function(event, ui) {
						  ...
						});*/

	update;
	//Type:sortupdate
						/*This event is triggered when the user stopped sorting and the DOM position has changed.
	
			Code examples
	
			Supply a callback function to handle the update event as an init option.
			$( ".selector" ).sortable({
			   update: function(event, ui) { ... }
			});
			Bind to the update event by type: sortupdate.
			$( ".selector" ).bind( "sortupdate", function(event, ui) {
			  ...
			});*/
			
			
	receive;
		//Type:sortreceive
					/*This event is triggered when a connected sortable list has received an item from another list.
					
						Code examples
					
						Supply a callback function to handle the receive event as an init option.
						$( ".selector" ).sortable({
						   receive: function(event, ui) { ... }
						});
						Bind to the receive event by type: sortreceive.
						$( ".selector" ).bind( "sortreceive", function(event, ui) {
						  ...
						});*/
						
						
	remove;	
	//Type:sortremove
	
	 				/*This event is triggered when a sortable item has been dragged out from the list and into another.
	
	 Code examples
	
	 Supply a callback function to handle the remove event as an init option.
	 $( ".selector" ).sortable({
	    remove: function(event, ui) { ... }
	 });
	 Bind to the remove event by type: sortremove.
	 $( ".selector" ).bind( "sortremove", function(event, ui) {
	   ...
	 });*/
	 	
	over;
	//Type:sortover
				/*This event is triggered when a sortable item is moved into a connected list.
				
					Code examples
				
					Supply a callback function to handle the over event as an init option.
					$( ".selector" ).sortable({
					   over: function(event, ui) { ... }
					});
					Bind to the over event by type: sortover.
					$( ".selector" ).bind( "sortover", function(event, ui) {
					  ...
					});*/
		
	outType;
	//:sortout
					/*This event is triggered when a sortable item is moved away from a connected list.
					
						Code examples
					
						Supply a callback function to handle the out event as an init option.
						$( ".selector" ).sortable({
						   out: function(event, ui) { ... }
						});
						Bind to the out event by type: sortout.
						$( ".selector" ).bind( "sortout", function(event, ui) {
						  ...
						});*/
		
	activate;
	//Type:sortactivate
					/*This event is triggered when using connected lists, every connected list on drag start receives it.
					
						Code examples
					
						Supply a callback function to handle the activate event as an init option.
						$( ".selector" ).sortable({
						   activate: function(event, ui) { ... }
						});
						Bind to the activate event by type: sortactivate.
						$( ".selector" ).bind( "sortactivate", function(event, ui) {
						  ...
						});*/
		
	deactivate;
	//Type:sortdeactivate
					/*This event is triggered when sorting was stopped, is propagated to all possible connected lists.
					
						Code examples
					
						Supply a callback function to handle the deactivate event as an init option.
						$( ".selector" ).sortable({
						   deactivate: function(event, ui) { ... }
						});
						Bind to the deactivate event by type: sortdeactivate.
						$( ".selector" ).bind( "sortdeactivate", function(event, ui) {
						  ...
						});*/

}
	typedef UI ={
		var helper:String;
		var	position:String;
		var	offset:String;
		var	item:String;
		var	placeholder:String;
		var	sender:String;
			}

typedef SortableOptions =
{
	var disabled:Bool;//Default:false
	var appendTo:String;//Default:'parent'
	var axis:String;//Default:false
	var cancel:String;//Selector Default:':input,button'
	var connectWith:String ;//Selector Default:false
	var containment:String ;//Element, String, SelectorDefault:false
	var cursor:String;//Default:'auto'
	var cursorAt:Dynamic; //Default:false
	var delay:Int;//Integer Default:0
	var distance:Int;//Default:1
	var dropOnEmpty:Bool;//Default:true
	var forceHelperSize:Bool;//Default:false
	var forcePlaceholderSize:Bool;//Default:false
	var grid:Dynamic;//Array//Default:false 
	var handle:String;//Selector|Element ,Default:false
	var helper:Dynamic;// String|Function Default:'original'
	var itemsSelector:String;//Default:'> *'
	var opacity:Float;//Default:false
	var placeholder:String;//Default:false
	var revert:Dynamic;// Boolean/IntegerDefault:false
	var scroll:Bool;//Default:true
	var scrollSensitivity:Int;//Default:20
	var scrollSpeed:Int;//Default:20
	var tolerance:String;//Default:'intersect'
	var zIndex:Int;//Default:1000
	
	
	
	///Event paramaeters 
	//use :sortoptions.deactivate=ondeactivate;
	var create:JqEvent->UI->Void;
	var start:JqEvent->UI->Void;
	var sort:JqEvent->UI->Void;
	var change:JqEvent->UI->Void;
	var beforeStop:JqEvent->UI->Void;
	var update:JqEvent->UI->Void;
	var stop:JqEvent->UI->Void;
	var receive:JqEvent->UI->Void;
	var remove:JqEvent->UI->Void;
	var over:JqEvent->UI->Void;
	var out:JqEvent->UI->Void;
	var activate:JqEvent->UI->Void;
	var deactivate:JqEvent->UI->Void;
	
}



#if JQUERY_NOCONFLICT
@:native("jQuery")
#else
@:native("$")
#end

extern class Sortable extends JQuery
{
	public static function __init__():Void
	{
		untyped __js__("var Sortable = window.jQuery");
		
		untyped __js__('SortableEvent={create:"sortcreate",sortstart:"start",sort:"sort",change:"sortchange",sortbeforeStop:"beforeStop",stop:"sortstop",update:"sortupdate",receive:"sortreceive",remove:"sortremove",over:"sortover",out:"sortout",activate:"sortactivate",deactivate:"sortdeactivate"}');
	}
	
	

	
	
	// "strange" doc from jquery UI > note the underscore +number in id 
	/*.sortable( "serialize" , [options] )
	Serializes the sortable's item id's into a form/ajax submittable string. Calling this method produces a hash that can be appended to any url to easily submit a new item order back to the server.

	It works by default by looking at the id of each item in the format 'setname_number', and it spits out a hash like "setname[]=number&setname[]=number".

	You can also give in a option hash as second argument to custom define how the function works. The possible options are: 'key' (replaces part1[] with whatever you want), 'attribute' (test another attribute than 'id') and 'expression' (use your own regexp).

	If serialize returns an empty string, make sure the id attributes include an underscore. They must be in the form: "set_number" For example, a 3 element list with id attributes foo_1, foo_5, foo_2 will serialize to foo[]=1&foo[]=5&foo[]=2. You can use an underscore, equal sign or hyphen to separate the set and number. For example foo=1 or foo-1 or foo_1 all serialize to foo[]=1.
	*/
		@:overload(function(?opt:Dynamic):String {return untyped("pop");})
			override inline public function serialize() :String{
				
				return "use sortserialize(?opt)";
				//return untyped(this.sortable("serialize"));
			}
		
		
		//j'ai pas trouvé comment overrider serialize avec des parametres differents...	
		inline public function sortSerialize(?opt:Dynamic):String{
					return untyped(this.sortable("serialize",opt));
		}
	

		inline public function destroy() : Sortable {return untyped(this.sortable("destroy"));}
		inline public function disable() : Sortable {return untyped(this.sortable("disable"));}
		inline public function enable() : Sortable {return untyped(this.sortable("enable"));}
		/// ? public function option() : Void {
		inline public function widget() : JQuery {return untyped(this.sortable("widget"));}
	
	

		override inline public function toArray():Array<js.HtmlDom>{
				return untyped(this.sortable("toArray"));
				}
	
		inline public function refresh() : Sortable {return untyped(this.sortable("refresh"));}
		inline public function refreshPositions() : Sortable {return untyped(this.sortable("refreshPositions"));}
		inline public function cancel() : Sortable {return untyped(this.sortable("cancel"));}
		

	
	
	
		
		
	
		@:overload(function(methode:String,?opt:Dynamic):Sortable{})
			public function sortable(options:SortableOptions):Sortable;
	// override public function toArray():Array<Dynamic>;
	
	
	
}