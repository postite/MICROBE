package haxigniter.tests.mocks;

import haxigniter.server.libraries.Database;

#if php
import php.db.Connection;
import php.db.ResultSet;
#elseif neko
import neko.db.Connection;
import neko.db.ResultSet;
#end

class MockConnection implements Connection
{
	public var queries : Array<String>;
	public var mockResults : Array<Array<Dynamic>>;
	public var mockError : String;
	
	public function new()
	{
		mockResults = new Array<Array<Dynamic>>();
		queries = new Array<String>();
	}
	
	public function close() : Void {}
	public function commit() : Void {}
	public function dbName() : String { return 'mockdb'; }
	public function escape( s : String ) : String { return 'E*' + s + '*E'; }
	public function lastInsertId() : Int { return 0; }
	public function quote( s : String ) : String { return 'Q*' + s + '*Q'; }
	public function addValue( s : StringBuf, v : Dynamic ) {}
	
	public function request( sql : String ) : ResultSet
	{
		queries.push(sql);

		if(mockError != null)
			throw mockError;
		else
			return new MockResultSet(mockResults[queries.length-1]);
	}
	
	public function rollback() : Void {}
	public function startTransaction() : Void {}
}

class MockDatabaseConnection extends Database
{
	private var mockConnection : MockConnection;
	
	public function simulateError(error : String) : Void
	{
		this.mockConnection.mockError = error;
	}
	
	public function addMockResult(result : Array<Dynamic>) : Void
	{
		this.mockConnection.mockResults.push(result);
	}
	
	public var queries(getQueries, null) : Array<String>;
	private function getQueries() : Array<String>
	{
		return this.mockConnection.queries;
	}
	
	public function new(?driver : DatabaseDriver)
	{
		this.mockConnection = new MockConnection();
		
		// Set the myConnection and driver manually for the mock object.
		this.driver = driver != null ? driver : DatabaseDriver.mysql;
	}

	private var collationSent : Bool;
	private override function getConnection() : Connection
	{
		if(collationSent == null)
		{
			collationSent = true;
			
			// Need to send the collation query here because the method is overridden.
			if(this.driver == DatabaseDriver.mysql && this.charSet != null)
				sendCollationQuery();
		}

		return this.mockConnection;
	}
}

class MockResultSet implements ResultSet
{
	private var mockResults : List<Dynamic>;
	private var iterator : Iterator<Dynamic>;
	
	public function new(?results : Array<Dynamic>)
	{
		this.mockResults = new List<Dynamic>();
		
		if(results != null)
		{
			for(result in results)
				this.mockResults.add(result);
		}
		
		this.iterator = mockResults.iterator();
	}
	
	private function getLength() : Int { return 0; }
	private function getNFields() : Int { return 0; }
	
	public var length(getLength, null) : Int;
	public var nfields(getNFields, null) : Int;
	public function getFloatResult(n : Int) : Float { return 0; }
	public function getIntResult(n : Int) : Int { return 0; }
	public function getResult(n : Int) : String { return ''; }
	public function getFieldsNames() : Null<Array<String>> { return []; }
	
	public function hasNext() : Bool { return iterator.hasNext(); }
	public function next() : Dynamic { return iterator.next(); }
	public function results() : List<Dynamic> { return mockResults; }
}
