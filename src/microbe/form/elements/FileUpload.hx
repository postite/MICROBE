/*
 * Copyright (c) 2008, TouchMyPixel & contributors
 * Original author : Tony Polinelli <tonyp@touchmypixel.com> 
 * Contributers: Tarwin Stroh-Spijer 
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE TOUCH MY PIXEL & CONTRIBUTERS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE TOUCH MY PIXEL & CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */


package microbe.form.elements;
import haxe.Md5;
import haxe.Timer;
import php.FileSystem;
//import poko.Poko;
import php.Web;
import microbe.form.Form;
import microbe.form.FormElement;
import poko.utils.PhpTools;
import MyController;
class FileUpload extends FormElement
{
	public var toFolder:String;
	public var keepFullFileName:Bool;
	
	public function new(name:String, label:String, ?value:String, ?required:Bool=false,  ?toFolder:String=null, ?keepFullFileName:Bool=true ) 
	{
		super();
		this.name = name;
		this.label = label;
		this.value = value;
		this.required = required;
		//TODO
		//this.toFolder = toFolder != null ? toFolder : Poko.instance.config.applicationPath + "res/temp/";
		this.toFolder = toFolder != null ? toFolder : MyController.appConfig.runtimePath + "res/tmp/";
		this.keepFullFileName = keepFullFileName;
	}
	
	override public function populate()
	{
		var n = form.name + "_" + name;
		
		//todo
		//var previous = Poko.instance.params.get(n+"__previous");
		var previous = Web.getParams().get(n+"__previous");
		var file:Hash<Dynamic> = PhpTools.getFilesInfo().get(n);
		
		if (file != null && file.get("error") == 0)
		{
			if (FileSystem.exists(file.get("tmp_name")))
			{
				// delete previous uploaded file
				var oldfile = keepFullFileName ? previous : toFolder + previous;
				if (previous != null && previous != "" && FileSystem.exists(oldfile))
				{
					FileSystem.deleteFile(oldfile);
				}
				
				// move upladed file to toFolder
				var newname = Md5.encode(Timer.stamp() + file.get("name")) + file.get("name");
				
				PhpTools.moveFile(file.get("tmp_name"), toFolder+newname);
				
				value = keepFullFileName ? toFolder+newname : newname;
			}
		} 
		else if (previous != null) 
		{
			// no upload- remember previous value
			value = previous;
		}
	}
	
	override public function render(?iter:Int):String
	{
		var n = name;
		//TODO
	//	var path = toFolder.substr((Poko.instance.config.applicationPath + "res/").length);
		var path = toFolder.substr((MyController.appConfig.runtimePath + "res/").length);
		
		var str:String = "";
		
		str += '<span class="fileName">'+getOriginalFileName()+'</span><br/>';
		str += '<input type="file" name="' + n + '" id="' + n + '" ' + attributes + ' />';
		str += '<input type="hidden" name="' + n + '__previous" id="' + n + '__previous" value="'+value+'"/>';
		
		return str;
	}
	
	/* 
	 * Contains MD5 and original filename.
	 */
	public function getFileName()
	{
		if (keepFullFileName)
		{
			var s = Std.string(value);
			return s.substr(s.lastIndexOf("/") + 1);
		} else {
			return value;
		}	
	}
	
	/* 
	 * Orginal filename.
	 */
	public function getOriginalFileName()
	{
		if (keepFullFileName)
		{
			var s = Std.string(value);
			return s.substr(s.lastIndexOf("/") + 33);
		} else {
			return Std.string(value).substr(33);
		}	
	}
	
	public function toString() :String
	{
		return render();
	}
	
}

