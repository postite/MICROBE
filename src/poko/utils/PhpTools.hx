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

package poko.utils;

import php.Lib;
import php.NativeArray;
import php.Sys;
import php.Web;

class PhpTools
{
	
	public static function pf(obj:Dynamic):Void
	{
		Lib.print("<pre>");
		untyped __call__("print_r", obj);
		Lib.print("</pre>");
	}
	
	public static function setupTrace()
	{
		var f = haxe.Log.trace;
		
		haxe.Log.trace = function(v, ?pos) 
		{ 
			f(v, pos);
			
			Lib.print("<br />");
			//Lib.print("<script> console.log(\""+v+"\") </script>");
		}
		
	}
	
	public static function mail(to:String, subject:String, message:String, ?headers:String="", ?additionalParameters:String=""):Void
	{
		untyped __call__("mail", to, subject, message, headers, additionalParameters);	
	}
	
	public static function moveFile(filename:String, destination):Void
	{
		var success = untyped __call__("move_uploaded_file",  filename, destination);
		
		if (!success)
			throw "Error uploading '" + filename + "' to '" + destination + "'";
	}
	
	public static function getFilesInfo():Hash <Hash<Dynamic>>
	{
		var files:Hash<NativeArray> = php.Lib.hashOfAssociativeArray(untyped __php__("$_FILES"));
		var output:Hash < Hash < String >> = new Hash();
		
		for (file in files.keys())
			output.set(file, php.Lib.hashOfAssociativeArray(files.get(file)));	
		
		return output;
	}
	
	
	
}