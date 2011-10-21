package haxigniter.server.restapi;

import haxigniter.common.libraries.Inflection;
import haxigniter.server.libraries.Database;

import Type;

#if php
import php.Lib;
import php.Web;
import php.db.ResultSet;
#elseif neko
import neko.Lib;
import neko.Web;
import neko.db.ResultSet;
#end

import haxigniter.server.libraries.Database;

import haxigniter.server.restapi.RestApiRequest;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.restapi.RestApiSecurityHandler;
import haxigniter.server.restapi.RestApiFormatHandler;

import haxigniter.server.exceptions.RestApiException;

typedef SqlTable = {
	var name: String;
	var attributes: Array<String>;
}

enum SqlJoinDir {
	parentOnRight;
	parentOnLeft;
}

class SelectQuery
{
	public var tables : Array<SqlTable>;
	public var order : String;	
	public var limit : Int;
	public var offset : Int;
	
	private var db : Database;
	
	public function new(db : Database)
	{
		this.db = db;
		
		this.tables = new Array<SqlTable>();

		// Order, limit and offset needs to be null so pseudo-functions can set them and test for exceptions.
	}
	
	public function clone(?pos = 0, ?end = -1) : SelectQuery
	{
		var output = new SelectQuery(this.db);

		output.tables = this.tables.slice(pos, end);
		output.order = this.order;
		output.limit = this.limit;
		output.offset = this.offset;
		
		return output;
	}
	
	private function query(prefix : String, ?joins : Array<SqlJoinDir>, ?useLimit = true, ?joinCount = 1) : ResultSet
	{
		if(joins == null)
		{
			joins = new Array<SqlJoinDir>();
			
			for(i in 0 ... tables.length-1)
				joins.push(SqlJoinDir.parentOnRight);
		}
		
		var sql = prefix + ' ' + generateQuery(joins, useLimit);
		
		try
		{
			return db.query(sql);
		}
		catch(e : Dynamic)
		{
			if(joins.length == 0)
				throw new RestApiException('Invalid request.', RestErrorType.invalidQuery);
			
			// Database error, switch the joins one step. (Detecting reversed joins)
			joinCount = switchJoins(joins, joinCount);
			return this.query(prefix, joins, useLimit, joinCount);
		}
	}
	
	private function switchJoins(joins : Array<SqlJoinDir>, count : Int) : Int
	{
		// If counter is above total number of join combinations, throw exception.
		if(count > joins.length * 2)
			throw new RestApiException('No valid relations found for query.', RestErrorType.invalidQuery);
		
		/* 
		 Flip each join based on its position and the count:
		   0 - 000 (First position, not used)
		   1 - 100
		   2 - 010
		   3 - 110
		   4 - 001
		   5 - 101
		   6 - 011
		   7 - 111
		*/		   
		for(i in 0 ... joins.length)
		{
			if(count % (i + 1) == 0)
			{
				joins[i] = joins[i] == SqlJoinDir.parentOnRight ? SqlJoinDir.parentOnLeft : SqlJoinDir.parentOnRight;
			}
		}
		
		return count + 1;
	}
	
	public function select() : List<Dynamic>
	{
		return this.query('SELECT ' + tables[0].name + '.* FROM ' + tables[0].name, null).results();
	}

	public function ids() : List<Int>
	{
		var output = new List<Int>();
		for(id in this.query('SELECT ' + tables[0].name + '.id FROM ' + tables[0].name, null))
		{
			output.add(cast(id.id, Int));
		}
		
		return output;
	}

	public function count() : Int
	{
		var result = this.query('SELECT COUNT(*) FROM ' + tables[0].name, null, false);
		return result.getIntResult(0);
	}

	private function generateQuery(joins : Array<SqlJoinDir>, ?useLimit = true)
	{
		var buffer = new StringBuf();

		//trace(this.tables);
		//trace([start, end, joins].join(' - '));

		for(i in 0 ... tables.length-1)
		{
			buffer.add(generateJoin(tables[i], tables[i + 1], joins[i]) + ' ');
		}
		
		buffer.add(generateWhere(0));
		
		if(this.order != '')
		{
			buffer.add(' ');
			buffer.add('ORDER BY ' + this.order);
		}
		
		if(useLimit && (limit > 0 || offset > 0))
			buffer.add(' LIMIT ' + (offset > 0 ? offset + ',' : '') + limit);
		
		return buffer.toString();
	}
	
	private function generateWhere(i : Int) : String
	{
		if(tables[i].attributes.length == 0)
			return '';
		
		var attribs = tables[i].attributes.join(' AND ');
		
		return 'WHERE ' + StringTools.replace(attribs, ' AND #OR# AND ', ' OR ');
	}
	
	private function generateJoin(leftTable : SqlTable, rightTable : SqlTable, direction : SqlJoinDir) : String
	{
		var sql = 'INNER JOIN ' + rightTable.name + ' ON (';
		
		if(direction == SqlJoinDir.parentOnRight)
			sql += rightTable.name + '.id = ' + leftTable.name + '.' + this.singularize(rightTable.name) + 'Id';
		else
			sql += rightTable.name + '.' + this.singularize(leftTable.name) + 'Id = ' + leftTable.name + '.id';
		
		if(rightTable.attributes.length > 0)
			sql += ' AND ' + rightTable.attributes.join(' AND ');
			
		return sql + ')';
	}
	
	private var singularizeCache : Hash<String>;
	private function singularize(name : String) : String
	{
		if(singularizeCache == null)
			singularizeCache = new Hash<String>();
		
		if(!singularizeCache.exists(name))
			singularizeCache.set(name, Inflection.singularize(name));
		
		return singularizeCache.get(name);
	}
}

class RestApiSqlRequestHandler implements RestApiRequestHandler
{
	private var db : Database;
	private var security : RestApiSecurityHandler;
	
	public function new(db : Database)
	{
		this.db = db;		
	}

	///// RestApiRequestHandler implementation //////////////////////

	public function handleApiRequest(request : RestApiRequest, security : RestApiSecurityHandler) : RestApiResponse
	{
		this.security = security;
		
		switch(request.type)
		{
			case read:
				return handleReadRequest(request);
			case create:
				return handleCreateRequest(request);
			case delete:
				return handleDeleteRequest(request);
			case update:
				return handleUpdateRequest(request);
		}
	}

	private function requestData(request : RestApiRequest) : PropertyObject
	{
		var output : PropertyObject;
		var empty = true;
		
		if(Std.is(request.data, Hash))
		{
			var hash = cast(request.data, Hash<Dynamic>);
			output = {};
			
			for(key in hash.keys())
			{
				// Test for malicious keys.
				this.db.testAlphaNumeric(key);
				empty = false;
				
				Reflect.setField(output, key, hash.get(key));
			}
		}
		else if(Reflect.isObject(request.data))
		{
			for(key in Reflect.fields(request.data))
			{
				// Test for malicious keys.
				this.db.testAlphaNumeric(key);				
				empty = false;
			}
			
			output = request.data;
		}
		else
		{
			throw new RestApiException('Request data format not supported by RestApiSqlRequestHandler.', RestErrorType.invalidData);
		}
		
		if(empty)
			throw new RestApiException('No data specified in request.', RestErrorType.invalidData);

		return output;
	}
	
	///// Handle request methods ////////////////////////////////////
	
	public function handleCreateRequest(request : RestApiRequest) : RestApiResponse
	{
		var createResource = request.resources[request.resources.length - 1];
		
		if(createResource.selectors.length > 0)
			throw new RestApiException('Ending resource cannot have any selectors in create requests.', RestErrorType.invalidQuery);

		var data = requestData(request);
		var output = new Array<Int>();

		if(request.resources.length > 1)
		{
			// Create a select query based on everything up to (but not including) the last resource, to get the ids for the foreign key.
			var query = createSelectQuery(request.resources.slice(0, -1));
			
			var parentResource = request.resources[request.resources.length - 2].name;
			var foreignKey = Inflection.singularize(parentResource) + 'Id';
			
			// If foreign key exists already, use it instead.
			var newForeignKey = Reflect.hasField(data, foreignKey);
			
			for(id in query.ids())
			{
				// Test if security allows this request.
				if(security != null)
					security.create(createResource.name, data, parentResource, id, request.queryParameters);

				// Set the foreign key field
				if(!newForeignKey)
					Reflect.setField(data, foreignKey, id);
				
				db.insert(createResource.name, data);
				output.push(db.lastInsertId());
				
				// Delete the foreign key afterwards, since there may have been more than one id added
				// and supplying the last one would be dubious.
				if(!newForeignKey)
					Reflect.deleteField(data, foreignKey);
			}
		}
		else
		{
			// Test if security allows this request.
			if(security != null)
				security.create(createResource.name, request.data, null, null, request.queryParameters);

			db.insert(createResource.name, data);
			output.push(db.lastInsertId());
		}
		
		if(output.length == 0)
			return RestApiResponse.failure('Create request failed.', RestErrorType.unknown);
		
		return RestApiResponse.success(output);
	}

	public function handleUpdateRequest(request : RestApiRequest) : RestApiResponse
	{
		var data = requestData(request);
		var output = new Array<Int>();

		var query = createSelectQuery(request.resources);
		var ids = query.ids();

		var updateAll : Bool = request.resources.length == 1 && request.resources[0].selectors.length == 0;
		var tableName = request.resources[request.resources.length - 1].name;
		
		// Test if security allows this request.
		if(security != null)
			security.update(tableName, ids, data, request.queryParameters);
		
		if(ids.length > 0 || updateAll)
		{
			var query = 'UPDATE ' + tableName + ' SET ';
			
			var updateData = new Array<String>();
			var values = [];
			for(key in Reflect.fields(data))
			{
				updateData.push(key + '=?');			
				values.push(Reflect.field(data, key));
			}
			
			// Add the data keys to the query.
			query += updateData.join(', ');
			
			// Test affected rows or just return ids?
			if(!updateAll)
				query += ' WHERE ' + tableName + '.id IN(' + ids.join(',') + ')';

			db.query(query, values);
		}
			
		return RestApiResponse.success(Lambda.array(ids));
	}

	public function handleDeleteRequest(request : RestApiRequest) : RestApiResponse
	{
		var output = new Array<Int>();

		var query = createSelectQuery(request.resources);
		var ids = query.ids();

		var deleteAll : Bool = request.resources.length == 1 && request.resources[0].selectors.length == 0;
		var tableName = request.resources[request.resources.length - 1].name;

		// Test if security allows this request.
		if(security != null)
			security.delete(tableName, ids, request.queryParameters);

		if(ids.length > 0 || deleteAll)
		{
			var query = 'DELETE FROM ' + tableName;
			
			// Test affected rows or just return ids?
			if(!deleteAll)
				query += ' WHERE ' + tableName + '.id IN(' + ids.join(',') + ')';
			
			db.query(query);
		}
		
		return RestApiResponse.success(Lambda.array(ids));
	}

	public function handleReadRequest(request : RestApiRequest) : RestApiResponse
	{
		var query = createSelectQuery(request.resources);
		var tableName = request.resources[request.resources.length - 1].name;
		
		// TODO: Enforce upper limit
		// TODO: Use SQL_CALC_FOUND_ROWS for the Mysql driver.

		var results = query.select();
		var response : RestDataCollection;
		
		//trace(results);
		
		if(query.limit == 0 && query.offset == 0)
		{
			response = new RestDataCollection(0, cast(Math.max(0, results.length-1), Int), results.length, Lambda.array(results));
		}
		else
		{
			var count = query.count();
			
			response = new RestDataCollection(query.offset, query.offset + results.length, count, Lambda.array(results));
		}
		
		// Test if security allows this request.
		if(security != null)
			security.read(tableName, response, request.queryParameters);
		
		return haxigniter.common.restapi.RestApiResponse.successData(response);
	}
	
	/////////////////////////////////////////////////////////////////
	
	public function attributeToSql(name : String, operator : RestApiSelectorOperator, value : String) : String
	{
		var output : String;
		
		switch(operator)
		{
			case contains:
				value = '%' + value + '%';
				output = name + ' LIKE ?';
			
			case endsWith:
				value = '%' + value;
				output = name + ' LIKE ?';

			case equals:
				output = name + ' = ?';

			case lessThan:
				output = name + ' < ?';

			case lessThanOrEqual:
				output = name + ' <= ?';

			case moreThan:
				output = name + ' > ?';

			case moreThanOrEqual:
				output = name + ' >= ?';

			case notEqual:
				output = name + ' != ?';

			case startsWith:
				value += '%';
				output = name + ' LIKE ?';
		}
		
		return StringTools.replace(output, '?', this.db.connection.quote(value));
	}
	
	/////////////////////////////////////////////////////////////////

	public function createSelectQuery(resources : Array<RestApiResource>) : SelectQuery
	{
		var query = new SelectQuery(this.db);
			
		for(resource in resources)
		{
			var attributes = [];
			
			for(selector in resource.selectors)
			{
				switch(selector)
				{
					case func(name, args):
						pseudoFunction(name, args, query);
					
					case attribute(name, operator, value):
						var newValue = { val: '' };
						attributes.push(attributeToSql(resource.name + '.' + name, operator, value));
						
					case orOperator:
						attributes.push('#OR#');
				}
			}

			// Add tables in reverse order for the sql query to be generated properly.
			query.tables.unshift({name: resource.name, attributes: attributes});
		}
		
		// Set limit and offset if not set in pseudo-functions.
		if(query.limit == null)
			query.limit = 0;

		if(query.offset == null)
			query.offset = 0;

		if(query.order == null)
			query.order = '';

		return query;
	}
	
	private function pseudoFunction(name : String, args : Array<String>, query : SelectQuery) : Void
	{
		switch(name.toLowerCase())
		{
			case 'gt':
				if(query.limit != null)
					throw new RestApiException('Limiting can only be done once in a selector.', RestErrorType.invalidQuery);

				if(args.length != 1)
					throw new RestApiException('gt() takes exactly one argument.', RestErrorType.invalidQuery);
				
				var start = Std.parseInt(args[0]);
				
				if(start == null)
					throw new RestApiException('Error in gt() when parsing "' + args[0] + '" to integer.', RestErrorType.invalidQuery);

				if(start < 0)
					throw new RestApiException('Argument to gt() cannot be negative.', RestErrorType.invalidQuery);

				query.limit = 999999999;
				query.offset = start;

			case 'lt':
				if(query.limit != null)
					throw new RestApiException('Limiting can only be done once in a selector.', RestErrorType.invalidQuery);

				if(args.length != 1)
					throw new RestApiException('lt() takes exactly one argument.', RestErrorType.invalidQuery);
				
				var start = Std.parseInt(args[0]);
				
				if(start == null)
					throw new RestApiException('Error in lt() when parsing "' + args[0] + '" to integer.', RestErrorType.invalidQuery);

				if(start < 0)
					throw new RestApiException('Argument to lt() cannot be negative.', RestErrorType.invalidQuery);

				query.limit = start;
				query.offset = 0;

			case 'eq':
				if(query.limit != null)
					throw new RestApiException('Limiting can only be done once in a selector.', RestErrorType.invalidQuery);

				if(args.length != 1)
					throw new RestApiException('eq() takes exactly one argument.', RestErrorType.invalidQuery);
				
				var start = Std.parseInt(args[0]);
				
				if(start == null)
					throw new RestApiException('Error in eq() when parsing "' + args[0] + '" to integer.', RestErrorType.invalidQuery);

				if(start < 0)
					throw new RestApiException('Argument to eq() cannot be negative.', RestErrorType.invalidQuery);

				query.limit = 1;
				query.offset = start;

			case 'range':
				if(query.limit != null)
					throw new RestApiException('Limiting can only be done once in a selector.', RestErrorType.invalidQuery);

				if(args.length != 2)
					throw new RestApiException('range() takes exactly two arguments.', RestErrorType.invalidQuery);
				
				var start = Std.parseInt(args[0]);
				var end = Std.parseInt(args[1]);
				
				if(start == null)
					throw new RestApiException('Error in range() when parsing "' + args[0] + '" to integer.', RestErrorType.invalidQuery);

				if(end == null)
					throw new RestApiException('Error in range() when parsing "' + args[1] + '" to integer.', RestErrorType.invalidQuery);

				if(start < 0)
					throw new RestApiException('Start of range() cannot be negative.', RestErrorType.invalidQuery);

				if(end < 0)
					throw new RestApiException('End of range() cannot be negative.', RestErrorType.invalidQuery);

				if(end < start)
					throw new RestApiException('Start of range() cannot be higher than the end.', RestErrorType.invalidQuery);

				query.limit = end - start;
				query.offset = start;
				
			case 'order':
				if(query.order != null)
					throw new RestApiException('Order can only be set once in a selector.', RestErrorType.invalidQuery);

				var orders = new Array<String>();
				for(i in 0 ... args.length)
				{
					if(i%2 == 1) continue;
					
					this.db.testAlphaNumeric(args[i]);
					
					if(args[i+1] == null)
						orders.push(args[i]);
					else
					{
						var orderBy = args[i+1].toUpperCase();
						
						if(orderBy == 'ASC' || orderBy == 'DESC')
							orders.push(args[i] + ' ' + orderBy);
						else
							throw new RestApiException('order() keyword can only be ASC or DESC, was "' + orderBy + '".', RestErrorType.invalidQuery);
					}										
				}								
				query.order = orders.join(', ');
		
			case 'random':
				if(query.order != null)
					throw new RestApiException('Order can only be set once in a selector.', RestErrorType.invalidQuery);

				switch(this.db.driver)
				{
					case DatabaseDriver.mysql:
						query.order = 'RAND()';
					case DatabaseDriver.sqlite:
						query.order = 'RANDOM()';
					default:
						throw new RestApiException('Random order is only supported by mysql or sqlite.', RestErrorType.invalidQuery);
				}
				
			default:
				throw new RestApiException('pseudo-function "'+name+'" is not supported by the sql request handler.', RestErrorType.invalidQuery);
		}
	}
}
