/**
 * ...
 * @author Tarwin Stroh-Spijer
 */

package com.touchmypixel.mail;
import poko.Db;

class MailQueue 
{
	private var smtp:SimpleSmtp;
	private var db:Db;
	private var table:String;
	
	public function new(simpleSmtp:SimpleSmtp, database:Db, dbTable:String) 
	{
		smtp = simpleSmtp;
		db = database;
		table = dbTable;
	}
	
    /**
     * Returns the number of emails currently in the queue.
     *
     * @return int
     */	
	public function getQueueCount():Int
	{
		return(1);
	}
	
	/**
	 * Keep memory under control. You can set the max number
	 * of mails that can be in the preload buffer at any given time.
	 * It won't limit the number of mails you can send, just the
	 * internal buffer size.
	 * 
	 * @param	size  Optional - internal preload buffer size
	 */
	public function setBufferSize(size:Int = 10)
	{
		
	}
	
   /**
     * Send mails fom queue.
     *
     * @param integer $limit     Optional - max limit mails send.
     *                           This is the max number of emails send by
     *                           this function.
     * @param integer $offset    Optional - you could load mails from $offset (by id)
     * @param integer $try       Optional - hoh many times mailqueu should try send
     *                           each mail. If mail was sent succesful it will be
     *                           deleted from Mail_Queue.
     * @param mixed   $callback  Optional, a callback (string or array) to save the
     *                           SMTP ID and the SMTP greeting.
     *
     * @return mixed  True on success else MAILQUEUE_ERROR object.
     */
    function sendMailsInQueue(limit = -1, offset = 0, tryTimes = 25, callback = null)
    {
        $this->container->setOption($limit, $offset, $try);
        while ($mail = $this->get()) {
            $this->container->countSend($mail);

            $result = $this->sendMail($mail, true);
            if (PEAR::isError($result)) {
                //remove the problematic mail from the buffer, but don't delete
                //it from the db: it might be a temporary issue.
                $this->container->skip();
                PEAR::raiseError(
                    'Error in sending mail: '.$result->getMessage(),
                    MAILQUEUE_ERROR_CANNOT_SEND_MAIL, PEAR_ERROR_TRIGGER,
                    E_USER_NOTICE
                );
            } else {
                //take care of callback first, as it may need to retrieve extra data
                //from the mail_queue table.
                if ($callback !== null) {
                    call_user_func($callback,
                        array('id' => $mail->getId(),
                              'queued_as' => $this->queued_as,
                              'greeting'  => $this->greeting));
                }
                if ($mail->isDeleteAfterSend()) {
                    $this->deleteMail($mail->getId());
                }
            }
            if (isset($this->mail_options['delay'])
                && $this->mail_options['delay'] > 0) {
                sleep($this->mail_options['delay']);
            }
        }
        if (!empty($this->mail_options['persist']) && is_object($this->send_mail)) {
            $this->send_mail->disconnect();
        }
        return true;		
	}
}