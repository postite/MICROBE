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

class RichtextWym extends FormElement
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
		var n = form.name + "_" +name;
		
		editorStyles = StringTools.replace(editorStyles, "\n", " ");
		editorStyles = StringTools.replace(editorStyles, "\r", " ");
		
		var str:StringBuf = new StringBuf();
		str.add("\n <textarea name=\"" + n + "\" id=\"" + n + "\" >" + value + "</textarea>");
		str.add("<script type=\"text/javascript\">");
		str.add("jQuery(function() {");
		str.add("	jQuery('#" + n + "').wymeditor({");
		str.add("logoHtml: '',");
		//str.add("		stylesheet: './css/site.css',");
		str.add("editorStyles: [\"" + editorStyles + "\"],");
		str.add("skin:'compact',");
		str.add("postInit: function(wym) {");
		str.add("	jQuery(wym._box).find(wym._options.containersSelector).removeClass('wym_dropdown').addClass('wym_panel').find('h2 > span').remove();");
		str.add("	jQuery(wym._box).find(wym._options.iframeSelector).css('height', '"+height+"px').css('width', '"+width+"px');");
		str.add("},");
		str.add("toolsItems: [");
		str.add("	{'name': 'Bold', 'title': 'Strong', 'css': 'wym_tools_strong'}, ");
		str.add("	{'name': 'Italic', 'title': 'Emphasis', 'css': 'wym_tools_emphasis'},");
		str.add("	{'name': 'CreateLink', 'title': 'Link', 'css': 'wym_tools_link'},");
		str.add("	{'name': 'Unlink', 'title': 'Unlink', 'css': 'wym_tools_unlink'},");
		if(allowImages) str.add("{'name': 'InsertImage', 'title': 'Image', 'css': 'wym_tools_image'},");
		str.add("	{'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'},");
		str.add("	{'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'},");
		if(allowTables) str.add("{'name': 'InsertTable', 'title': 'Table', 'css': 'wym_tools_table'},");
		str.add("	{'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'},");
		str.add("	{'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'},");
		str.add("	{'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'},");
		str.add("	{'name': 'ToggleHtml', 'title': 'HTML', 'css': 'wym_tools_html'}");
		str.add("],");
		str.add("containersItems: [" + containersItems + "],");
		if (classesItems != "") {
			str.add("classesItems: [" + classesItems + "],");
		}else {
			str.add("classesHtml: '',");
		}
		str.add("postInitDialog: function (wym, wdw) { if(wymeditor_filebrowser != null) wymeditor_filebrowser(wym, wdw); }");
		str.add("	});");
		str.add("});");		
		str.add("</script>");
		
		if (!isValid()) str.add(" required");
		
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

class RichtextWym extends AjaxElement
{
	public static var self:RichtextWym;
	public var formDefaultAction:String;
	private var base_url:String;
	
	public function new(_microfield:Microfield)
	{
	super(_microfield);
	self=this;
	//attention pas CDN proof!
	base_url=Lib.window.location.protocol+"//"+Lib.window.location.host;
	
	//new JQuery("#uploadButton").click(function(e):Void{self.testUpload(e);});
	}

	
	override public function getValue():String{
		//Lib.alert("op");
		//Lib.alert(untyped __js__("wym()"));
		return  untyped __js__("wym.html");
		//return "popopop";
	//	return new JQuery("#"+id);
	}
	override public function output() : String {
		return "yeah from js";
	}
	override public function setValue(val:String):Void{
		untyped __js__("wym.html("+val+")");
	}
	
}
#end