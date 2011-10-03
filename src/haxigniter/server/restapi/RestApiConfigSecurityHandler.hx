package haxigniter.server.restapi;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#end

import haxe.PosInfos;
import haxigniter.server.exceptions.RestApiException;
import haxigniter.server.exceptions.RestApiValidationException;
import haxigniter.common.validation.FieldValidator;

import haxigniter.server.restapi.RestApiSecurityHandler;
import haxigniter.common.restapi.RestApiInterface;
import haxigniter.common.restapi.RestApiResponse;
import haxigniter.server.restapi.RestApiRequest;
import haxigniter.server.restapi.RestApiFormatHandler;

using haxigniter.common.libraries.IterableTools;

/////////////////////////////////////////////////////////////////////

typedef UserRights = {
	var guest : Dynamic;
	var owner : Dynamic;
	var admin : Dynamic;
}

typedef Ownerships = Array<Array<String>>;
typedef SecurityRights = Hash<UserRights>;
typedef AnonymousObject = Dynamic;

private enum AccessRights {
	all;
	fields(fields : Array<String>);
	validation(validation : FieldValidator);
}

/////////////////////////////////////////////////////////////////////

class RestApiConfigSecurityHandler implements RestApiSecurityHandler
{
	public var userResource : String;
	public var userNameField : String;
	public var userPasswordField : String;
	public var userPasswordEncoder : String -> String;

	public var userIsAdminField : String;
	public var userIsAdminValue : Dynamic;
	
	
	private static var validCallback = ~/^(admin|owner|guest)(Create|Read|Update|Delete)\w+$/;
	
	private var restApi : RestApiInterface;
	private var rights : SecurityRights;
	private var ownerships : Ownerships;
	private var callbacks : AnonymousObject;
	
	private var ownerID : Int;
	private var isAdmin : Bool;
	
	public function new(rights : SecurityRights, ?ownerships : Ownerships, ?callbacks: AnonymousObject)
	{
		this.isAdmin = false;
		this.userPasswordEncoder = haxe.Md5.encode;
		
		if(ownerships == null)
			ownerships = [];
		else
		{
			// Test ownership table for valid resources
			for(ownership in ownerships)
				if(ownerships.length < 2)
					throw new RestApiException('Single or empty ownership relations is not possible.', RestErrorType.configurationError);
		}
			
		if(callbacks != null)
		{
			// Test callbacks for valid names
			Lambda.iter(Reflect.fields(callbacks), function(funcName : String) {
				if(!validCallback.match(funcName))
					throw new RestApiException('Invalid callback name: ' + funcName, RestErrorType.configurationError);
			});
		}
		else
			callbacks = { };
		
		this.rights = rights;
		this.callbacks = callbacks;
		this.ownerships = ownerships;
	}
	
	///// Data access checks ////////////////////////////////////////

	private function dataResourceCheck(resourceName : String, ?pos : PosInfos) : UserRights
	{
		if(!this.rights.exists(resourceName))
			throw new RestApiException('No rights found for resource: ' + resourceName, RestErrorType.configurationError, null, pos);
		
		return this.rights.get(resourceName);
	}
	
	/**
	 * Returns true if the access is valid for the request input data.
	 * @param	accessObject
	 * @param	type
	 * @param	data
	 * @return
	 */
	private function testWriteAccess(access : Dynamic, data : PropertyObject) : Void
	{
		var rights : AccessRights = this.accessRights(access);
		
		switch(rights)
		{
			case all:
				// Access to all fields is allowed, but as default, no keys can be written to unless stated in the access array.
				
				if(Reflect.hasField(data, 'id'))
					throw new RestApiException('Field "id" cannot be modified.', RestErrorType.invalidData);

				var foreignKey = ~/[\w-]{2,}Id$/;
					
				for(dataField in Reflect.fields(data))
				{
					if(foreignKey.match(dataField))
						throw new RestApiException('Field "'+ dataField +'" cannot be modified.', RestErrorType.invalidData);
				}

					
			case fields(accessArray):
				// If user is writing this data, only allow a subset of the specified rules.
				var errorFields = new List<Dynamic>();
				
				for(dataField in Reflect.fields(data))
				{
					if(!Lambda.has(accessArray, dataField))
						errorFields.push(dataField);
				}
				
				if(errorFields.length > 0)
					throw new RestApiException('Unauthorized access to fields "' + errorFields.join(',') + '".', RestErrorType.unauthorizedRequest);
			
			case validation(validation):
				switch(validation.validate(data))
				{
					case tooMany(extraFields):
						throw new RestApiException('Unauthorized access to fields "' + extraFields.join(',') + '".', RestErrorType.unauthorizedRequest);
						
					case tooFew(missingFields):
						throw new RestApiValidationException(missingFields);
						
					case failure(fields):
						throw new RestApiValidationException(fields);
					
					case success:
						// All ok, pass through.
				}
		}
	}

	private function filterReadAccess(access : Dynamic, data : Array<PropertyObject>) : Void
	{
		var rights : AccessRights = this.accessRights(access);
		
		switch(rights)
		{
			case all:
				return;
				
			case fields(accessArray):
				for(i in 0 ... data.length)
				{
					var filtered = {};
					for(field in accessArray)
					{
						if(Reflect.hasField(data[i], field))
							Reflect.setField(filtered, field, Reflect.field(data[i], field));
					}
					
					data[i] = filtered;
				}

			case validation(validation):
				throw new RestApiException('Cannot have a FieldValidator in read access rights.', RestErrorType.configurationError);
		}
	}

	private function accessRights(access : Dynamic) : AccessRights
	{
		if(Std.is(access, String) && cast access == 'ALL')
			return AccessRights.all;
		else if(Std.is(access, Array))
			return AccessRights.fields(cast access);
		else if(Std.is(access, FieldValidator))
			return AccessRights.validation(cast access);
		else
			throw new RestApiException('Invalid data access type: ' + Type.typeof(access), RestErrorType.configurationError);
	}

	/////////////////////////////////////////////////////////////////
	
	private function buildOwnerRequest(resourceName : String, table : Array<String>, createRequest : Bool) : String
	{
		if(this.ownerID == null)
			throw new RestApiException('Unauthorized owner data access.', RestErrorType.unauthorizedRequest);
		
		var resourcePos = table.arraySearch(resourceName);
		if(resourcePos == null) return null;
		
		// If a create request is made, strip the last table since the request should get the foreign key.
		var requestTable : Array<String>;
		
		if(resourcePos > 0)
			requestTable = createRequest ? table.slice(1, resourcePos) : table.slice(1, resourcePos + 1);
		else
			requestTable = [];
		
		// [users, libraries, news] becomes /?/users/ownerID/libraries//news
		return '/?/' + table[0] + '/' + this.ownerID + '/' + requestTable.join('//');
	}

	private function mapIds(data : Iterable<Dynamic>) : List<Int>
	{
		return Lambda.map(data, function(row : Dynamic) {
			if(!Reflect.hasField(row, 'id'))
				throw new RestApiException('Field "id" not found when mapping ids.', RestErrorType.configurationError);
			else if(Std.is(row.id, Int))
				return untyped row.id;
			else
				throw new RestApiException('Field "id" is not an integer.', RestErrorType.configurationError);
		});
	}
	
	private var requestIdsCache : Hash<List<Int>>;
	private function requestIds(request : String) : List<Int>
	{
		if(this.requestIdsCache == null)
			this.requestIdsCache = new Hash<List<Int>>();

		if(!this.requestIdsCache.exists(request))
		{
			var self = this;
			
			// Make the request and set key/value if it returns ok.
			this.restApi.read(request, function(response : RestApiResponse)
			{
				switch(response)
				{
					case successData(responseData):
						self.requestIdsCache.set(request, self.mapIds(responseData));
						
					default:
						throw new RestApiException('Ids request failed.', RestErrorType.unknown);
				}
			});
		}

		return this.requestIdsCache.get(request);
	}
	
	private function setDataOwnership(data : PropertyObject, resource : String, id : Int) : Void
	{
		var keyField = (resource == 'id') ? 'id' : haxigniter.common.libraries.Inflection.singularize(resource) + 'Id';
		Reflect.setField(data, keyField, id);
	}
	
	private function testDataOwnership(resourceName : String, ids : Iterable<Int>, createRequest : Bool) : Void
	{
		if(this.ownerID == null)
			throw new RestApiException('Unauthorized owner data access.', RestErrorType.unauthorizedRequest);

		for(ownerTable in this.ownerships)
		{
			var request = buildOwnerRequest(resourceName, ownerTable, createRequest);
			if(request == null) continue;
			
			if(!ids.isSubsetOf(this.requestIds(request)))
				this.authorizationFailed();
		}
		
		// If no ownerships are set, test if the userResource (user table) is used. That's allowed to authorize logins.
		if(this.userResource != null && resourceName == this.userResource)
		{
			if(!ids.isSubsetOf(this.requestIds('/?/' + this.userResource + '/' + this.ownerID)))
				this.authorizationFailed();
		}
	}
	
	/////////////////////////////////////////////////////////////////

	/**
	 * After this method is called, this.ownerID and this.isAdmin is set or exception is thrown.
	 * @param	parameters
	 */
	private function authorizeUser(parameters : Hash<String>) : Void
	{
		if(parameters == null || (!parameters.exists('username') && !parameters.exists('password')))
			return;
		
		if(!parameters.exists('username') || !parameters.exists('password'))
			throw new RestApiException('Missing parameters "username" or "password" when authorizing user.', RestErrorType.unauthorizedRequest);
		
		// Encode password if a special function for that exists.
		var password = parameters.get('password');
		
		if(userPasswordEncoder != null)
			password = userPasswordEncoder(password);
			
		var self = this;
		var authorizeString = '/?/' + this.userResource + '/' +
			'[' + this.userNameField + '="' + StringTools.replace(parameters.get('username'), '"', '\\"') + '"]' +
			'[' + this.userPasswordField + '="' + StringTools.replace(password, '"', '\\"') + '"]';
		
		this.restApi.read(authorizeString, function(response : RestApiResponse) {
			switch(response)
			{
				case successData(data):
					if(data.totalCount == 1)
					{
						var userRow = data.data[0];
						
						if(!Reflect.hasField(userRow, 'id'))
							throw new RestApiException('Field "id" not found when authorizing user.', RestErrorType.configurationError);
						
						self.ownerID = userRow.id;
						
						if(self.userIsAdminField != null && Reflect.hasField(userRow, self.userIsAdminField))
							self.isAdmin = Reflect.field(userRow, self.userIsAdminField) == self.userIsAdminValue;
						
						return;
					}
					
				default:
			}
			
			throw new RestApiException('Invalid username or password.', RestErrorType.unauthorizedRequest);
		});
	}

	private function accessFor(type : RestApiRequestType, access : Dynamic) : Dynamic
	{
		if(access == null) return null;
		if(access == 'ALL') return 'ALL';
		
		var typeString = Std.string(type);
		return Reflect.hasField(access, typeString) ? Reflect.field(access, typeString) : null;
	}

	private function authorizationFailed(message = 'Unauthorized access.', ?pos : PosInfos) : Void
	{
		throw new RestApiException(message, RestErrorType.unauthorizedRequest, null, pos);
	}

	///// RestApiSecurityHandler implementation /////////////////////
	
	public function create(resourceName : String, data : PropertyObject, ?parentResource : String, ?parentId : Int, ?parameters : Hash<String>) : Void
	{
		if(data == null || Reflect.fields(data).length == 0)
			throw new RestApiException('No request data found!', RestErrorType.invalidData);

		var self = this;
		
		var testWriteAccess = function(access : Dynamic) : Bool
		{
			self.testWriteAccess(access, data);
			return true;
		}

		requestAccess(resourceName, parameters, RestApiRequestType.create,
			testWriteAccess,
			
			function(access : Dynamic) : Bool
			{
				// An owner must have a parent resource specified to determine the foreign key (ownership key)
				if(parentResource == null || parentId == null) return false;

				self.testWriteAccess(access, data);
				
				// If data access was ok, add foreign key to data if needed.
				self.testDataOwnership(resourceName, [parentId], true);
				self.setDataOwnership(data, parentResource, parentId);
				return true;
			},
			
			testWriteAccess,
			
			function(callBack : Dynamic) : Void
			{
				// Dynamic callback based on request type.
				callBack(self.restApi, data, parentResource, parentId, parameters);
			}
		);		
	}
	
	public function read(resourceName : String, data : RestDataCollection, ?parameters : Hash<String>) : Void
	{
		var self = this;
		
		var filterReadAccess = function(access : Dynamic) : Bool
		{
			self.filterReadAccess(access, data.data);
			return true;
		}
		
		requestAccess(resourceName, parameters, RestApiRequestType.read,
			filterReadAccess,
		
			function(access : Dynamic) : Bool
			{
				self.testDataOwnership(resourceName, self.mapIds(data), false);
				return filterReadAccess(access);
			},
			
			filterReadAccess,
			
			function(callBack : Dynamic) : Void
			{
				callBack(self.restApi, data, parameters);
			}
		);
	}
	
	public function update(resourceName : String, ids : List<Int>, data : PropertyObject, ?parameters : Hash<String>) : Void
	{
		var self = this;
		
		var testWriteAccess = function(access : Dynamic) : Bool
		{
			self.testWriteAccess(access, data);
			return true;
		}
		
		requestAccess(resourceName, parameters, RestApiRequestType.update,
			testWriteAccess,
			
			function(access : Dynamic) : Bool
			{
				self.testDataOwnership(resourceName, ids, false);
				self.testWriteAccess(access, data);
				return true;
			},
			
			testWriteAccess,

			function(callBack : Dynamic) : Void
			{
				callBack(self.restApi, ids, data, parameters);
			}
		);
	}
	
	public function delete(resourceName : String, ids : List<Int>, ?parameters : Hash<String>) : Void
	{
		var self = this;
		
		var allowDeleteAccess = function(access : Dynamic) { return true; }
		
		requestAccess(resourceName, parameters, RestApiRequestType.delete,
			allowDeleteAccess,
			
			function(access : Dynamic) : Bool
			{
				self.testDataOwnership(resourceName, ids, false);
				return true;
			},
			
			allowDeleteAccess,

			function(callBack : Dynamic) : Void
			{
				callBack(self.restApi, ids, parameters);
			}
		);
	}
	
	public function install(api : RestApiInterface) { this.restApi = api; }
	
	/////////////////////////////////////////////////////////////////

	private function requestAccess(resourceName : String, parameters : Hash<String>, type : RestApiRequestType, 
									adminAuthorized : Dynamic -> Bool, ownerAuthorized : Dynamic -> Bool, guestAuthorized : Dynamic -> Bool,
									callBack : Dynamic -> Void) : Void
	{
		var rights : UserRights = this.dataResourceCheck(resourceName);
		var access : Dynamic;

		this.authorizeUser(parameters);

		if(this.isAdmin)
		{
			access = this.accessFor(type, rights.admin);
			if(access != null && adminAuthorized(access))
			{
				testCallback(resourceName, type, 'admin', callBack);
				return;
			}
		}
		
		if(this.ownerID != null)
		{
			access = this.accessFor(type, rights.owner);			
			if(access != null && ownerAuthorized(access))
			{
				testCallback(resourceName, type, 'owner', callBack);
				return;
			}
		}
		
		// It's determined that the user is not admin nor owner of the requested data.
		// Make a final attempt with guest access.
		access = this.accessFor(type, rights.guest);
		if(access != null && guestAuthorized(access))
		{
			testCallback(resourceName, type, 'guest', callBack);
			return;
		}
		
		this.authorizationFailed();
	}
	
	private function testCallback(resourceName : String, type: RestApiRequestType, user: String, callBack : Dynamic -> Void) : Void
	{
		var typeString = Std.string(type);
		var methodName = user.toLowerCase() + typeString.substr(0, 1).toUpperCase() + typeString.substr(1) + resourceName.substr(0, 1).toUpperCase() + resourceName.substr(1);

		if(!Reflect.hasField(this.callbacks, methodName))
			return;
		else
		{
			#if php
			callBack(Reflect.field(this.callbacks, methodName));
			#elseif neko
			try
			{
				callBack(Reflect.field(this.callbacks, methodName));
			}
			catch(e : String)
			{
				if(e == 'Invalid call')
					throw new RestApiException('Invalid parameters for callback "' + methodName + '".', RestErrorType.configurationError);
				else
					Lib.rethrow(e);
			}
			#end
		}
	}
}
