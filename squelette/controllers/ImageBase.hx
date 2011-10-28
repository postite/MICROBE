package controllers;
import microbe.controllers.GenericController;
import haxigniter.server.content.ContentHandler;
import haxigniter.server.request.BasicHandler;
import config.Config;

import haxe.Md5;
import microbe.utils.ImageProcessor;
import poko.utils.PhpTools;
import php.FileSystem;
import php.io.File;
import php.io.Process;
import php.Lib;
import php.Sys;
import php.Web;

/**
 * ...
 * @author postite
 */

class ImageBase extends GenericController
{
	public var data:Dynamic;
	public var upfolder:String;
	public function new() 
	{
		super();
		//upfolder = MyController.appConfig.runtimePath + "/res/";
		//upfolder = "runtime/" + "res/";
		var configuration:Config= new Config();
	//	upfolder="uploads/images/";
		upfolder=configuration.imagesPath;
		this.requestHandler = new BasicHandler(this.configuration);
		
	}
	
	public function resize(?preset:String, ?src:String,?w:String,?h:String) {
		
	
	//var src:String = Web.getParams().get("src");
		
		if ( preset!=null )
		{
			// Create a new image processor.
			var image : ImageProcessor 	= new ImageProcessor( upfolder + src );
			image.cacheFolder 			= upfolder + "cache";
			image.format 				= image.getFileFormat(src);
			//image.forceNoCache 			= true;
			
			// Resize image. Subclasses should override this method.
			resizeImage( preset, image,w,h );
			
			// Get binary output.
			var imageStr = image.getOutput();
			var filename = image.cacheFolder + "/" + image.getCacheName();
			// Attempt to get the actual reported filesize on disk if available, else use the 
			// size of the string which should also return number of bytes because it is in binary format.
			var length = FileSystem.exists(filename) ? untyped __call__("filesize", filename) : Std.string(imageStr.length);
			
			// Set content headers.
			setHeaders( image.dateModified, length, image.hash );
			
			// Finally output the image.
			Lib.print( imageStr );
		}
		else
		{
			var dateModified = FileSystem.stat(upfolder + src).mtime;
			
			#if php
				var length = untyped __call__("filesize", upfolder + src);
				// Set content headers.
				setHeaders( dateModified, length, Md5.encode(src));
				// Finally output the image.
				untyped __call__("readfile", upfolder + src);
				Sys.exit(1);
			#else
				var f = File.getContent(upfolder + src);
				// Set content headers.
				setHeaders( dateModified, Std.string(f.length), Md5.encode(src) );
				// Finally output the image.
				Lib.print( f );
			#end
		}
	}
	
	function resizeImage( preset : String, image : ImageProcessor,?w:String,?h:String ) : Void
	{
		//trace("imageformat=" + image.format);
		if (image.format == ImageOutputFormat.PNG) { image.saveAlpha = true; } else { image.saveAlpha = false; };
		
		switch(preset)
		{
			case "slim":
			
			image.queueResize(300, 300);
			image.queueCropToAspect(300, 60);
			
			case "tiny":
				image.queueFitSize(40, 40);
				
			case "thumb":
				image.queueCropToAspect(100, 100);
				image.queueFitSize(100, 100);
				
			case "aspect": 
				var w:Int = Std.parseInt(w);
				var h:Int = Std.parseInt(h);
				image.queueCropToAspect(w, h);
				
			case "custom": 
				var w:Int = Std.parseInt(w);
				var h:Int = Std.parseInt(h);
				image.queueFitSize(w, h);
				
			case "gallery":
				image.queueFitSize(300, 300);
			
			case "modele":
				image.queueFitSize(260, 350);
				
			case "variante":
			image.queueCropToAspect(70, 70);
			image.queueFitSize(70, 70);
				
				case "big":
				image.applyFitSize(1000, 1000);
				
			//case "trans":
			//image.format = ImageOutputFormat.PNG;
			//image.saveAlpha = true;
			//image.queueFitSize(100, 100);
				
		}
	}
	
	function setHeaders( dateModified : Date, length : String, hash : String ):Void
	{
		Web.setHeader("Last-Modified", DateTools.format(dateModified, "%a, %d %b %Y %H:%M:%S") + ' GMT' );
		Web.setHeader("Expires", DateTools.format(new Date(dateModified.getFullYear() + 1, dateModified.getMonth(), dateModified.getDay(), 0, 0, 0), "%a, %d %b %Y %H:%M:%S") + ' GMT');
		Web.setHeader("Cache-Control" ,"public, max-age=31536000");
		Web.setHeader("ETag", "\"" + hash + "\"");
		Web.setHeader("Pragma", "");
		Web.setHeader("Content-type", "image");
		Web.setHeader("Content-Length", length);
		
		/*Web.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        Web.setHeader("Pragma", "no-cache");
        Web.setHeader("Expires", "-1");
		Web.setHeader("Content-type", "image/jpeg");*/
		
	}
	
}