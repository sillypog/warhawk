import warhawk_v2.MessageCodes;

/***************************************************************************\
*																			*
*  The message format for Warhawk Widget Version 2							*
*																			*
*  Peter Hastie - 18th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Provides a standard format for updates from model						*
*																			*
\***************************************************************************/

class warhawk_v2.MessageBundle{
	
	// Make variables public so classes can exchange info through this
	public var dispatchingFunction:String;					// Holds the name of the model method that sent the message. Helps listeners decide if they need to act.
	public var messageType:String;							// The messageCode of this message. This should come from an enum to prevent messages going unhandled.
	public var messageInfo:String;							// The message body, eg an error message. This might not be included.
	
	/***************\
	* Constructor	*
	\***************/
	public function MessageBundle(sender:String, type:String, info:String){
		trace('MessageBundle: Constructor');
		
		// Build the bundle
		dispatchingFunction = sender;
		if (info){
			messageInfo = info;
		} else {
			messageInfo = ''; // Don't want 'undefined' appearing in messages to user
		}
		
		// Check that the type is ok before adding
		if (typeOk(type)){
			messageType = type;
		} else {
			// Want this to assert that it was ok.
			trace('MessageBundle: Constructor: messageType is unknown!');
		}
	}
	
	/*******************\
	* Private functions	*
	\*******************/
	private function typeOk(type:String):Boolean{
		trace('MessageBundle: typeOk()');
		var ok:Boolean = false
		for (var prop in MessageCodes){
			if (type == MessageCodes[prop]){
				trace('MessageBundle: typeOk(): type matches '+MessageCodes[prop]);
				ok = true;
				break;
			}
		}
		return(ok);
	}	
}