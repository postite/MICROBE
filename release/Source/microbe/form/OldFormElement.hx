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

package microbe.form;

//import poko.Poko;
//import poko.js.JsBinding;
//import poko.utils.PhpTools;
#if php import php.Web; #end

using StringTools;

class FormElement
{		
	public var form:Form;
	public var name:String;
	public var label:String;
	public var description:String;
	public var value:Dynamic;
	public var required:Bool;
	public var errors:List<String>;
	public var attributes:String;
	public var active:Bool;
	public var validators:List<Validator>;
	public var cssClass:String;
	public var inited:Bool;
	
	public function new() 
	{
		active = true;
		errors = new List();
		validators = new List();
		
		inited = false;
	}
	
	public function isValid():Bool
	{
		errors.clear();
				
				if (active == false)
					return true;
				
				if (value == "" && required) 
				{
					//errors.add("Please enter '" + ((label != null && label != "") ? label : name) + "'");
					errors.add("<span class=\"formErrorsField\">" + ((label != null && label != "") ? label : name) + "</span> required.");
					return false;
				} 
				else if(value != "")
				{
					if (!validators.isEmpty())
					{
						var pass:Bool = true;
						for (validator in validators)
						{
							if (!validator.isValid(value)) {
								//for (error in validator.errors)
								//	errors.add(error);
								
								pass = false;
							}
						}
						if (!pass) return false;
					}
					
					return true;
				}
		return true;
	}
	
	public function checkValid()
	{
		value == "";
	}
	
	
	public function init()
	{
		inited = true;
	}
	
	public function addValidator(validator:Validator)
	{
		validators.add(validator);
	}
	
	public function bindEvent(event:String, method:String, params:Array<Dynamic>, ?isMethodGlobal:Bool=false) 
	{
		//Poko.instance.request.jsBindings.add(new JsBinding(form.name + "_" + name, event, method, params, isMethodGlobal));
	}
	
	public function populate():Void
	{
		#if php
		if (!inited)
			init();
	
		var n = form.name + "_" + name;
		
		// tentative d'implementation
		 var v=php.Web.getParams().get(n);
		if (v != null) value = v;
		//Todo implementer avec haxigniter
		/*var v = Poko.instance.params.get(n);
				
				if (v != null) value = v;*/
				#end
	}

	public function getErrors():List<String>
	{
		isValid();
		
		for (val in validators)
			for(err in val.errors)
				errors.add("<span class=\"formErrorsField\">" + label + "</span> : " + err);
		
		return errors;
	}
	
	public function render(?iter:Int):String
	{
		if (!inited)
			init();
			
		return value;
	}
	
	public function remove():Bool
	{
		if ( form != null )
		{
			return form.removeElement(this);
		}
		return false;
	}
	
	/*public function getPreview():String
		{
			return "<tr><td>" + getLabel() + "</td><td>" + this.render() + "<td></tr>";
		}*/
	public function getPreview():String{
		return "<li><span>" + getLabel() + "</span><div>" + this.render() + "</div></li>";
	}
	
	public function getType():String
	{
		return Std.string(Type.getClass(this));
	}
	
	public function getLabelClasses() : String
	{
		var css = "";
		var requiredSet = false;
		if (required) {
			css = form.requiredClass;
			if (form.isSubmitted() && required && value == "") {
				css = form.requiredErrorClass;
				requiredSet = true;
			}
		}
		if(!requiredSet && form.isSubmitted() && !isValid()){
			css = form.invalidErrorClass;
		}
		
		if ( cssClass != null )
			css += ( css == "" ) ? cssClass : " " + cssClass;
			
		return css;
	}
	
	public function getLabel():String
	{
		var n = form.name + "_" + name;
	
		return "<label for=\"" + n + "\" class=\""+getLabelClasses()+"\" id=\"" + n + "Label\">" + label +(if(required) form.labelRequiredIndicator) +"</label>";
	}
	
	public function getClasses() : String
	{
		var css = ( cssClass != null ) ? cssClass : form.defaultClass;
		
		if ( required && form.isSubmitted() )
		{
			if ( value == "" )
				css += " " + form.requiredErrorClass;
			if ( !isValid() )
				css += " " + form.invalidErrorClass;
		}
		
		return css.trim();
	}
	
	
	public function test():String{
		this.init();
		return "popoop"+form.name;
	}
	
	private inline function safeString(s:Dynamic) {
		return s == null ? "" : Std.string(s).htmlEscape().split('"').join("&quot;");
	}
}