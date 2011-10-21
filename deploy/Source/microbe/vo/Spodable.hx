package microbe.vo;

import microbe.form.IMicrotype;
/*	import php.db.Manager;
	import php.db.Object;*/

	/**
	 * ...
	 * @author postite
	 */
/*	typedef FieldType =
	{
	var classe:String;
	var type:InstanceType;
	var champs:Dynamic;
	}
	
	enum InstanceType
	{
		formElement;
		collection;
		spodable;
	}*/
	
	
	interface Spodable
	{
		public var poz:Int;
		public function getFormule():Hash<FieldType>;
		public function getDefaultField():String;
	//	public static var manager:Manager<Spodable>;
	/*	public function getFields():List<Dynamic>;
			public function getHash():Hash<Dynamic>;*/
		//public var voType:String;
		public var id:Int;
	}