package haxigniter.tests.unit;

import haxigniter.server.libraries.Database;
import haxigniter.tests.mocks.MockDatabaseConnection;

class When_using_library_Database extends haxigniter.common.unit.TestCase
{
	private var db : MockDatabaseConnection;
	
	public override function setup()
	{
		db = new MockDatabaseConnection();
	}
	
	public function test_Then_dynamic_objects_should_be_iterated()
	{
		var data1 = { me: 'who', data: 'you' };
		
		var data2 = new Hash<Dynamic>();
		data2.set('who', 'me');
		data2.set('you', 1337);
		
		// Simple test of the mock object
		this.assertEqual(0, db.queries.length);

		db.insert('test', data1);
		this.assertEqual('INSERT INTO test (me, data) VALUES (Q*who*Q, Q*you*Q)', db.lastQuery);
		
		db.insert('test', data2);
		this.assertEqual('INSERT INTO test (who, you) VALUES (Q*me*Q, Q*1337*Q)', db.lastQuery);
		
		db.update('test', data1, data2, 5);
		this.assertEqual('UPDATE test SET me=Q*who*Q, data=Q*you*Q WHERE who=Q*me*Q AND you=Q*1337*Q LIMIT 5', db.lastQuery);

		db.delete('test', data1, 1);
		this.assertEqual('DELETE FROM test WHERE me=Q*who*Q AND data=Q*you*Q LIMIT 1', db.lastQuery);	
		
		// Simple test of the mock object
		this.assertEqual(4, db.queries.length);
		this.assertEqual('INSERT INTO test (me, data) VALUES (Q*who*Q, Q*you*Q)', db.queries[0]);
		this.assertEqual('DELETE FROM test WHERE me=Q*who*Q AND data=Q*you*Q LIMIT 1', db.queries[3]);		
	}

	public function test_Then_null_values_should_not_be_quoted()
	{
		var data1 = { test: null };
		
		db.insert('nulltest', data1);
		this.assertEqual('INSERT INTO nulltest (test) VALUES (NULL)', db.lastQuery);
		
		db.update('nulltest', data1, data1);
		this.assertEqual('UPDATE nulltest SET test=NULL WHERE test=NULL', db.lastQuery);

		db.delete('nulltest', data1);
		this.assertEqual('DELETE FROM nulltest WHERE test=NULL', db.lastQuery);	
	}
	
	public function test_Then_charset_should_generate_an_extra_query()
	{
		db.charSet = 'utf8';
		db.query('MOCK');
		
		// Make another query to make sure the charset isn't queried again.
		db.query('MOCK 2');
		
		this.assertEqual(3, db.queries.length);
		
		this.assertEqual('SET CHARACTER SET utf8', db.queries[0]);
		this.assertEqual('MOCK', db.queries[1]);
		this.assertEqual('MOCK 2', db.queries[2]);
	}
	
	public function test_Then_charset_and_collation_should_generate_an_extra_query()
	{
		db.charSet = 'utf8';
		db.collation = 'utf8_unicode_ci';
		db.query('MOCK 123');
		
		this.assertEqual(2, db.queries.length);
		this.assertEqual("SET NAMES 'utf8' COLLATE 'utf8_unicode_ci'", db.queries[0]);
		this.assertEqual('MOCK 123', db.queries[1]);
	}
	
	public function test_Then_non_alphanumeric_charsets_will_throw_exception()
	{
		db.charSet = 'utf8.1';
		
		try
		{
			db.query('MOCK 123');
		}
		catch(e : DatabaseException)
		{
			this.assertEqual('Charset/collation settings must be alphanumeric.', e.message);
			return;
		}
		
		this.assertTrue(false);
	}
	
	public function test_Then_non_alphanumeric_collations_will_throw_exception()
	{
		db.charSet = 'utf8';
		db.collation = 'utf8.1_unicode_ci';
		
		try
		{
			db.query('MOCK 456');
		}
		catch(e : DatabaseException)
		{
			this.assertEqual('Charset/collation settings must be alphanumeric.', e.message);
			return;
		}
		
		this.assertTrue(false);
	}
}
