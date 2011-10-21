package haxigniter.server.libraries;

import Type;
import haxe.PosInfos;
import haxigniter.server.libraries.Debug;




import sys.db.Mysql;
import sys.db.Connection;
import sys.db.ResultSet;


enum DatabaseDriver
{
	mysql;
	sqlite;
	other;
}

class DatabaseException extends haxigniter.common.exceptions.Exception
{
	public var connection : Database;
	
	public function new(message : String, connection : Database, ?stack : haxe.PosInfos)
	{
		this.connection = connection;
		super(message, 0, stack);
	}
}

// TODO: Operators in where queries
// TODO: Unquoted fields in where/data queries
class Database
{	
	public var host : String;
	public var port : Int;
	public var user : String;
	public var pass : String;
	public var database : String;
	public var socket : String;
	public var driver : DatabaseDriver;

	public var charSet : String;
	public var collation : String;

	public var debug : Debug;
	
	public var connection(getConnection, setConnection) : Connection;
	private var myConnection : Connection;
	private function getConnection() : Connection
	{
		if(this.myConnection == null)
		{
			switch(this.driver)
			{
				case mysql:
					this.myConnection = Mysql.connect(this);
					
					if(charSet != null)
						sendCollationQuery();

				case sqlite:
					#if php
					#if !spod_macro    //// HACK PDO doesn't exist in sys.db
					this.myConnection = PDO.open('sqlite:' + this.database);
					#end
					#elseif neko
					#if !spod_macro
					this.myConnection = Sqlite.open(this.database);
						#end
					#end
				
				case other:
					throw new DatabaseException('No database connection specified.', this);
			}			
		}
		
		return this.myConnection;
	}
	private function setConnection(value : Connection) : Connection
	{
		if(value == null)
			throw new DatabaseException('Cannot set database connection to null.', this);

		if(this.myConnection != null)
			throw new DatabaseException('Cannot change database connection after setting it.', this);
		
		this.myConnection = value;
		return this.myConnection;
	}
	
	public var traceQueries : DebugLevel;
	
	/**
	 * Set this value to change the string which is replaced by a parameter when executing a query.
	 * Default is '?'
	 */
	public var parameterString : String;
	
	/**
	 * Last executed query, useful when debugging.
	 */
	public var lastQuery(default, null) : String;

	private static var alphaRegexp : EReg = ~/^\w+$/;

	public function open() : Void
	{
		if(this.myConnection != null)
			throw new DatabaseException('Connection is already open.', this);
		
		getConnection();
	}
	
	public function close() : Void
	{
		if(this.myConnection != null)
		{
			this.myConnection.close();
			this.myConnection = null;
		}
	}
	
	///// Query methods /////////////////////////////////////////////
	
	public function query(query : String, ?params : Iterable<Dynamic>, ?pos : PosInfos) : ResultSet
	{
		if(params != null)
			query = this.queryParams(query, params);
		
		return this.request(query, pos);
	}

	public function queryRow(query : String, ?params : Iterable<Dynamic>, ?pos : PosInfos) : Dynamic
	{
		var result = this.query(query, params, pos);
		return result.hasNext() ? result.next() : null;
	}

	public function queryInt(query : String, ?params : Iterable<Dynamic>, ?pos : PosInfos) : Int
	{
		var result = this.query(query, params, pos);
		return result.hasNext() ? result.getIntResult(0) : null;
	}

	public function queryFloat(query : String, ?params : Iterable<Dynamic>, ?pos : PosInfos) : Float
	{
		var result = this.query(query, params, pos);
		return result.hasNext() ? result.getFloatResult(0) : null;
	}

	public function queryString(query : String, ?params : Iterable<Dynamic>, ?pos : PosInfos) : String
	{
		var result = this.query(query, params, pos);
		return result.hasNext() ? result.getResult(0) : null;
	}

	///// C(R)UD methods ////////////////////////////////////////////
	
	private function makeHash(data : Dynamic, ?pos : PosInfos) : Hash<Dynamic>
	{
		if(Std.is(data, Hash)) 
			return data;
		
		var output = new Hash<Dynamic>();
		for(field in Reflect.fields(data))
		{
			output.set(field, Reflect.field(data, field));
		}
		
		return output;
	}
	
	public function insert(table : String, data : Dynamic, ?replace = false, ?pos : PosInfos) : Int
	{
		this.testAlphaNumeric(table);

		var hash = makeHash(data);
		var keys = '';
		var values = '';
		
		for(key in hash.keys())
		{
			this.testAlphaNumeric(key);
			keys += ', ' + key;
			
			var value = hash.get(key);
			values += ', ' + (value == null ? 'NULL' : this.connection.quote(Std.string(value)));
		}
		
		var query = (replace ? 'REPLACE' : 'INSERT') + ' INTO ' + table + ' (' + keys.substr(2) + ') VALUES (' + values.substr(2) + ')';
		var result : ResultSet = this.request(query, pos);
		
		return result.length;
	}

	public function replace(table : String, data : Dynamic) : Int
	{
		return this.insert(table, data, true);
	}
	
	public function update(table : String, data : Dynamic, ?where : Dynamic, ?limit : Int, ?pos : PosInfos) : Int
	{
		this.testAlphaNumeric(table);
		
		var hash = makeHash(data);
		var set = '';
		var whereStr = '';
		
		for(key in hash.keys())
		{
			this.testAlphaNumeric(key);
			
			var value = hash.get(key);
			set += ', ' + key + '=' + (value == null ? 'NULL' : this.connection.quote(Std.string(value)));
		}

		if(where != null)
		{
			var whereHash = makeHash(where);
			
			for(key in whereHash.keys())
			{
				this.testAlphaNumeric(key);
				
				var value = whereHash.get(key);
				whereStr += ' AND ' + key + '=' + (value == null ? 'NULL' : this.connection.quote(Std.string(value)));
			}
		}

		var query = 'UPDATE ' + table + ' SET ' + set.substr(2);
		
		if(where != null)
			query += ' WHERE ' + whereStr.substr(5);
		
		if(limit != null)
			query += ' LIMIT ' + limit;

		var result : ResultSet = this.request(query, pos);
		
		return result.length;
	}
	
	public function delete(table : String, ?where : Dynamic, ?limit : Int, ?pos : PosInfos) : Int
	{
		this.testAlphaNumeric(table);
		
		var whereStr = '';
		
		if(where != null)
		{
			var whereHash = makeHash(where);
			
			for(key in whereHash.keys())
			{
				this.testAlphaNumeric(key);
				
				var value = whereHash.get(key);
				whereStr += ' AND ' + key + '=' + (value == null ? 'NULL' : this.connection.quote(Std.string(value)));
			}
		}

		var query = 'DELETE FROM ' + table;
		
		if(where != null)
			query += ' WHERE ' + whereStr.substr(5);
		
		if(limit != null)
			query += ' LIMIT ' + limit;

		var result : ResultSet = this.request(query, pos);
		
		return result.length;
	}	

	///// Other /////////////////////////////////////////////////////
	
	public function lastInsertId() : Int
	{
		return this.connection.lastInsertId();
	}
	
	public inline function testAlphaNumeric(value : String) : Void
	{	
		if(value == null || !Database.alphaRegexp.match(value))
			throw new DatabaseException('Invalid parameter: ' + value, this);
	}

	/////////////////////////////////////////////////////////////////
	
	private function queryParams(query : String, params : Iterable<Dynamic>)
	{
		var parameter = this.parameterString == null ? '?' : this.parameterString;
		
		for(param in params)
		{
			var pos = query.indexOf(parameter);
			if(pos == -1)
				throw new DatabaseException('Not enough parameters in query.', this);
			
			if(param != null)
			{
				param = this.connection.quote(Std.string(param));
				
				/*
				// Slightly faster, but neko/php conflicts:
				param = switch(Type.typeof(param))
				{
					case ValueType.TInt: param;
					case ValueType.TFloat: param;
					case ValueType.TBool: Std.string(param);
					default: this.connection.quote(Std.string(param));
				}
				*/
			}
			else
				param = 'NULL';
			
			query = query.substr(0, pos) + param + query.substr(pos+1);
		}
		
		return query;
	}

	private function request(query : String, ?pos : PosInfos) : ResultSet
	{
		if(traceQueries != null && this.debug != null)
		{
			debug.log('[Executing SQL] ' + query, traceQueries);
		}

		try
		{
			this.lastQuery = query;
			return this.connection.request(query);
		}
		catch(e : Dynamic)
		{
			if(this.debug != null)
				debug.log('[SQL Error] ' + query, DebugLevel.error);
			
			throw e;
		}
	}
	
	private inline function sendCollationQuery() : Void
	{
		var stringTest = charSet + (collation != null ? collation : '');
		
		if(!(~/^\w+$/.match(stringTest)))
		{
			throw new DatabaseException('Charset/collation settings must be alphanumeric.', null);
		}
		
		if(collation != null)
			this.connection.request("SET NAMES '" + charSet + "' COLLATE '" + collation + "'");
		else
			this.connection.request("SET CHARACTER SET " + charSet);
	}
}

/*
$db['local']['dbprefix'] = "";
$db['local']['pconnect'] = FALSE;
$db['local']['cache_on'] = FALSE;
$db['local']['cachedir'] = "";
*/
