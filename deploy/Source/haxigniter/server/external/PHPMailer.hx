#if php
package haxigniter.server.external;

/**
 * How to use: 
 * 
 *   1. Set your external directory in config.externalPath.
 *   2. Copy the phpmailer directory to the externalPath.
 *   3. Use Server.requireExternal('phpmailer/class.phpmailer.php') to include it.
 * 
 * Then it works just like any other haXe class.
 * 
 */
extern class PHPMailer 
{
	public function new(mode : Bool) : Void;

	public function SetFrom(email : String, name : String = '') : Void;
	public function MsgHTML(html : String) : Void;

	public function AddAddress(email : String, name : String = '') : Void;
	public function AddReplyTo(email : String, name : String = '') : Void;
	public function AddBCC(email : String, name : String = '') : Void;
	public function AddCC(email : String, name : String = '') : Void;

	public function AddAttachment(fileName : String, name : String = '', encoding : String = 'base64', type : String = 'application/octet-stream') : Bool;

	public function Send() : Bool;
	
	public function ClearAddresses() : Void;
	public function ClearCCs() : Void;
	public function ClearBCCs() : Void;
	public function ClearReplyTos() : Void;
	public function ClearAllRecipients() : Void;
	public function ClearAttachments() : Void;
	public function ClearCustomHeaders() : Void;
	
	public function IsHTML(html : Bool) : Void;
	public function IsMail() : Void;
	public function IsSMTP() : Void;
	public function IsSendmail() : Void;
	public function IsQmail() : Void;
	
	/////////////////////////////////////////////////////////////////
	
	public var Priority : Int;
	public var CharSet : String;
	public var ContentType : String;
	public var Encoding : String; // Sets the Encoding of the message. Options for this are "8bit", "7bit", "binary", "base64", and "quoted-printable"
	public var ErrorInfo : String;

	public var From : String;
	public var FromName : String;
	public var Sender : String;
	public var Subject : String;
	public var Body : String;
	public var AltBody : String;
	public var WordWrap : Int;
	public var Mailer : String; // Method to send mail: ("mail", "sendmail", or "smtp").
	public var Sendmail : String;
	public var PluginDir : String;
	
	public var ConfirmReadingTo : String;
	
	public var Hostname : String;
	public var Host : String;
	public var Port : Int;
	public var Helo : String;
	public var SMTPAuth : Bool;
	public var Username : String;
	public var Password : String;
	public var Timeout : Int;
	public var SMTPDebug : Bool;
	public var SMTPKeepAlive : Bool;
	
	public var SingleTo : Bool;
}
#end