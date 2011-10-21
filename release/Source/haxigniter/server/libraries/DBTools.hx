package haxigniter.server.libraries;

import haxigniter.server.libraries.Database;

import sys.db.ResultSet;

class DbTools
{
	public static function save(data : Hash<Dynamic>, table : String, ?primaryKey = 'id', ?addPrimaryKeyToData = true) : Int
	{
		var db : DatabaseConnection = haxigniter.server.Application.instance().db;
		var id : Int;
		
		db.testAlphaNumeric(table);
		db.testAlphaNumeric(primaryKey);
		
		if(!data.exists(primaryKey) || data.get(primaryKey) == null)
		{
			// If empty or no primary key, use insert.
			db.insert(table, data);
			id = db.lastInsertId();
			
			if(addPrimaryKeyToData)
				data.set(primaryKey, id);
			
			return id;
		}
		else
		{
			// If primary key exists, use update.
			var where = new Hash<Dynamic>();
			where.set(primaryKey, data.get(primaryKey));
			
			db.update(table, data, where);
			
			return data.get(primaryKey);
		}
	}
	
	public static function paginate(query : String, offset : Int, limit : Int, ?meta : { total: Int }, ?params : Iterable<Dynamic>, ?noCalcRows = false) : ResultSet
	{
		var db : DatabaseConnection = haxigniter.server.Application.instance().db;
		var result : ResultSet;
		
		if(db.driver == DatabaseDriver.mysql && !noCalcRows && meta != null)
		{
			// Replace select with special mysql command for calculating total rows.
			var calc : EReg = ~/^[\s\r\n]*SELECT[\s\r\n]+(?!SQL_CALC_FOUND_ROWS)/i;
			query = calc.replace(query, 'SELECT SQL_CALC_FOUND_ROWS ') + sqlLimit(offset, limit);
			
			result = db.query(query, params);
			
			meta.total = db.queryInt('SELECT FOUND_ROWS()');
		}
		else
		{
			// Use a simpler approach for sqlite: Select without limit, get length and select again.
			// TODO: Find better and faster solution. Rewrite query with COUNT(*)? Reflect on the sqlite object?
			if(meta != null)
			{
				result = db.query(query, params);
				meta.total = result.length;
			}

			result = db.query(query + sqlLimit(offset, limit), params);
		}
		
		return result;
	}
	
	private static function sqlLimit(offset : Int, limit : Int)
	{
		return ' LIMIT ' + offset + ',' + limit;
	}
}