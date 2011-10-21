/**
 * ...
 * @author Matt Benton
 */

package poko.mail;

extern class PHPMailer
{	
	static function __init__(): Void untyped
	{
		var bootFile = untyped __call__("getcwd") + "/boot.phpmailer.php";
		// Load and run the PHPMailer's boot script if it exists in the current working directory.
		// (This is your chance to define PHP_MAILER_LIB_PATH to set a custom path to class.phpmailer.php);
		if ( untyped __call__("file_exists", bootFile ) )
			untyped __call__("require", bootFile);
		// If PHP_MAILER_LIB_PATH is defined, use it, otherwise look for library in ./externs/ directory.
		if ( untyped __call__("defined", "PHP_MAILER_LIB_PATH") )
			untyped __php__('require_once(PHP_MAILER_LIB_PATH . "class.phpmailer.php")');
		else
			untyped __call__("require_once", "./externs/class.phpmailer.php");
	}
	
	/////////////////////////////////////////////////
	// PROPERTIES, PUBLIC
	/////////////////////////////////////////////////

	/**
	* Email priority (1 = High, 3 = Normal, 5 = low).
	* @var int
	*/
	public var Priority : Int;

	/**
	* Sets the CharSet of the message.
	* @var string
	*/
	public var CharSet : String;

	/**
	* Sets the Content-type of the message.
	* @var string
	*/
	public var ContentType : String;

	/**
	* Sets the Encoding of the message. Options for this are
	*  "8bit", "7bit", "binary", "base64", and "quoted-printable".
	* @var string
	*/
	public var Encoding : String;

	/**
	* Holds the most recent mailer error message.
	* @var string
	*/
	public var ErrorInfo : String;

	/**
	* Sets the From email address for the message.
	* @var string
	*/
	public var From : String;

	/**
	* Sets the From name of the message.
	* @var string
	*/
	public var FromName : String;

	/**
	* Sets the Sender email (Return-Path) of the message.  If not empty,
	* will be sent via -f to sendmail or as 'MAIL FROM' in smtp mode.
	* @var string
	*/
	public var Sender : String;

	/**
	* Sets the Subject of the message.
	* @var string
	*/
	public var Subject : String;

	/**
	* Sets the Body of the message.  This can be either an HTML or text body.
	* If HTML then run IsHTML(true).
	* @var string
	*/
	public var Body : String;

	/**
	* Sets the text-only body of the message.  This automatically sets the
	* email to multipart/alternative.  This body can be read by mail
	* clients that do not have HTML email capability such as mutt. Clients
	* that can read HTML will view the normal Body.
	* @var string
	*/
	public var AltBody : String;

	/**
	* Sets word wrapping on the body of the message to a given number of
	* characters.
	* @var int
	*/
	public var WordWrap : Int;

	/**
	* Method to send mail: ("mail", "sendmail", or "smtp").
	* @var string
	*/
	public var Mailer : String;

	/**
	* Sets the path of the sendmail program.
	* @var string
	*/
	public var Sendmail : String;

	/**
	* Path to PHPMailer plugins.  Useful if the SMTP class
	* is in a different directory than the PHP include path.
	* @var string
	*/
	public var PluginDir : String;

	/**
	* Sets the email address that a reading confirmation will be sent.
	* @var string
	*/
	public var ConfirmReadingTo : String;

	/**
	* Sets the hostname to use in Message-Id and Received headers
	* and as default HELO string. If empty, the value returned
	* by SERVER_NAME is used or 'localhost.localdomain'.
	* @var string
	*/
	public var Hostname : String;

	/**
	* Sets the message ID to be used in the Message-Id header.
	* If empty, a unique id will be generated.
	* @var string
	*/
	public var MessageID : String;
	
	/////////////////////////////////////////////////
	// PROPERTIES FOR SMTP
	/////////////////////////////////////////////////

	/**
	* Sets the SMTP hosts.  All hosts must be separated by a
	* semicolon.  You can also specify a different port
	* for each host by using this format: [hostname:port]
	* (e.g. "smtp1.example.com:25;smtp2.example.com").
	* Hosts will be tried in order.
	* @var string
	*/
	public var Host : String;

	/**
	* Sets the default SMTP server port.
	* @var int
	*/
	public var Port : Int;

	/**
	* Sets the SMTP HELO of the message (Default is var Hostname).
	* @var string
	*/
	public var Helo : String;

	/**
	* Sets connection prefix.
	* Options are "", "ssl" or "tls"
	* @var string
	*/
	public var SMTPSecure : String;

	/**
	* Sets SMTP authentication. Utilizes the Username and Password variables.
	* @var bool
	*/
	public var SMTPAuth : Bool;

	/**
	* Sets SMTP username.
	* @var string
	*/
	public var Username : String;

	/**
	* Sets SMTP password.
	* @var string
	*/
	public var Password : String;

	/**
	* Sets the SMTP server timeout in seconds.
	* This function will not work with the win32 version.
	* @var int
	*/
	public var Timeout : Int;

	/**
	* Sets SMTP class debugging on or off.
	* @var bool
	*/
	public var SMTPDebug : Bool;

	/**
	* Prevents the SMTP connection from being closed after each mail
	* sending.  If this is set to true then to close the connection
	* requires an explicit call to SmtpClose().
	* @var bool
	*/
	public var SMTPKeepAlive : Bool;

	/**
	* Provides the ability to have the TO field process individual
	* emails, instead of sending to entire TO addresses
	* @var bool
	*/
	public var SingleTo : Bool;

	/**
	* If SingleTo is true, this provides the array to hold the email addresses
	* @var bool
	*/
	public var SingleToArray : Array<String>;

	/**
	* Provides the ability to change the line ending
	* @var string
	*/
	public var LE : String;

	/**
	* Used with DKIM DNS Resource Record
	* @var string
	*/
	public var DKIM_selector : String;

	/**
	* Used with DKIM DNS Resource Record
	* optional, in format of email address 'you@yourdomain.com'
	* @var string
	*/
	public var DKIM_identity : String;

	/**
	* Used with DKIM DNS Resource Record
	* optional, in format of email address 'you@yourdomain.com'
	* @var string
	*/
	public var DKIM_domain : String;

	/**
	* Used with DKIM DNS Resource Record
	* optional, in format of email address 'you@yourdomain.com'
	* @var string
	*/
	public var DKIM_private : String;

	/**
	* Callback Action function name
	* the function that handles the result of the send email action. Parameters:
	*   bool    var result        result of the send action
	*   string  var to            email address of the recipient
	*   string  var cc            cc email addresses
	*   string  var bcc           bcc email addresses
	*   string  var subject       the subject
	*   string  var body          the email body
	* @var string
	*/
	public var action_function : String;

	/**
	* Sets the PHPMailer Version number
	* @var string
	*/
	public var Version : String;
	
	/////////////////////////////////////////////////
	// METHODS, VARIABLES
	/////////////////////////////////////////////////
	
	public function new() : Void;
	
	/**
	* Sets message type to HTML.
	* @param bool $ishtml
	* @return void
	*/
	public function IsHTML( ?ishtml:Bool = true) : Void;

	/**
	* Sets Mailer to send message using SMTP.
	* @return void
	*/
	public function IsSMTP() : Void;

	/**
	* Sets Mailer to send message using PHP mail() function.
	* @return void
	*/
	public function IsMail() : Void;

	/**
	* Sets Mailer to send message using the $Sendmail program.
	* @return void
	*/
	public function IsSendmail() : Void;

	/**
	* Sets Mailer to send message using the qmail MTA.
	* @return void
	*/
	public function IsQmail() : Void;
	
	/////////////////////////////////////////////////
	// METHODS, RECIPIENTS
	/////////////////////////////////////////////////

	/**
	* Adds a "To" address.
	* @param string $address
	* @param string $name
	* @return boolean true on success, false if address already used
	*/
	public function AddAddress(address:String, ?name:String = '') : Bool;

	/**
	* Adds a "Cc" address.
	* Note: this function works with the SMTP mailer on win32, not with the "mail" mailer.
	* @param string $address
	* @param string $name
	* @return boolean true on success, false if address already used
	*/
	public function AddCC(address:String, ?name:String = '') : Bool;

	/**
	* Adds a "Bcc" address.
	* Note: this function works with the SMTP mailer on win32, not with the "mail" mailer.
	* @param string $address
	* @param string $name
	* @return boolean true on success, false if address already used
	*/
	public function AddBCC(address:String, ?name:String = '') : Bool;

	/**
	* Adds a "Reply-to" address.
	* @param string $address
	* @param string $name
	* @return boolean
	*/
	public function AddReplyTo(address:String, ?name:String = '') : Bool;

	/**
	* Set the From and FromName properties
	* @param string $address
	* @param string $name
	* @return boolean
	*/
	public function SetFrom(address:String, ?name:String = '', ?auto:Int = 1) : Bool;

	/**
	* Check that a string looks roughly like an email address should
	* Static so it can be used without instantiation
	* Tries to use PHP built-in validator in the filter extension (from PHP 5.2), falls back to a reasonably competent regex validator
	* Conforms approximately to RFC2822
	* @link http://www.hexillion.com/samples/#Regex Original pattern found here
	* @param string $address The email address to check
	* @return boolean
	* @static
	* @access public
	*/
	public static function ValidateAddress(address:String) : Bool;
	
	/////////////////////////////////////////////////
	// METHODS, MAIL SENDING
	/////////////////////////////////////////////////

	/**
	* Creates message and assigns Mailer. If the message is
	* not sent successfully then it returns false.  Use the ErrorInfo
	* variable to view description of the error.
	* @return bool
	*/
	public function Send() : Bool;
	
	/**
	* Initiates a connection to an SMTP server.
	* Returns false if the operation failed.
	* @uses SMTP
	* @access public
	* @return bool
	*/
	public function SmtpConnect() : Bool;
	
	/**
	* Closes the active SMTP session if one exists.
	* @return void
	*/
	public function SmtpClose() : Void;
	
	/**
	* Return the current array of language strings
	* @return array
	*/
	public function GetTranslations() : Array<String>;

	/////////////////////////////////////////////////
	// METHODS, MESSAGE CREATION
	/////////////////////////////////////////////////

	/**
	* Creates recipient headers.
	* @access public
	* @return string
	*/
	public function AddrAppend(type:String, addr:Array<String>) : String;

	/**
	* Formats an address correctly.
	* @access public
	* @return string
	*/
	public function AddrFormat(addr:String) : String;

	/**
	* Wraps message for use with mailers that do not
	* automatically perform wrapping and for quoted-printable.
	* Original written by philippe.
	* @param string $message The message to wrap
	* @param integer $length The line length to wrap to
	* @param boolean $qp_mode Whether to run in Quoted-Printable mode
	* @access public
	* @return string
	*/
	public function WrapText(message:String, length:Int, ?qp_mode:Bool = false) : String;
	
	/**
	* Finds last character boundary prior to maxLength in a utf-8
	* quoted (printable) encoded string.
	* Original written by Colin Brown.
	* @access public
	* @param string $encodedText utf-8 QP text
	* @param int    $maxLength   find last character boundary prior to this length
	* @return int
	*/
	public function UTF8CharBoundary(encodedText:String, maxLength:Int) : Int;

	/**
	* Set the body wrapping.
	* @access public
	* @return void
	*/
	public function SetWordWrap() : Void;

	/**
	* Assembles message header.
	* @access public
	* @return string The assembled header
	*/
	public function CreateHeader() : String;

	/**
	* Returns the message MIME.
	* @access public
	* @return string
	*/
	public function GetMailMIME() : String;

	/**
	* Assembles the message body.  Returns an empty string on failure.
	* @access public
	* @return string The assembled message body
	*/
	public function CreateBody() : String;
	
	/**
	*  Returns a formatted header line.
	* @access public
	* @return string
	*/
	public function HeaderLine(name:String, value:String) : String;

	/**
	* Returns a formatted mail line.
	* @access public
	* @return string
	*/
	public function TextLine(value:String) : String;

	/////////////////////////////////////////////////
	// CLASS METHODS, ATTACHMENTS
	/////////////////////////////////////////////////

	/**
	* Adds an attachment from a path on the filesystem.
	* Returns false if the file could not be found
	* or accessed.
	* @param string $path Path to the attachment.
	* @param string $name Overrides the attachment name.
	* @param string $encoding File encoding (see $Encoding).
	* @param string $type File extension (MIME) type.
	* @return bool
	*/
	public function AddAttachment(path:String, ?name:String = '', ?encoding:String = 'base64', ?type:String = 'application/octet-stream') : Bool;

	/**
	* Return the current array of attachments
	* @return array
	*/
	public function GetAttachments() : Array<Array<Dynamic>>;
	
	/**
	* Encodes string to requested format.
	* Returns an empty string on failure.
	* @param string $str The text to encode
	* @param string $encoding The encoding to use; one of 'base64', '7bit', '8bit', 'binary', 'quoted-printable'
	* @access public
	* @return string
	*/
	public function EncodeString(str:String, ?encoding:String = 'base64') : String;

	/**
	* Encode a header string to best (shortest) of Q, B, quoted or none.
	* @access public
	* @return string
	*/
	public function EncodeHeader(str:String, ?position:String = 'text') : String;

	/**
	* Checks if a string contains multibyte characters.
	* @access public
	* @param string $str multi-byte text to wrap encode
	* @return bool
	*/
	public function HasMultiBytes(str:String) : Bool;

	/**
	* Correctly encodes and wraps long multibyte strings for mail headers
	* without breaking lines within a character.
	* Adapted from a function by paravoid at http://uk.php.net/manual/en/function.mb-encode-mimeheader.php
	* @access public
	* @param string $str multi-byte text to wrap encode
	* @return string
	*/
	public function Base64EncodeWrapMB(str:String) : String;

	/**
	* Encode string to quoted-printable.
	* Only uses standard PHP, slow, but will always work
	* @access public
	* @param string $string the text to encode
	* @param integer $line_max Number of chars allowed on a line before wrapping
	* @return string
	*/
	public function EncodeQPphp(?input:String = '', ?line_max:Int = 76, ?space_conv:Bool = false) : String;
	
	/**
	* Encode string to RFC2045 (6.7) quoted-printable format
	* Uses a PHP5 stream filter to do the encoding about 64x faster than the old version
	* Also results in same content as you started with after decoding
	* @see EncodeQPphp()
	* @access public
	* @param string $string the text to encode
	* @param integer $line_max Number of chars allowed on a line before wrapping
	* @param boolean $space_conv Dummy param for compatibility with existing EncodeQP function
	* @return string
	* @author Marcus Bointon
	*/
	public function EncodeQP(string:String, ?line_max:Int = 76, ?space_conv:Bool = false) : String;

	/**
	* Encode string to q encoding.
	* @link http://tools.ietf.org/html/rfc2047
	* @param string $str the text to encode
	* @param string $position Where the text is going to be used, see the RFC for what that means
	* @access public
	* @return string
	*/
	public function EncodeQ (str:String, ?position:String = 'text') : String;
	
	/**
	* Adds a string or binary attachment (non-filesystem) to the list.
	* This method can be used to attach ascii or binary data,
	* such as a BLOB record from a database.
	* @param string $string String attachment data.
	* @param string $filename Name of the attachment.
	* @param string $encoding File encoding (see $Encoding).
	* @param string $type File extension (MIME) type.
	* @return void
	*/
	public function AddStringAttachment(string:String, filename:String, ?encoding:String = 'base64', ?type:String = 'application/octet-stream') : Void;

	/**
	* Adds an embedded attachment.  This can include images, sounds, and
	* just about any other document.  Make sure to set the $type to an
	* image type.  For JPEG images use "image/jpeg" and for GIF images
	* use "image/gif".
	* @param string $path Path to the attachment.
	* @param string $cid Content ID of the attachment.  Use this to identify
	*        the Id for accessing the image in an HTML form.
	* @param string $name Overrides the attachment name.
	* @param string $encoding File encoding (see $Encoding).
	* @param string $type File extension (MIME) type.
	* @return bool
	*/
	public function AddEmbeddedImage(path:String, cid:String, ?name:String = '', ?encoding:String = 'base64', ?type:String = 'application/octet-stream') : Bool;

	/**
	* Returns true if an inline attachment is present.
	* @access public
	* @return bool
	*/
	public function InlineImageExists() : Bool;

	/////////////////////////////////////////////////
	// CLASS METHODS, MESSAGE RESET
	/////////////////////////////////////////////////

	/**
	* Clears all recipients assigned in the TO array.  Returns void.
	* @return void
	*/
	public function ClearAddresses() : Void;

	/**
	* Clears all recipients assigned in the CC array.  Returns void.
	* @return void
	*/
	public function ClearCCs() : Void;

	/**
	* Clears all recipients assigned in the BCC array.  Returns void.
	* @return void
	*/
	public function ClearBCCs() : Void;

	/**
	* Clears all recipients assigned in the ReplyTo array.  Returns void.
	* @return void
	*/
	public function ClearReplyTos() : Void;

	/**
	* Clears all recipients assigned in the TO, CC and BCC
	* array.  Returns void.
	* @return void
	*/
	public function ClearAllRecipients() : Void;

	/**
	* Clears all previously set filesystem, string, and binary
	* attachments.  Returns void.
	* @return void
	*/
	public function ClearAttachments() : Void;

	/**
	* Clears all custom headers.  Returns void.
	* @return void
	*/
	public function ClearCustomHeaders() : Void;
	

	/////////////////////////////////////////////////
	// CLASS METHODS, MISCELLANEOUS
	/////////////////////////////////////////////////

	/**
	* Returns the proper RFC 822 formatted date.
	* @access public
	* @return string
	* @static
	*/
	public static function RFCDate() : String;
	
	/**
	* Returns true if an error occurred.
	* @access public
	* @return bool
	*/
	public function IsError() : Bool;

	/**
	* Adds a custom header.
	* @access public
	* @return void
	*/
	public function AddCustomHeader(custom_header:String) : Void;

	/**
	* Evaluates the message and returns modifications for inline images and backgrounds
	* @access public
	* @return $message
	*/
	public function MsgHTML(message:String, ?basedir:String = '') : String;

	/**
	* Gets the MIME type of the embedded or inline image
	* @param string File extension
	* @access public
	* @return string MIME type of ext
	* @static
	*/
	public static function _mime_types(?ext:String = '') : String;
}