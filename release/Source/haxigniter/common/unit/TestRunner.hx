package haxigniter.common.unit;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#end

class TestRunner extends haxe.unit.TestRunner
{
	static var errorTest : EReg = ~/\b[1-9]\d* failed\b/;
	
	public var htmlOutput : Bool;
	private var output : String;
	
	public function new(?htmlOutput = true)
	{
		this.htmlOutput = htmlOutput;
		
		// Rebind the print method to capture output.
		var self = this;
		haxe.unit.TestRunner.print = function(v : Dynamic)
		{
			self.output += v;
		}

		super();
	}
	
	public function runTests() : String
	{
		this.output = '';
		this.run();

		if(htmlOutput)
		{
			var color = errorTest.match(this.output) ? 'red' : 'green';
			return '<pre style="border:1px dashed ' + color + '; padding:5px; background-color:#F2F0EE;">' + this.output + '</pre>';
		}
		else
			return this.output;
	}

	#if (php || neko)
	public function runAndDisplay() : Void
	{
		Lib.print(this.runTests());
	}
	
	public function runAndDisplayOnError() : Void
	{
		var output = this.runTests();
		if(!errorTest.match(output)) return;
		
		Lib.print(output);
	}
	#end
}
