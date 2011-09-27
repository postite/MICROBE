package microbe

class Config
{
	public static var instance:Config;
	public function new()
	{
		
	}
	function getInstance() : Void {
		if(instance=null)instance= new Config();
		return instance;
	}
	
}