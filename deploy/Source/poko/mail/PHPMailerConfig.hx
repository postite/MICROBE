/**
 * ...
 * @author Matt Benton
 */

package poko.mail;

class PHPMailerConfig 
{	
	// Method to send mail: ("mail", "sendmail", or "smtp").
	public var mailer : String;
	
	
	/**
	 * SMTP variables
	 */	
	// SMTP host(s). Separate multiple hosts with a semicolon. Can use colons to specify individual ports.
	public var smtpHost : String;
	public var smtpPort : Int;
	
	// Whether or not to authenticate when using SMTP.
	public var smtpAuth : Bool;
	
	// SMTP username and password when using authentication.
	public var smtpUser : String;
	public var smtpPass : String;
	
	public var smtpTimeout : Int;
	// Prevents SMTP connections from closing after sending each mail. Must call SmtpClose() on PHPMailer when done.
	public var smtpKeepAlive : Bool;
	// Can be either blank, 'ssl' or 'tls'.
	public var smtpProtocol : String;
	
	public function new()
	{
		mailer = "mail";
		smtpHost = "localhost";
		smtpPort = 25;
		smtpProtocol = "";
		smtpAuth = false;
		smtpUser = "";
		smtpPass = "";
		smtpTimeout = 10;
		smtpKeepAlive = false;
	}
	
	static public function getSMTP(host:String, username:String, password:String) : PHPMailerConfig
	{
		return null;
	}
	
	public function apply(phpMailer:PHPMailer) : Void
	{
		validate();
		
		phpMailer.Mailer 			= mailer;
		
		phpMailer.Host 				= smtpHost;
		phpMailer.Port 				= smtpPort;
		phpMailer.SMTPAuth 			= smtpAuth;
		phpMailer.Username 			= smtpUser;
		phpMailer.Password 			= smtpPass;
		phpMailer.Timeout 			= smtpTimeout;
		phpMailer.SMTPKeepAlive 	= smtpKeepAlive;
		phpMailer.SMTPSecure 		= smtpProtocol;
	}
	
	public function getDebugInfo(?lineBreak:String="<br/>") : String
	{
		var str = "";
		for ( f in Reflect.fields(this) )
		{
			str += f + " = '" + Reflect.field(this, f) + "'" + lineBreak;
		}
		return str;
	}
	
	public function validate() : Void
	{
		if ( smtpProtocol != "" && smtpProtocol != "ssl" && smtpProtocol != "tls" )
			throw "SMTP protocol type '" + smtpProtocol + "' is not a valid protocol. Must be either blank, 'ssl' or 'tls'.";
		
		if ( mailer != "mail" && mailer != "sendmail" && mailer != "smtp" )
			throw "Mailer type '" + mailer + "' is not a valid mailing method. Must be either 'mail', 'sendmail' or 'smtp'.";
	}
	
	public function load(filePath:String) : PHPMailerConfig
	{
		var prevMailer = mailer;
		
		untyped __call__("require", filePath);
		
		validate();
		
		return this;
	}
}