package;

class MicrobeConfig
{
	
	//http://www.postite.com
	public static var siteDomain:String="http://cluster003.ovh.net";
	
	//postite.com/postite.com/projet
	//ex :public static var siteRoot:String=siteDomain+"/projet";
	public static var siteRoot:String=siteDomain+"/~mellecre";
	
	
	
	//postite.com/postite.com/?projet/
	public static var indexPath:String=siteRoot+"/";
	
	//postite.com/postite.com/?projet/index.php
	public static var index:String=indexPath+"index.php";
	
	//postite.com/postite.com/?projet/index.php/myfront
	public static var frontPath:String=index+"/myfront";
	
	//postite.com/postite.com/?projet/index.php/myfront
	public static var backPath:String=index+"/pipo";
	
	public static var imageProcessing:String=index+"/imageBase/resize";
	//postite.com/?projet/css
	public static var cssPath:String=siteRoot+indexPath+"css";
	
	//postite.com/?projet/js
	public static var jsPath:String=indexPath+"js";
	
	//postite.com/?projet/microbe
	public static var microbePath:String=indexPath+"microbe";
	
	//postite.com/?projet/microbe/js
	public static var microbeJsPath:String=microbePath+"/js";
	
	//postite.com/?projet/microbe/css
	public static var microbeCssPath:String=microbePath+"/css";
	
	//postite.com/?projet/microbe/css
	public static var microbeBackjs:String="backjs.js";
	
	//postite.com/?projet/views
	public static var viewsPath:String=indexPath+"/views";
	
	//postite.com/?projet/views/back
	public static var backViewsPath:String=viewsPath+"/back";
	
	//postite.com/?projet/views/front
	public static var frontViewsPath:String=viewsPath+"/front";
	
	//postite.com/?projet/runtime
	public static var runtimePath:String=indexPath+"/runtime";
	
	//postite.com/?projet/runtime/cache
	public static var cachePath:String=runtimePath+"/cache";
	
	//postite.com/?projet/uploads
	public static var uploadPath:String=indexPath+"/uploads";
		
	//postite.com/?projet/uploads/images
	public static var imagesPath:String=uploadPath+"/images";
	
	
	//postite.com/?projet/assets
	public static var assetsPath:String=indexPath+"/assets";
	
	//postite.com/?projet/views
	public static var externalPath:String=indexPath+"/external";
	
	public static var voPackage:String="vo.";
}