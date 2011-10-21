package haxigniter.tests.unit;

import haxigniter.common.validation.FieldValidator;
import haxigniter.server.exceptions.RestApiException;
import haxigniter.server.exceptions.RestApiValidationException;
import haxigniter.server.restapi.RestApiConfigSecurityHandler;

import haxigniter.common.restapi.RestApiInterface;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.restapi.RestApiFormatHandler;

using haxigniter.common.libraries.IterableTools;

class MockApiInterface implements RestApiInterface
{
	public var requests : Array<String -> RestApiResponse>;
	private var count : Int;

	public function new()
	{
		requests = new Array<String -> RestApiResponse>();
		count = 0;
	}
	
	public function create(url : String, data : Dynamic, callBack : RestApiResponse -> Void) : Void
	{
		throw 'Not needed.';
	}
	
	public function read(url : String, callBack : RestApiResponse -> Void) : Void
	{
		if(count >= requests.length)
			throw 'Expected only ' + count + ' request(s) for MockApiInterface.';
		
		callBack(this.requests[count++](url));		
	}
	
	public function update(url : String, data : Dynamic, callBack : RestApiResponse -> Void) : Void
	{
		throw 'Not needed.';
	}
	
	public function delete(url : String, callBack : RestApiResponse -> Void) : Void
	{
		throw 'Not needed.';
	}
}

/**
* This is fun, unit testing a unit test class.
*/
class When_using_RestApiConfigSecurityHandler extends haxigniter.common.unit.TestCase
{
	private var api : MockApiInterface;
	private var parameters : Hash<String>;
	private var security : RestApiConfigSecurityHandler;
	private var rights : SecurityRights;
	private var ownerships : Ownerships;
	private var callbacks : Dynamic;
	
	public override function setup()
	{
		var self = this;

		this.rights = new SecurityRights();
		this.ownerships = new Ownerships();
		this.callbacks = {};

		this.api = new MockApiInterface();
		this.api.requests[0] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/[USER="User"][PASS="Pass\\"word"]', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 123, isAdmin: 0}]));
		}

		parameters = new Hash<String>();
		parameters.set('username', 'User');
		parameters.set('password', 'Pass"word');

		security = new RestApiConfigSecurityHandler(rights, ownerships, callbacks);
		
		security.userNameField = 'USER';
		security.userPasswordField = 'PASS';
		security.userResource = 'USERS';
		
		security.userIsAdminField = 'isAdmin';
		security.userIsAdminValue = 1;
		
		// Set encoder to null so it doesn't scramble the passwords.
		security.userPasswordEncoder = null;
		
		security.install(this.api);
	}
	
	public override function tearDown()
	{
		
	}
	
	private function setRights(rights : SecurityRights)
	{
		Reflect.setField(security, 'rights', rights);
	}

	private function setOwnerships(ownerships : Ownerships)
	{
		Reflect.setField(security, 'ownerships', ownerships);
	}

	/////////////////////////////////////////////////////////////////
	
	public function test_Then_callbacks_must_have_valid_names()
	{
		try
		{
			new RestApiConfigSecurityHandler(null, null, { totalBogusName: null } );
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Invalid callback name: totalBogusName$/, e.message);
		}
		
		new RestApiConfigSecurityHandler(null, null, { adminCreateTablename: null } );
	}
	
	public function test_Then_resource_must_exist_in_access_object()
	{
		try
		{
			security.create('testResource', null);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/No request data found!$/, e.message);
		}

		try
		{
			security.read('testResource', null);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/No rights found for resource: testResource$/, e.message);
		}

		try
		{
			security.update('testResource', null, null);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/No rights found for resource: testResource$/, e.message);
		}

		try
		{
			security.delete('testResource', null);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/No rights found for resource: testResource$/, e.message);
		}
	}

	public function test_Then_write_requests_fails_if_no_data()
	{
		rights.set('testResource', {guest: {create: 'ALL', read: 'ALL', update: 'ALL', delete: 'ALL'}, owner: null, admin: null});
		
		try
		{
			security.create('testResource', null);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/No request data found!$/, e.message);
		}
	}

	public function test_Then_write_requests_fails_if_id_exists_for_ALL_rights()
	{
		rights.set('testResource', {guest: {create: 'ALL', read: 'ALL', update: 'ALL', delete: 'ALL'}, owner: null, admin: null});
		
		try
		{
			security.create('testResource', {id: 123, name: 'Boris'});
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Field "id" cannot be modified.$/, e.message);
		}
	}

	public function test_Then_write_requests_fails_if_foreign_key_exists_for_ALL_rights()
	{
		rights.set('testResource', {guest: {create: 'ALL', read: 'ALL', update: 'ALL', delete: 'ALL'}, owner: null, admin: null});
		
		try
		{
			security.create('testResource', {foreignId: 123, name: 'Boris'});
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Field "foreignId" cannot be modified.$/, e.message);
		}
	}

	public function test_Then_no_access_if_login_fails()
	{
		rights.set('testResource', { guest: null, owner: null, admin: null } );
		
		// Failed to find a valid user.
		this.api.requests[0] = function(url : String) : RestApiResponse
		{
			return RestApiResponse.successData(new RestDataCollection(0, 0, 0, []));
		}
		
		try
		{
			security.create('testResource', {name: 'Doris'}, parameters);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/^Invalid username or password.$/, e.message);
		}		
	}
	
	public function test_Then_guest_has_access_if_specified()
	{
		rights.set('testResource', {guest: {create: 'ALL', read: 'ALL', update: 'ALL', delete: 'ALL'}, owner: null, admin: null});
		
		security.create('testResource', {name: 'Boris'});
		security.read('testResource', new RestDataCollection(0, 0, 1, [{id: 456, name: 'Boris'}]));
		security.update('testResource', Lambda.list([1,2,3]), {test: 'hello'});
		security.delete('testResource', Lambda.list([1,2,3]));
		
		this.assertTrue(true); // Just passin' through...
	}

	public function test_Then_no_access_if_not_specified()
	{
		rights.set('testResource', {guest: null, owner: null, admin: null});
		
		try
		{
			security.create('testResource', {name: 'Doris'});
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/^Unauthorized access.$/, e.message);
		}
	}

	///// Create access /////////////////////////////////////////////

	public function test_Then_admin_has_no_access_if_not_specified()
	{
		var self = this;
		
		rights.set('testResource', { guest: null, owner: null, admin: null } );

		// User is admin in this case, so request is good.
		this.api.requests[0] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/[USER="User"][PASS="Pass\\"word"]', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 1, isAdmin: 1}]));
		}
		
		try
		{
			security.create('testResource', {name: 'Doris'});
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/^Unauthorized access.$/, e.message);
		}
	}

	public function test_Then_admin_has_access_if_specified()
	{
		var self = this;
		
		rights.set('testResource', { guest: null, owner: null, admin: 'ALL' } );

		// User is admin in this case, so request is good.
		this.api.requests[0] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/[USER="User"][PASS="Pass\\"word"]', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 1, isAdmin: 1}]));
		}
		
		security.create('testResource', {name: 'Boris'}, parameters);
	}
	
	public function test_Then_owner_has_write_access_if_specified_for_foreign_keys()
	{
		var self = this;
		var data : Dynamic = { name: 'ABC' };
		
		rights.set('libraries', { guest: null, owner: {create: 'ALL'}, admin: null } );		
		ownerships[0] = ['users', 'libraries'];

		// Current ownerID is 123.
		// The security check returns a user with incorrect ID:
		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 456, name: 'Boris'}]));
		}
		
		try
		{
			// Try to add something to users with incorrect id.
			security.create('libraries', data, 'users', 1, parameters);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/^Unauthorized access.$/, e.message);
		}
		
		// Returns a user with correct ID this time. OwnerID is now 456.
		this.api.requests[2] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/[USER="User"][PASS="Pass\\"word"]', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 456, isAdmin: 0}]));
		}
		
		// The return value from the security check now matches the ownerID:
		this.api.requests[3] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/456/', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 456, name: 'Boris'}]));
		}
		
		// Creating a library with users as parent table.
		security.create('libraries', data, 'users', 456, parameters);
		
		this.assertEqual(456, data.userId);
		this.assertEqual('ABC', data.name);
	}

	public function test_Then_owner_has_access_if_specified_for_foreign_keys_and_multiple_resources()
	{
		var self = this;
		var data : Dynamic = { name: 'ABC' };
		
		rights.set('news', { guest: null, owner: {create: 'ALL'}, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 1, name: 'Boris'}, {id:2, name: 'Doris'}]));
		}

		// Now the ID must be included in the above resultset or access is denied.
		security.create('news', data, 'libraries', 2, parameters);
		this.assertEqual(2, data.libraryId);
	}

	public function test_Then_owner_has_access_if_specified_for_subset_of_ownerships()
	{
		var self = this;
		
		rights.set('users', { guest: null, owner: {create: 'ALL'}, admin: null } );		
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 123, name: 'Doris'}]));
		}
		
		security.create('users', {name: 'Boris'}, 'libraries', 123, parameters);
	}

	public function test_Then_guest_rights_is_used_if_owner_access_fails()
	{
		var self = this;
		
		rights.set('users', { guest: {create: ['name']}, owner: null, admin: null } );		
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[0] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/[USER="User"][PASS="Pass\\"word"]', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 999, name: "Valid user but no access rights exists."}]));
		}

		try
		{
			security.create('users', { name: 'Boris', count: 123 }, parameters);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Unauthorized access to fields "count".$/, e.message);
		}
	}

	public function test_Then_guest_has_write_access_to_specific_fields_when_specified()
	{
		var self = this;
		var data : Dynamic = { name: 'ABC', count: 123 };
		
		rights.set('news', { guest: {create: ['name', 'count']}, owner: null, admin: null } );		

		security.create('news', data, null);
		this.assertTrue(true);
	}

	public function test_Then_guest_has_write_access_to_field_subset_when_specified()
	{
		var self = this;
		var data : Dynamic = { name: 'ABC' };
		
		rights.set('news', { guest: {create: ['name', 'count']}, owner: null, admin: null } );		

		security.create('news', data, null);
		this.assertTrue(true);
	}

	public function test_Then_guest_cannot_write_to_unspecified_fields()
	{
		var self = this;
		var data : Dynamic = { name: 'ABC', hack: 1337 };
		
		rights.set('news', { guest: {create: ['name', 'count']}, owner: null, admin: null } );		

		try
		{
			security.create('news', data, null);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Unauthorized access to fields "hack".$/, e.message);
		}
	}

	///// Read access ///////////////////////////////////////////////
	
	public function test_Then_ALL_rights_gives_read_access_to_all_fields()
	{
		var self = this;
		var data = new RestDataCollection(0, 0, 1, [ { id: 1, firstname: 'Boris', lastname: 'Doris' } ]);
		
		rights.set('testResource', { guest: {read: 'ALL'}, owner: null, admin: null } );
		security.read('testResource', data, parameters);
		
		this.assertEqualObjects({ id: 1, firstname: 'Boris', lastname: 'Doris' }, data.data[0]);
	}

	public function test_Then_array_rights_gives_read_access_to_specified_fields()
	{
		var self = this;
		var data = new RestDataCollection(0, 0, 1, [ { id: 1, firstname: 'Boris', lastname: 'Doris' } ]);
		
		rights.set('testResource', { guest: {read: ['id', 'firstname']}, owner: null, admin: null } );
		security.read('testResource', data, parameters);
		
		this.assertEqualObjects({ id: 1, firstname: 'Boris' }, data.data[0]);
	}

	public function test_Then_owner_must_own_the_resources_for_read_access()
	{
		var self = this;
		
		var smalldata = new RestDataCollection(0, 0, 1, [ { id: 2, firstname: 'Justin', lastname: 'Case' } ]);
		var data = new RestDataCollection(0, 0, 2, [ { id: 1, firstname: 'Boris', lastname: 'Doris' }, { id: 2, firstname: 'Justin', lastname: 'Case' } ]);
		
		rights.set('news', { guest: null, owner: { read: ['id', 'firstname'] }, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries//news', url);
			return RestApiResponse.successData(data);
		}

		security.read('news', smalldata, parameters);
		
		this.assertEqual(smalldata.totalCount, 1);
		this.assertEqualObjects( { id: 2, firstname: 'Justin' }, smalldata.data[0]);
	}

	public function test_Then_the_users_table_can_be_queried_for_authorization_if_no_ownerships()
	{
		var self = this;
		
		var smalldata = new RestDataCollection(0, 0, 1, [ { id: 123, firstname: 'Justin', lastname: 'Case' } ]);
		var data = new RestDataCollection(0, 0, 2, [ { id: 1, firstname: 'Boris', lastname: 'Doris' }, { id: 123, firstname: 'Justin', lastname: 'Case' } ]);
		
		this.rights.set('USERS', { guest: null, owner: { read: ['id', 'firstname'] }, admin: null } );
		this.ownerships = null; // Explicit just to be sure

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/123', url);
			return RestApiResponse.successData(data);
		}

		security.read('USERS', smalldata, parameters);
		
		this.assertEqual(smalldata.totalCount, 1);
		this.assertEqualObjects( { id: 123, firstname: 'Justin' }, smalldata.data[0]);
	}

	public function test_Then_if_owner_requests_more_than_he_owns_error_is_thrown()
	{
		var self = this;
		
		var smalldata = new RestDataCollection(0, 0, 1, [ { id: 2, firstname: 'Justin', lastname: 'Case' } ]);
		var data = new RestDataCollection(0, 0, 2, [ { id: 1, firstname: 'Boris', lastname: 'Doris' }, { id: 2, firstname: 'Justin', lastname: 'Case' } ]);
		
		rights.set('news', { guest: null, owner: { read: ['id', 'firstname'] }, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries//news', url);
			return RestApiResponse.successData(smalldata);
		}

		try
		{
			security.read('news', data, parameters);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Unauthorized access.$/, e.message);
		}
	}
	
	///// Update access ///////////////////////////////////////////////
	
	public function test_Then_admin_has_update_access_if_specified()
	{
		var self = this;
		
		rights.set('users', {guest: null, owner: null, admin: {update: 'ALL'} });

		// Set encoder method so the password is scrambled.
		security.userPasswordEncoder = haxe.Md5.encode;

		// The call without parameters won't make a rest api request, so this is for the second request:
		this.api.requests[0] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/[USER="Admin"][PASS="'+ haxe.Md5.encode('Admin123') +'"]', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 10, isAdmin: 1}]));
		}
		
		var params = new Hash<String>();
		params.set('username', 'Admin');
		params.set('password', 'Admin123');

		try
		{
			security.update('users', Lambda.list([1, 2, 3]), { name: 'Boris' }, null);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Unauthorized access.$/, e.message);
		}
		
		security.update('users', Lambda.list([4,5,6]), {name: 'Doris'}, params);
	}

	public function test_Then_owner_has_update_access_if_ids_are_owned()
	{
		var self = this;
		var data = new RestDataCollection(0, 0, 3, [ { id: 1, firstname: 'Boris', }, { id: 2, firstname: 'Doris' }, { id: 3, firstname: 'Toris' } ]);
		
		rights.set('libraries', { guest: null, owner: { update: 'ALL' }, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries', url);
			return RestApiResponse.successData(data);
		}
		
		security.update('libraries', Lambda.list([1, 2, 3]), { name: 'Boris' }, parameters);
	}

	public function test_Then_owner_has_no_access_if_not_all_ids_are_owned()
	{
		var self = this;
		
		// Logged-in user only owns one library in this case:
		var data = new RestDataCollection(0, 0, 1, [ { id: 2, firstname: 'Doris' } ]);
		
		rights.set('libraries', { guest: null, owner: { update: 'ALL' }, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries', url);
			return RestApiResponse.successData(data);
		}

		try
		{
			security.update('libraries', Lambda.list([1, 2, 3]), { name: 'Boris' }, parameters);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Unauthorized access.$/, e.message);
		}
	}
	
	///// Delete access /////////////////////////////////////////////
	
	public function test_Then_admin_has_delete_access_if_specified()
	{
		var self = this;
		
		rights.set('users', {guest: null, owner: null, admin: {delete: 'ALL'} });

		this.api.requests[0] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/USERS/[USER="User"][PASS="Pass\\"word"]', url);
			return RestApiResponse.successData(new RestDataCollection(0, 0, 1, [{id: 10, isAdmin: 1}]));
		}

		security.delete('users', Lambda.list([4, 5, 6]), parameters);
		
		try
		{
			security.delete('users', Lambda.list([4,5,6]), null);	
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Unauthorized access.$/, e.message);
		}
	}

	public function test_Then_owner_has_delete_access_if_ids_are_owned()
	{
		var self = this;
		var data = new RestDataCollection(0, 0, 3, [ { id: 1, firstname: 'Boris', }, { id: 2, firstname: 'Doris' }, { id: 3, firstname: 'Toris' } ]);
		
		rights.set('libraries', { guest: null, owner: { delete: 'ALL' }, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries', url);
			return RestApiResponse.successData(data);
		}
		
		security.delete('libraries', Lambda.list([1, 2, 3]), parameters);
	}

	public function test_Then_owner_cannot_delete_if_not_all_ids_are_owned()
	{
		var self = this;
		
		// Logged-in user only owns one library in this case:
		var data = new RestDataCollection(0, 0, 1, [ { id: 2, firstname: 'Doris' } ]);
		
		rights.set('libraries', { guest: null, owner: { delete: 'ALL' }, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries', url);
			return RestApiResponse.successData(data);
		}

		try
		{
			security.delete('libraries', Lambda.list([1, 2, 3]), parameters);
		}
		catch(e : RestApiException)
		{
			this.assertPattern(~/Unauthorized access.$/, e.message);
		}
	}

	///// Test callbacks ////////////////////////////////////////////
	
	public function test_Then_guest_callbacks_should_work_when_specified()
	{
		var self = this;
		
		Reflect.setField(this.callbacks, 'guestCreateNews', function(restApi : RestApiInterface, data : PropertyObject, ?parentResource : String, ?parentId : Int, ?parameters : Hash<String>) {
			self.assertEqualObjects(data, { name: 'ABC', count: 123 } );
		});
		
		rights.set('news', { guest: 'ALL', owner: null, admin: null } );

		security.create('news', { name: 'ABC', count: 123 }, null);
	}

	public function test_Then_guest_callbacks_should_throw_exception_when_failing()
	{
		var self = this;
		
		Reflect.setField(this.callbacks, 'guestCreateNews', function(restApi : RestApiInterface, data : PropertyObject, ?parentResource : String, ?parentId : Int, ?parameters : Hash<String>) {
			throw new RestApiException('Test error', RestErrorType.invalidData);
		});
		
		rights.set('news', { guest: 'ALL', owner: null, admin: null } );

		try
		{
			security.create('news', { name: 'ABC', count: 123 }, null);
		}		
		catch(e : RestApiException)
		{
			this.assertEqual('Test error', e.message);
		}
	}

	#if neko
	public function test_Then_callbacks_should_throw_RestApiException_when_incorrect_parameters()
	{
		var self = this;
		
		Reflect.setField(this.callbacks, 'guestCreateNews', function(restApi : RestApiInterface, data : String) {
			// Doing nothing but has invalid parameters.
		});
		
		rights.set('news', { guest: 'ALL', owner: null, admin: null } );

		try
		{
			security.create('news', { name: 'ABC', count: 123 }, null);
		}		
		catch(e : RestApiException)
		{
			this.assertEqual('Invalid parameters for callback "guestCreateNews".', e.message);
		}
	}
	#end

	public function test_Then_owner_callbacks_should_work_when_specified()
	{
		var self = this;
		
		Reflect.setField(this.callbacks, 'ownerCreateNews', function(restApi : RestApiInterface, data : PropertyObject, ?parentResource : String, ?parentId : Int, ?parameters : Hash<String>) {
			self.assertEqual(3, parentId);
			self.assertEqual('libraries', parentResource);
			self.assertEqualObjects({ name: 'ABC', count: 456, libraryId: 3 }, data);
		});

		rights.set('news', { guest: null, owner: { create: 'ALL' }, admin: null } );
		ownerships[0] = ['users', 'libraries', 'news'];

		var data = new RestDataCollection(0, 0, 1, [ { id: 3, name: 'TestLibrary' } ]);
		this.api.requests[1] = function(url : String) : RestApiResponse
		{
			self.assertEqual('/?/users/123/libraries', url);
			return RestApiResponse.successData(data);
		}

		security.create('news', { name: 'ABC', count: 456 }, 'libraries', 3, parameters);
	}
	
	public function test_Then_FieldValidator_can_be_integrated_in_rights()
	{
		var fields = { id: ~/^[1-9]\d*$/ }
		
		var callbacks : Dynamic = {};
		callbacks.name = function(name : String) { return name == 'Boris' ? 'Modded' : null; }
		
		var validation = new FieldValidator(fields, callbacks);
		
		rights.set('news', { guest: {read: validation, create: validation}, owner: null, admin: null } );

		// Validation ok.
		var data = { id: 123, name: 'Boris' };
		security.create('news', data);
		
		this.assertEqual(123, data.id);
		this.assertEqual('Modded', data.name);

		// Regexp incorrect
		try
		{
			security.create('news', { id: 0, name: 'Boris' });
		}
		catch(e : RestApiValidationException)
		{
			this.assertEqual(1, e.errorFields.length);
			this.assertEqual('id', e.errorFields.pop());
		}
		
		// Callback incorrect
		try
		{
			security.create('news', { id: 123, name: 'Doris' });
		}
		catch(e : RestApiValidationException)
		{
			this.assertEqual(1, e.errorFields.length);
			this.assertEqual('name', e.errorFields.pop());
		}
		
		// Missing fields
		try
		{
			security.create('news', { id: 123 });
		}
		catch(e : RestApiValidationException)
		{
			this.assertEqual(1, e.errorFields.length);
			this.assertEqual('name', e.errorFields.pop());
		}
		
		// Extra fields
		try
		{
			security.create('news', { name: 'ABC', count: 123 });
		}
		catch(e : RestApiException)
		{
			this.assertEqual('Unauthorized access to fields "count".', e.message);
		}
		
		// Read with validation is not allowed.
		try
		{
			security.read('news', new RestDataCollection(0, 0, 0, []));
		}
		catch(e : RestApiException)
		{
			this.assertEqual('Cannot have a FieldValidator in read access rights.', e.message);
		}		
	}
	
	/////////////////////////////////////////////////////////////////
	
	private function assertEqualObjects(o1 : Dynamic, o2 : Dynamic)
	{
		var f1 = Reflect.fields(o1);
		var f2 = Reflect.fields(o2);
		
		this.assertEqual(f1.length, f2.length);
		this.assertTrue(f1.isSubsetOf(f2));
		
		for(field in f1)
		{
			this.assertEqual(Reflect.field(o1, field), Reflect.field(o2, field));
		}
	}
}
