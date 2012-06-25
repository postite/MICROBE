package config; 
import haxigniter.server.libraries.Database;

/* =============================================================== */
/* ===== Database configuration file ============================= */
/* =============================================================== */

/*
|--------------------------------------------------------------------------
| Development (local) connection
|--------------------------------------------------------------------------
|
| These database settings will be used when Config.development is true.
| Set them as appropriate.
|
*/
/*class DevelopmentConnection extends Database
{
	public function new()
	{
		this.host = 'localhost';
		this.user = 'root';
		this.pass = 'root';
		this.database = 'tambour';
		this.driver = DatabaseDriver.mysql; // Can also be sqlite, then Database will be used as filename.
		this.debug = null; // Displays debug information on database/query errors if set.
		this.port = 3306;
		this.socket = null;
	}
}*/



class DevelopmentConnection extends Database
{
	public function new()
	{
		this.host = 'localhost';
		this.user = 'root';
		this.pass = 'root';
		this.database = 'spodmacro';
		this.driver = DatabaseDriver.mysql; // Can also be sqlite, then Database will be used as filename.
		this.debug = null; // Displays debug information on database/query errors if set.
		this.port = null;//3306;
		this.socket = null;
		
	}
}

/*
|--------------------------------------------------------------------------
| Online (live) connection
|--------------------------------------------------------------------------
|
| These database settings will be used when Config.development is false.
|
*/
class OnlineConnection extends Database
{
	public function new()
	{
		this.host = 'mysql.alwaysdata.com';
		this.user = 'postite';
		this.pass = 'paglop';
		this.database = 'postite_tambour';
		this.driver = DatabaseDriver.mysql; // Can also be sqlite, then Database will be used as filename.
		this.debug = null; // Displays debug information on database/query errors if set.
		this.port = null;//3306;
		this.socket = null;
	}
}
