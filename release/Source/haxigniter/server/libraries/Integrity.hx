package haxigniter.server.libraries;

#if php
import php.Lib;
import php.Web;
import php.FileSystem;
import php.io.File;
#elseif neko
import neko.Lib;
import neko.Web;
import neko.FileSystem;
import neko.io.File;
#end

class Integrity
{
	public var testMethodPrefix : String;
	private var testMethods : Dynamic;
	
	public function new(testMethods : Dynamic, ?testMethodPrefix : String = 'test')
	{
		this.testMethodPrefix = testMethodPrefix;
		this.testMethods = testMethods;
	}
	
	public function run() : Void
	{
		var classType = Type.getClass(testMethods);
		var fields = (classType == null) ? Reflect.fields(testMethods) : Type.getInstanceFields(classType);
		
		for(field in fields)
		{
			if(StringTools.startsWith(field, this.testMethodPrefix) && Reflect.isFunction(Reflect.field(this, field)))
				runTest(field);
		}
	}
	
	private function runTest(methodName : String) : Void
	{
		var title = {value: methodName};
		var result : Bool = Reflect.callMethod(testMethods, Reflect.field(testMethods, methodName), [title]);
		
		if(result != null)
		{
			Lib.print('<div style="font-family: Verdana; font-size:12px; float:left; display:inline; padding:4px; margin:1px; border:1px solid gray; width:99%;">');
			Lib.print('<div style="float:left; padding:0 3px 0 3px;">' + title.value + '</div>');

			if(result == true)
				Lib.print('<div style="width:70px; float:right; background-color:#2D1; padding:1px 3px 1px 3px; text-align:center;">OK</div>');
			else
				Lib.print('<div style="width:70px; float:right; background-color:#C12; padding:1px 3px 1px 3px; text-align:center;">FAILED</div>');

			//else if(result == null)
				//Lib.print('<div style="width:70px; float:right; padding:1px 3px 1px 3px; text-align:center;"><strong>?</strong></div>');
		
			Lib.print('</div>');
			Web.flush();
		}
	}
	
	private function printHeader(text : String) : Void
    {
        Lib.print('<div style="font-family: Verdana; font-size:13px; font-weight:bold; float:left; display:inline; padding:8px 4px 0 4px; margin:1px; border:0; width:99%;">');
        Lib.print('<div style="float:left; padding:0;">' + text + '</div></div>');
		Web.flush();
    }

	private function isWritable(path : String) : Bool
	{
		#if php
		return untyped __call__('is_writable', path);
		#elseif neko
		if(StringTools.endsWith(path, '/'))
			path = path.substr(0, path.length-1);

		if(!FileSystem.exists(path)) return false;
		
		switch(FileSystem.kind(path))
		{
			case FileKind.kfile:
				try
				{
					File.append(path, true).close();
					return true;
				}
				catch(e : Dynamic)
				{
					return false;
				}
			
			case FileKind.kdir:	
				try
				{
					var test = File.write(path + '/__isWritableNekoTest.tmp', true);
					test.writeString('');
					test.close();
					
					FileSystem.deleteFile(path + '/__isWritableNekoTest.tmp');
					return true;
				}
				catch(e : Dynamic)
				{
					return false;
				}
			
			default:
				throw 'isWritable(): Only files and directories are supported.';
		}
		#end
	}
}
