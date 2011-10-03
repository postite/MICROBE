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

import microbe.form.Form;
import microbe.form.FormElement;
import microbe.form.Validator;
import microbe.form.validators.BoolValidator;
import microbe.form.Formatter;

using StringTools;

class Input extends FormElement
{
	public var password:Bool;
	public var width:Int;
	public var showLabelAsDefaultValue:Bool;
	public var useSizeValues:Bool;
	public var printRequired:Bool;
	
	public var formatter:Formatter;
	
	public function new(name:String, label:String, ?value:String, ?required:Bool=false, ?validators=null, ?attributes:String="") 
	{
		super();
		this.name = name;
		this.label = label;
		this.value = value;
		this.required = required;
		this.attributes = attributes;
		this.password = false;
		
		showLabelAsDefaultValue = false;
		useSizeValues = false;
		printRequired = false;
		
		width = 180;
	}
	
	override public function render(?iter:Int):String
	{		
		var n = name;
		var tType:String = password ? "password" : "text";
		
		if (showLabelAsDefaultValue && value == label){
			addValidator(new BoolValidator(false, "Not valid"));
		}
		
		if ((value == null || value == "") && showLabelAsDefaultValue) {
			value = label;
		}		
		
		var style = useSizeValues ? "style=\"width:" + width + "px\"" : "";
		return "<input "+style+" class=\""+ getClasses() +"\" type=\""+tType+"\" name=\""+n+"\" id=\""+n+"\" value=\"" +safeString(value)+ "\"  "+attributes+" />" + (if(required && form.isSubmitted() && printRequired) " required");
	}
	
	public function toString() :String
	{
		return render();
	}
}

