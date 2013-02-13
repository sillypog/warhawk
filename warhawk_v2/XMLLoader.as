import warhawk_v2.LeaderboardModel;
import warhawk_v2.MessageCodes;
import mx.utils.Delegate; // This will let me alter the scope of the XML.onLoad function

/***************************************************************************\
*																			*
*  Handles all the XML loading for Warhawk Widget Version 2					*
*																			*
*  Peter Hastie - 18th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Complete URL is passed in from model									*
*																			*
\***************************************************************************/

class warhawk_v2.XMLLoader{
	
	private var xmlData:XML; // The XML object which will load and store the data
	
	private var requester:LeaderboardModel; // Stores a reference to the parent so that it can return the XML when loaded
	
	private var updateInterval:Number; // When XML is being loaded, this will hold ID of interval that checks progress
	
	/***************\
	* Constructor	*
	\***************/
	public function XMLLoader(_requester:LeaderboardModel){
		trace('XMLLoader: Constructor: new XMLLoader with '+LeaderboardModel+' passed');
		xmlData = new XML();
		xmlData.ignoreWhite = true;
		xmlData.onLoad = Delegate.create(this, xmlLoaded);
		//xmlData.onHTTPStatus = Delegate.create(this, httpError); // XML.onHTTPStatus is only available in Flash Player 8 and above
		requester = _requester;
	}
	
	/*******************\
	* Public functions	*
	\*******************/
	public function loadXML(url:String){
		trace('XMLLoader: loadXML(): Called with url='+url);
		// The base url is supplied. Format this into a query based on current parameters and load it
		var fullQuery:String = formatXMLQuery(url);
		xmlData.load(fullQuery);
		// Check progress at regular intervals
		clearInterval(updateInterval); // Just in case it was already set
		updateInterval = setInterval(this,"checkProgress",50); // Checks bytesLoaded every 50msecs
	}
	
	
	/*******************\
	* Private functions *
	\*******************/
	private function formatXMLQuery(baseURL:String):String{
		trace('XMLLoader: formatXMLQuery(): called with baseURL='+baseURL);
		// Have a base URl to build on
		var xmlQuery:String = baseURL;
		// Add the mode type to this
		var currentMode:String = requester.getMode();
		switch (currentMode){
			case 'Leaderboard'	:	xmlQuery += 'LeaderboardsXML.aspx?start='+requester.getRank()+'&end='+(requester.getRank()+19)+'&sort='+requester.getSortField(); break;
			case 'Head2Head'	:	xmlQuery += 'Head2HeadXMLFeed.aspx?'; break;
			case 'MyStats'		:	xmlQuery += 'I DONT KNOW HOW THIS SHOULD BE FORMATTED'; break;
			default				:	xmlQuery += 'MODE NOT RECOGNISED'; break;
		}
		trace('XMLLoader: formatXMLQuery(): complete URL = '+xmlQuery);
		return(xmlQuery);
	}
	
	private function xmlLoaded(success:Boolean){
		// Clear the progress checker
		clearInterval(updateInterval);
		if ((success) && (!xmlData.status)){
			trace('XMLLoader: xmlLoaded(): Success with status code='+xmlData.status);
			trace(xmlData);
			// Tell the model that there is new data - it will update views
			requester.processMessage(MessageCodes.DOWNLOAD_PROGRESS,100);
			// Check the status header of the XML
			var xmlHeaderStatus=checkStatusHeader(xmlData);
			if (xmlHeaderStatus==='OK'){
				requester.processMessage(MessageCodes.NEW_PLAYERS, xmlData);
			} else {
				requester.processMessage(MessageCodes.BAD_XML_STATUS, xmlHeaderStatus);
			}
		} else {
			trace('XMLLoader: xmlLoaded(): Failure with status code='+xmlData.status);
			// Tell the model that there is a problem - it will update views
			requester.processMessage(MessageCodes.XML_FAILURE, getStatus());
		}
	}
	
	private function getStatus():String{
		trace('XMLLoader: getstatus()');
		var errorMessage:String;
		switch(xmlData.status){
			case 0 	:  errorMessage = "No error; parse was completed successfully."; 			break;
    		case -2 :  errorMessage = "CDATA section not terminated.";							break;
    		case -3 :  errorMessage = "Declaration not terminated.";							break;
    		case -4 :  errorMessage = "DOCTYPE declaration not terminated.";  		 			break;
    		case -5 :  errorMessage = "Comment not terminated.";						        break;
    		case -6 :  errorMessage = "Malformed XML element.";								    break;
    		case -7 :  errorMessage = "Out of memory.";									        break;
    		case -8 :  errorMessage = "Attribute value not terminated.";  					    break;
    		case -9 :  errorMessage = "Start-tag not matched with end-tag.";	 		   	    break;
    		case -10:  errorMessage = "End-tag without matching start-tag."; 					break;
    		default :  errorMessage = "An unknown error has occurred.";					        break;
		}
		return(errorMessage);
	}

	
	/* //this function can only be used if the onHTTPerror handler is active (FP8+)
	private function httpError(httpStatus:Number){ 
		trace('XMLLoader: httpError(): error code = '+httpStatus);
		if (httpStatus != 200){
			// Alert the model that there was an error (it will inform the views)
			requester.processMessage(MessageCodes.HTTP_ERROR,httpStatus);
		}
	}
	*/
	
	
	private function checkProgress():Void{
		var downloadProgress = (xmlData.getBytesLoaded() / xmlData.getBytesTotal()) * 100;
		trace('XMLLoader: checkProgress(): '+downloadProgress+'% of XML feed loaded');
		// Tell the model
		// Watch out! Sometimes this returns NaN if it can't get bytesTotal quickly enough.
		//   Only send a reponse if !NaN
		// Also, it's unlikely that this will trigger at the moment when 100% is loaded. The completion event should trigger this separately.
		if (downloadProgress){
			requester.processMessage(MessageCodes.DOWNLOAD_PROGRESS,downloadProgress);
		}
	}
	
	private function checkStatusHeader(query:XML):String{
		// Check the code in the status header and return it
		var theStatus = query.childNodes[0].attributes["status"];
		trace('XMLLoader: checkStatusHeader(): status='+theStatus);
		return(theStatus);
		
	}
	
} // close class