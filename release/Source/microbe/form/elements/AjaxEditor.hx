package microbe.form.elements;

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


#if php

import microbe.form.Form;
import microbe.form.FormElement;

class AjaxEditor extends FormElement
{
	public var width:Float;
	public var height:Float;
	public var allowImages:Bool;
	public var allowTables:Bool;
	public var editorStyles:String;
	public var containersItems:String;
	public var classesItems:String;
	
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?attibutes:String="") 
	{
		super();
		this.name = name;
		this.label = label;
		this.value = value;
		this.required = required;
		this.attributes = attibutes;
		
		width = 500;
		height = 300;
		
		allowImages = true;
		allowTables = false;
		editorStyles = "";
		containersItems = "";
		classesItems = "";
	}
	
	override public function render(?iter:Int):String
	{
		var n = name;
		
	//	editorStyles = StringTools.replace(editorStyles, "\n", " ");
	//	editorStyles = StringTools.replace(editorStyles, "\r", " ");
var str:StringBuf = new StringBuf();
		str.add("\n <textarea name=\"" + n + "\" trans='pop' id=\"" + n + "\" class=\"editor\">" + value + "</textarea>");
		
		
		
		return str.toString();
	}
	
	public function toString() :String
	{
		return render();
	}
	
}
#end

#if js

import js.Lib;
import js.JQuery;
import js.Dom;
import microbe.form.AjaxElement;
import microbe.form.Microfield;
import postite.jquery.editor.wymeditor.Wymeditor;
import haxe.Timer;
class AjaxEditor extends AjaxElement
{
	
	public static var self:AjaxEditor;
	public var formDefaultAction:String;
	private var base_url:String;
	//private var wym:Dynamic;
	var t:haxe.Timer;
	var ed:String;
	public var wym:Wymeditor;
	public var wymOptions:WymOptions;
	var transformed:Bool;
	public function new(_microfield:Microfield,?iter:Int)
	{
	//Lib.alert("new editor" +_microfield);
	//super(_microfield);
	super(_microfield);
	//Lib.alert("new super(_microfield)");
	this.pos=iter;
	self=this;
	ed="editor";
	trace("new wym");
	//Lib.alert("value");
	//attention pas CDN proof!
	base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
	
	//str.add("\n <textarea name=\"" + n + "\" id=\"" + n + "\" >" + value + "</textarea>");
	
	//untyped __js__ ("new jQuery('.editor').wymeditor();");
	
	//new JQuery(".editor").wymeditor();
	
///// attention double les editeurs si plusieurs instances
// untyped __js__("
	
// 	new jQuery(
		
// 		function()
// 		 {	
// 	    	var wym=new jQuery('.editor:visible').wymeditor
// 			(
// 				{
// 					//html:'value'
// 					skin:'compact'
// 				}
// 			);	
// 			//wym.update();
// 		}
// 		);"	
		
// 	); 
		//Lib.alert("before options");
		wymOptions= cast {};
		wymOptions.skin="compact";
		wymOptions.html=value;
		//Lib.alert("before wym");
		wym= new Wymeditor(".editor:visible");
		trace("after new wym");
		//Lib.alert("before"+"wymeditor()");
		//wym.wymeditor(wymOptions);
		//Lib.alert("new"+wym);
}

	override public function getValue():String{
	//	untyped __js__("jQuery.wymeditors(0).update();");
//	//Lib.alert("wym="+wym.update());
	//	wym.update();
	// untyped __js__("var i = 0; 
	// 				while ( jQuery != null ) { 
	// 					var wym = jQuery.wymeditors(i); 
	// 						if ( wym != null ) {
	// 							wym.update(); 
	// 							i++; } 
	// 							else {	break; }};"
	// 			);

	trace("wym");
	wym.wymeditors(0).update();

	return new JQuery("#"+id).attr("value");
	}
	override public function output() : String {
		return "yeah from js";
	}
	override public function setValue(val:String):Void{
		trace("set wym");
	new JQuery("#"+id).attr("value",val);
	
	 //t=new Timer(500);
	// t.run=waitForIt;


	t=Timer.delay(callback(waitForIt,val),500);
	}

	function waitForIt(?val:String="") 
	{
		
		if (wym!=null){
						
			wymOptions.html=val.toString();
			wym.wymeditor(wymOptions);

			t.stop();
			//wym.wymeditors(0).update();

			
		}else{
			Lib.alert("else");
			t=Timer.delay(callback(waitForIt,val),500);
		}

	
	}
}
#end