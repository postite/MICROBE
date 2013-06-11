package haxigniter.server.request;

import haxigniter.common.exceptions.Exception;
import haxigniter.server.request.RequestHandler;
import haxigniter.server.Controller;
import haxigniter.common.libraries.ParsedUrl;

#if neko
 import neko.Web;
// import neko.io.File;
// import neko.io.FileOutput;
 import neko.io.Path;
#elseif php
 import php.Web;
// import php.io.File;
// import php.io.FileOutput;
 import haxe.io.Path;
import php.Lib;
#end



import sys.io.File;
import sys.io.FileOutput;
//import sys.io.Path;


import haxe.io.Bytes;

/**
* File upload decorator
* Author : Blue112
* Version : 0.9
* Allow file upload, pass a second parameter to the final function, 
* with a hash table which contains FileInfo Objects.
**/

class FileUploadDecorator extends RequestHandlerDecorator
{
	public var restrictClass : Class<Dynamic>;
	public var addToArguments : Bool;

	private var hashFile : Hash<FileInfo>;
    private var fields : Hash<String>;
	private var currentFile : FileOutput;
    private var currentFileName : String;
    private var currentFieldName : String;
    private var currentFileFieldName : String;
    private var currentIsFile : Bool;
    private var currentWrittenByte : Int;

	public function new(requestHandler : RequestHandler, ?restrictClass : Class<Dynamic>, ?addToArguments = false)
	{
		super(requestHandler);

		this.restrictClass = restrictClass;
		this.addToArguments = addToArguments;
	}

	public override function handleRequest(controller : Controller, url : ParsedUrl, method : String, getPostData : Hash<String>, requestData : Dynamic) : RequestResult
	{
	
		var result = requestHandler.handleRequest(controller, url, method, getPostData, requestData);

		switch(result)
		{
			case noOutput:
				return result;

			case returnValue(value):
				return result;

			case methodCall(object, method, arguments):
				hashFile = new Hash();
                fields = new Hash();
				Web.parseMultipart(onInfo, onData);

                if (currentFieldName != null)
                {
                    arguments.pop();
                    arguments.push(fields);
                }

				//If we had a file
				if (currentFile != null)
				{
					currentFile.close();
					if (currentWrittenByte == 0)
					{
						hashFile.remove(currentFileFieldName);
					}

					arguments.push(hashFile);
					arguments.push(currentWrittenByte);
				}
				
				return RequestResult.methodCall(object, method, arguments);
			//	return RequestResult.noOutput;
		}
	}

	private function onInfo (fieldName : String, fileName : String) : Void
	{
		
		if (fileName != null) //That's a file
		{
            currentIsFile = true;

            if (currentFile != null) //This is not the first file
            {
				currentFile.close();
				if (currentWrittenByte == 0)
				{
					hashFile.remove(currentFileFieldName);
				}
            }
            
            currentWrittenByte = 0;
            currentFileFieldName = fieldName;
            
			//FIXME : Maybe make a config entry for temp directory ?
			///TODO check path
			var tmpPath = Path.directory(Web.getCwd())+"/runtime/cache/igni-"+haxe.Md5.encode(Std.string(Math.random() + Math.random()));
			var standardizedName= StringTools.replace(fileName," ","_");
			//var standardizedName= untyped __call__("strtr", fileName, "àáâãäçèéêëìíîïñòóôõöùúûüýÿÀÁÂÃÄÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝ$&+!*'(), ","aaaaaceeeeiiiinooooouuuuyyAAAAACEEEEIIIINOOOOOUUUUY__________");
			//var str = "aaabcbcbcbz";
   //var r = ~/&(.)[^;]+/; 

    var r =~/[\x80-\xFF]/;
   standardizedName=r.replace(standardizedName,"-"); // "aaabcbcbcxx"
			hashFile.set(fieldName, new FileInfo(standardizedName,tmpPath));

			currentFile = File.write(tmpPath, true);
		}
        else //That's a regular field
        {
            currentFieldName = fieldName;
            currentIsFile = false;
        }
	}

	private function onData (data : Bytes, pos : Int, length : Int) : Void
	{
	
        if (currentIsFile)
        {
            currentFile.writeBytes(data, pos, length);
            currentWrittenByte += length;
        }
        else
        {
            if (fields.exists(currentFieldName))
            {
                fields.set(currentFieldName, fields.get(currentFieldName) + data.readString(pos, length));
            }
            else
            {
                fields.set(currentFieldName, data.readString(pos, length));
            }
        }
    }

}

class FileInfo
{
	public var name (default, null) : String;
	public var tmpPath (default, null) : String;

	public function new(name : String, tmpPath : String)
	{
		this.tmpPath = tmpPath;
		this.name = name;
	}

//     public function copyTo(relpath:String):String
//     {
// //return relpath;
// microbe.controllers.GenericController.appDebug.log("realpath="+(relpath));
// 	        if (!(Path.withoutDirectory(relpath) == ""))
// 	        	         {
// 	        	         	microbe.controllers.GenericController.appDebug.log("realpath+++"+name);
// 	        	        	 relpath += name;
// 	        	         }
// 	      microbe.controllers.GenericController.appDebug.log("realpath="+relpath);
// 	        File.copy(tmpPath,relpath);
// 			return name;
//     }

    public function copyTo(relpath : String)
    {
    	//microbe.controllers.GenericController.appDebug.log("initrealpath="+relpath);
        if (Path.withoutDirectory(relpath) == "")
        {
        	//microbe.controllers.GenericController.appDebug.log("loop="+relpath+"name="+name);
            relpath += name;
        }
       // microbe.controllers.GenericController.appDebug.log(Path.directory(Web.getCwd()) + "/"+relpath);
        File.copy(tmpPath, Path.directory(Web.getCwd())  + relpath);
        return name;
    }
}