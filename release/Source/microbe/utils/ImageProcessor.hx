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

package microbe.utils;

import haxe.Md5;
import microbe.utils.GD;
import php.FileSystem;
import php.io.File;
import php.Lib;
import php.Sys;
import php.Web;

class ImageProcessor 
{
	private static var revision = "0.1";
	
	private var fileName:String;
	public var resource:ImageResource;
	
	public var queue:List<Dynamic>;
	
	public var forceNoCache:Bool;
	private var cache:Bool;
	public var cacheFolder:String;
	
	public var quality:Float;
	public var format:ImageOutputFormat;
	
	public var hash:String;
	public var dateModified:Date;
	
	public var saveAlpha:Bool;
	
	public function new(file:String) 
	{
		fileName = file;
		queue = new List();
		cache = true;
		cacheFolder = "./cache";
		forceNoCache = false;
		
		saveAlpha = false;
		
		quality =  .8;
		format = ImageOutputFormat.JPG;
		
		hash = getHash();
		
		//var fname = fileName.lastIndexOf("/");
		
		resource = switch(getFileFormat(file))
		{
			case ImageOutputFormat.JPG: GD.imageCreateFromJpeg(file);
			case ImageOutputFormat.GIF: GD.imageCreateFromGif(file);
			case ImageOutputFormat.PNG: GD.imageCreateFromPng(file);
		}
		
		if(resource == null) throw("Could not load image");
	}
	
	public function getWidth():Int
	{
		return GD.imageSX(resource);
	}
	
	public function getHeight():Int
	{
		return GD.imageSY(resource);
	}
	
	public function queueFitSize(maxWidth:Int, maxHeight:Int)
	{
		queue.add( { type:ImageAction.FIT, maxWidth:maxWidth, maxHeight:maxHeight } );
	}
	
	public function queueCropToAspect(w:Float, h:Float)
	{
		queue.add( { type:ImageAction.ASPECT, w:w, h:h } );
	}
	
	public function queueCrop(x:Int, y:Int, width:Int, height:Int)
	{
		queue.add( { type:ImageAction.CROP, x:x, y:y, width:width, height:height } );
	}
	
	public function queueResize(width:Int, height:Int)
	{
		queue.add( { type:ImageAction.RESIZE, width:width, height:height } );
	}
	
	public function queueScale(scaleX:Float, scaleY:Float)
	{
		queue.add( { type:ImageAction.SCALE, scaleX:scaleX, scaleY:scaleY } );
	}
	
	public function queueRotate(?CW:Bool = true)
	{
		queue.add( { type:ImageAction.ROTATE, CW:CW } );
	}
	
	public function queueCustom(func:Void->Void, cacheIdentifier:String)
	{
		queue.add( { type:ImageAction.CUSTOM, func:func, cacheIdentifier:cacheIdentifier } );
	}
	
	public function applyFitSize(maxWidth:Int, maxHeight:Int)
	{
		var ow:Int = GD.imageSX(resource);
		var oh:Int = GD.imageSY(resource);
		
		var scale:Float = 1;
		
		if (ow > maxWidth) scale = maxWidth / ow;
		if (oh*scale > maxHeight) scale *= maxHeight/(oh*scale);
		
		var nw:Int = Std.int(ow * scale);
		var nh:Int = Std.int(oh * scale);
		if (nw < 1) nw = 1;
		if (nh < 1) nh = 1;
		
		var newResource:ImageResource = GD.imageCreateTrueColor(nw, nh);
		
		if( saveAlpha==true){
       GD.imageAlphaBlending(newResource, false);
       GD.imageSaveAlpha(newResource,true);
       var transparent = GD.imageColorAllocateAlpha(newResource, 255, 255, 255, 127);
       GD.imageFilledRectangle(newResource, 0, 0, nw, nh, transparent);
		}
		
		var success = GD.imageCopyResampled(newResource, resource, 0, 0, 0, 0, nw, nh, ow, oh);
		if (!success) throw("There was an error resizing the image");
		
		resource = newResource;
	}
	
	public function applyCropToAspect(w:Float, h:Float)
	{
		var ow:Int = GD.imageSX(resource);
		var oh:Int = GD.imageSY(resource);
		var oaspect:Float = ow / oh;
		var taspect:Float = w / h;
		var nh:Int = oh;
		var nw:Int = ow;
		
		if (taspect > oaspect) {
			nh = Std.int(1/taspect * ow);
		} else {
			nw = Std.int(taspect * oh);
		}
		if (nw < 1) nw = 1;
		if (nh < 1) nh = 1;
		
		var newResource:ImageResource = GD.imageCreateTrueColor(nw, nh);
		
		if( saveAlpha==true){
       GD.imageAlphaBlending(newResource, false);
       GD.imageSaveAlpha(newResource,true);
       var transparent = GD.imageColorAllocateAlpha(newResource, 255, 255, 255, 127);
       GD.imageFilledRectangle(newResource, 0, 0, nw, nh, transparent);
		}
		
		var success = GD.imageCopyResampled(newResource, resource, 0, 0, Std.int((ow - nw) / 2), Std.int((oh - nh) / 2), nw, nh, nw, nh);
		if (!success) throw("There was an error cropping the image to aspect");
		
		resource = newResource;
	}

	public function applyCrop(x:Int, y:Int, width:Int, height:Int)
	{		
		var newResource:ImageResource = GD.imageCreateTrueColor(width, height);
		
		var success = GD.imageCopyResampled(newResource, resource, 0, 0, x, y, width, height, width, height);
		if (!success) throw("There was an error cropping the image to aspect");
		
		resource = newResource;
	}
	
	public function applyResize(width:Int, height:Int)
	{
		var ow:Int = GD.imageSX(resource);
		var oh:Int = GD.imageSY(resource);
		
		var newResource:ImageResource = GD.imageCreateTrueColor(width, height);
		
		var success = GD.imageCopyResampled(newResource, resource, 0, 0, 0, 0, width, height, ow, oh);
		if (!success) throw("There was an error resizing the image");
		
		resource = newResource;
	}
	
	public function applyScale(scaleX:Float, scaleY:Float)
	{
		var ow:Int = GD.imageSX(resource);
		var oh:Int = GD.imageSY(resource);
		var nw:Int = Std.int(ow * scaleX);
		var nh:Int = Std.int(oh * scaleY);
		if (nw < 1) nw = 1;
		if (nh < 1) nh = 1;
		
		var newResource:ImageResource = GD.imageCreateTrueColor(nw, nh);
		if( saveAlpha==true){
       GD.imageAlphaBlending(newResource, false);
       GD.imageSaveAlpha(newResource,true);
       var transparent = GD.imageColorAllocateAlpha(newResource, 255, 255, 255, 127);
       GD.imageFilledRectangle(newResource, 0, 0, nw, nh, transparent);
		}
		var success = GD.imageCopyResampled(newResource, resource, 0, 0, 0, 0, nw, nh, ow, oh);
		if (!success) throw("There was an error applying scale to the image");
		
		resource = newResource;
	}
	
	public function applyRotation(angle:Float, ?CW:Bool = true, ?bgcolor:Int = 0, ?transparentBg:Bool=false )
	{
		resource = GD.imageRotate(resource, CW ? angle : angle *-1, bgcolor, transparentBg ? 1 : 0);
	}
	
	public function applyCustom(func:ImageResource->Void, cacheIdentifier:String)
	{
		Reflect.callMethod(null, func, []);
	}
	
	public function processQueue() 
	{
		for (action in queue)
		{
			switch(action.type) 
			{
				case ImageAction.FIT: applyFitSize(action.maxWidth, action.maxHeight);
				case ImageAction.ASPECT: applyCropToAspect(action.w, action.h);
				case ImageAction.RESIZE: applyResize(action.width, action.height);
				case ImageAction.SCALE: applyScale(action.scaleX, action.scaleY);
				case ImageAction.CROP: applyCrop(action.x, action.y, action.width, action.height);
				case ImageAction.ROTATE: applyRotation(action.angle, action.CW, action.bgcolor, action.transparent);
				case ImageAction.CUSTOM: applyCustom(action.func, action.cacheIdentifier);
			}
		}
		
		queue.clear();
	}
	
	public function getFileFormat(file:String):ImageOutputFormat
	{
		var ext = file.substr(file.lastIndexOf(".") + 1).toLowerCase();
		
		return switch(ext) 
		{
			case "jpg", "jpeg": ImageOutputFormat.JPG;
			case "gif": ImageOutputFormat.GIF;
			case "png": ImageOutputFormat.PNG;
		}
	}
	
	private function getHash():String
	{
		var s:String = fileName;
		for (action in queue)
			for (field in Reflect.fields(action))
				s += "&" + field + "=" + Reflect.field(action, field);
		
		var stat:FileStat = FileSystem.stat(fileName);
		
		s += "&" + stat.mtime + "&" + stat.ctime + "&" + revision + quality + (saveAlpha ? 1 : 0);
		
		//trace(s);
		var hash = Md5.encode(s);
		dateModified = stat.mtime;
		
		return hash;
	}
	
	private function output():String
	{
		untyped __call__("ob_start");
		
		switch(format) 
		{
			case ImageOutputFormat.GIF: GD.imageGif(resource);
			case ImageOutputFormat.JPG: GD.imageJpeg(resource, null, Std.int(quality * 100));
			case ImageOutputFormat.PNG: GD.imagePng(resource);
		}
		
		var out = untyped __call__("ob_get_contents");
		untyped __call__("ob_end_clean");
		return out;
	}
	
	public function getCacheName()
	{
		var hash = getHash();
		var ext = switch(format) 
		{
			//case ImageOutputFormat.GIF: "GIF";
			//case ImageOutputFormat.JPG: "JPG";
			//case ImageOutputFormat.PNG: "PNG";
			case ImageOutputFormat.GIF: "gif";
			case ImageOutputFormat.JPG: "jpg";
			case ImageOutputFormat.PNG: "png";
		}
		
		return hash + "." + ext;
	}
	
	
		
		
		
	
	
	public function getOutput(flush:Bool = false):String
	{
		if (cache && !forceNoCache) 
		{
			var cacheFile = cacheFolder + "/" + getCacheName();
			if (FileSystem.exists(cacheFile))
			{
				return File.getContent(cacheFile);
			}
			else 
			{
				if (saveAlpha) GD.imageSaveAlpha(resource, true);
				
				if (!queue.isEmpty()) processQueue();
				
				var output = output();
				
				File.putContent(cacheFile, output);
				
				return output;
			}
		} 
		else 
		{
			//trace(
			if (!queue.isEmpty()) processQueue();
			
			return output();
		}
	}
	
	public function flushOutput():Void
	{
		var cacheName = getCacheName();
		var cacheFile = cacheFolder + "/" + cacheName;
		
		Web.setHeader("content-type", "image");
		
		/*Web.setHeader("Expires", "");
		Web.setHeader("Cache-Control", "");
		Web.setHeader("Pragma", "");*/
		
		Web.setHeader("Content-Transfer-Encoding", "binary");
		
		if (FileSystem.exists(cacheFile))
		{
			Web.setHeader("Content-Disposition", "inline; filename=" + cacheName);
			//Web.setHeader("Etag", cacheName);
			
			#if php
				Web.setHeader("Content-Length", untyped __call__("filesize", cacheFile));
				untyped __call__("readfile", cacheFile);
				Sys.exit(1);
			#else
				Lib.print(File.getContent(cacheFile));
			#end			
		} else {
			Lib.print(getOutput());
		}	
		Sys.exit(1);
	}
	
}

enum ImageOutputFormat
{
	JPG;
	PNG;
	GIF;
}

enum ImageAction
{
	CUSTOM;
	FIT;
	ASPECT;
	RESIZE;
	SCALE;
	CROP;
	ROTATE;
}