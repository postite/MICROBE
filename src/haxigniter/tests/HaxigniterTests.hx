package haxigniter.tests;

import haxigniter.tests.unit.When_UnitTesting_With_TestCase;
import haxigniter.tests.unit.When_using_a_TypeFactory;
import haxigniter.tests.unit.When_using_a_FieldValidator;
import haxigniter.tests.unit.When_using_Controllers;

import haxigniter.tests.unit.When_using_library_Url;
import haxigniter.tests.unit.When_using_library_Database;
import haxigniter.tests.unit.When_using_library_Input;
import haxigniter.tests.unit.When_using_library_Inflection;
import haxigniter.tests.unit.When_using_library_Server;

import haxigniter.tests.unit.When_using_RestApiParser;
import haxigniter.tests.unit.When_using_RestApiController;
import haxigniter.tests.unit.When_using_RestApiSqlRequestHandler;
import haxigniter.tests.unit.When_using_RestApiConfigSecurityHandler;

import haxigniter.tests.unit.given_the_routing_system.When_using_Alias;
import haxigniter.tests.unit.given_a_requesthandlerdecorator.When_using_HaxeRequestDecorator;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#end

/**
 * haXigniter framework tests.
 * Run by executing "./package.sh test" in a shell.
 */
class HaxigniterTests extends haxigniter.common.unit.TestRunner
{
	// Can also be run from PHP with this:
	//new haxigniter.tests.HaxigniterTests().runAndDisplay();
	
	public function new(?htmlOutput = true)
	{
		super(htmlOutput);

		this.add(new When_UnitTesting_With_TestCase());
		this.add(new When_using_a_TypeFactory());
		this.add(new When_using_Controllers());
		
		this.add(new When_using_library_Database());
		this.add(new When_using_library_Url());
		this.add(new When_using_library_Input());
		this.add(new When_using_library_Inflection());
		this.add(new When_using_library_Server());
		
		this.add(new When_using_RestApiParser());
		this.add(new When_using_RestApiController());
		this.add(new When_using_RestApiSqlRequestHandler());
		this.add(new When_using_RestApiConfigSecurityHandler());
		
		this.add(new When_using_a_FieldValidator());
		this.add(new When_using_Alias());
		
		this.add(new When_using_HaxeRequestDecorator());
	}
}
