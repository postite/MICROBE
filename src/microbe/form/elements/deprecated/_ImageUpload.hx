package microbe.form.elements;

/**
 * ...
 * @author postite
 */
#if php
class ImageUpload extends FileUpload
{

	public function new(name:String, label:String, ?value:String, ?required:Bool=false,  ?toFolder:String=null, ?keepFullFileName:Bool=false) 
	{
		super(name, label, value, required, MyController.appConfig.runtimePath+"res/" , keepFullFileName);
	}
	override public function render(?iter:Int):String
	{
		var n = name;
		//TODO
		//var path = toFolder.substr((Poko.instance.config.applicationPath + "res/").length);
	
		var path = toFolder.substr((MyController.appConfig.runtimePath + "res/").length);
		var absPath = "/runtime/res/";//"http://127.0.0.1/runtime/res/";
		var str:String = "";
		
		str += '<img class="fileName" src="'+MyController.imageCache+"thumb/"+getFileName()+'"/><br/>';
		str += '<input type="file" name="' + n + '" id="' + n + '" ' + attributes + 'value="choisir une image"/>';
		str += '<input type="hidden" name="' + n + '__previous" id="' + n + '__previous" value="'+value+'"/>';
		 
		return str;
	}
	
}

#end