import util.*; // Get superclasses for Observer pattern
import warhawk_v2.*; // Specific classes to the Warhawk leaderboard

/***************************************************************************\
*																			*
*  The model for Warhawk Widget Version 2									*
*																			*
*  Peter Hastie - 18th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Load XML																*
*  - Parse XML and extract data for each player into useful structure		*
*  - Store the current state of the application								*
*  - Allow Observers to subscribe and unscribe from change events			*
*  - Dispatch change events to subscribers									*
*																			*
\***************************************************************************/

class warhawk_v2.LeaderboardModel extends AbstractQueuingObservable{
	
	private var xmlURL:String; 						// The URL to be called to get the data
	private var xmlLoader:XMLLoader; 				// Handles XML requests
	
	private var playerList:PlayerList; 				// warhawk_v2.PlayerList contains array of PlayerData objects where player data is stored
	
	private var applicationModes:Array; 			// Either Leaderboard, Head2Head or MyStats
	private var modeIndex:Number; 					// Points to the current mode 
	
	private var currentState:String;				// Is either single or multi
	
	private var sortFields:Array;					// The fields that the user can sort data by - set when PlayerList gets data
	private var sortFieldIndex:Number;				// Points to the current sort field for downloading data
	private var textDisplayIndex:Number;			// Points to the current field to have values shown as text
	private var graphDisplayIndex:Number;			// Points to the current field to have values shown as bars
	
	private var currentSinglePlayer:Number;			// Points to the player in playerList whose data is shown in single state
	
	private var rank:Number;						// The current lowest rank in memory
	
	
	/***************\
	* Constructor	*
	\***************/
	public function LeaderboardModel(){
		trace('LeaderboardModel: Constructor: new LeaderboardModel made');
		
		// Set up the application modes
		applicationModes = new Array('Leaderboard','Head2Head','MyStats');
		modeIndex=0; // Begin in Leaderboard state
		// Set up the sort fields
		sortFields = new Array('GAME_POINTS',
							   'TEAM_SCORE',
							   'BONUS_SCORE',
							   'GLOBAL_TIME',
							   'KILLS',
							   'DEATHS',
							   'KDR',
							   'GLOBAL_ACCURACY',
							   'WINS',
							   'LOSSES',
							   'WIN_LOSS_RATIO',
							   'SCORE_PER_MIN',
							   'DM_SCORE',
							   'TDM_SCORE',
							   'CTF_SCORE',
							   'ZONES_SCORE',
							   'MILES_WALKED',
							   'MILES_DRIVEN',
							   'MILES_FLOWN');	
		sortFieldIndex = 0;
		textDisplayIndex = 0;
		graphDisplayIndex = 0;
		rank = 1;		// Start by getting the first player
		currentState = 'multi';
		
		// Set up the XMLLoader object
		xmlLoader = new XMLLoader(this);
		
		// Set up the list of players: the actual data to be displayed
		playerList = new PlayerList();
		
		// Set up the messageQueue
		messageQueue  = new Array();
		
		
	} // End constructor
	
	
	/*******************\
	* Public functions	*
	\*******************/
	public function loadXML(url:String):Void{
		// Requests new XML from the XMLLoader but doesn't receive it, this is done by incomingXML()
		trace('LeaderboardModel: loadXML(): loading '+url);
		xmlURL = url;
		xmlLoader.loadXML(url);
	}
	
	
	
	public function processMessage(messageType:String, messageBody:Object):Void{
		trace('LeaderboardModel: processMessage()');
		switch (messageType){
			case MessageCodes.NEW_PLAYERS: 			updatePlayerData(XML(messageBody)); 					break;
			case MessageCodes.DOWNLOAD_PROGRESS:	updateDownloadProgress(Number(messageBody)); 			break;
			case MessageCodes.ANIMATION_COMPLETE:	animationComplete(messageBody);							break;
			case MessageCodes.HTTP_ERROR :			errorDetected(messageType, String(messageBody)); 		break;
			case MessageCodes.XML_FAILURE:			errorDetected(messageType, String(messageBody));		break;
			case MessageCodes.BAD_XML_STATUS:		errorDetected(messageType); 							break;
		}
	}
	
	
		
	public function setMode(newMode:String){
		if (newMode){
			trace('LeaderboardModel: setMode(): called with newMode = '+newMode);
			// Set the model index to this
			switch (newMode){
				case'Leaderboard': modeIndex = 0; break;
				case'Head2Head': modeIndex =1; break;
				case'MyStats': modeIndex =2; break;
			}
		} else {
			trace('LeaderboardModel: setMode(): called with no arguments ');
			// Advance the index, or set to zero
			if (modeIndex < applicationModes.length-1){
				modeIndex++;
			} else {
				modeIndex=0;
			}
		}
		// send an update
		var infoObj:Object = new MessageBundle('setMode',MessageCodes.MODE_CHANGE,applicationModes[modeIndex]);
		setChanged();
		notifyObservers(infoObj);
	}
	
	public function getMode():String{
		trace('LeaderboardModel: getMode(): mode is '+applicationModes[modeIndex]);
		return(applicationModes[modeIndex]);
	}
	
	
	public function getPlayerListLength():Number{
		trace('LeaderboardModel: getPlayerListLength()');
		return (playerList.getLength());
	}
	
	public function getPlayerData(index:Number):Object{
		trace('LeaderboardModel: getPlayerData(): getting data at index '+index);
		return (playerList.getPlayerData(index));
	}
	
	public function getSortField():String{
		trace('LeaderboardModel: getSortField(): field is'+sortFields[sortFieldIndex]);
		return (sortFields[sortFieldIndex]);
	}
	
	public function setRank(setTo:Number){
		trace('LeaderboardModel: setRank(): setting to '+setTo);
		// Obviously don't want to go less than zero
		if (setTo > 0){
			rank = setTo;
		} else {
			rank = 0;
		}
		// This means we need to reload the data - these two are always linked
		xmlLoader.loadXML(xmlURL);
	}
	
	public function getRank():Number{
		trace('LeaderboardModel: getRank(): rank is '+rank);
		return (rank);
	}
	
	public function setTextDisplayField(field:String):Void{
		trace('LeaderboardModel: setTextDisplayField()');
		switch (field){
			case 'next'		: textDisplayIndex < sortFields.length -1 	? textDisplayIndex++ : textDisplayIndex = 0; 	break;
			case 'previous' : textDisplayIndex > 0 						? textDisplayIndex-- : textDisplayIndex = sortFields.length -1;	break;
		}
		trace('LeaderboardModel: setTextDisplayField(): display field is now '+getTextDisplayField());
		// send an update
		var infoObj:Object = new MessageBundle('setTextDisplayField',MessageCodes.TEXT_FIELD_CHANGE,sortFields[textDisplayIndex]);
		setChanged();
		notifyObservers(infoObj);
	}
	
	public function getTextDisplayField():String{
		// This will return which ever field is currently being used for the sort
		trace('LeaderboardModel: getTextDisplayField()');
		return (sortFields[textDisplayIndex]);
	}
	
	public function getGraphDisplayField():String{
		trace('LeaderboardModel: getGraphDisplayField()');
		return(sortFields[graphDisplayIndex]);
	}
	
	public function toggleState():Void{
		trace('LeaderboardModel: toggleState()');
		if (getState() == 'single'){
			currentState = 'multi';
		} else {
			currentState = 'single';
		}
		// don't tell the views that the state has changed yet. Play animation first
		trace('LeaderboardModel: toggleState(): sending WIPE_SCREEN, should not be queued');
		var infoObj:Object = new MessageBundle('toggleState',MessageCodes.WIPE_SCREEN,null);
		setChanged();
		notifyObservers(infoObj);
		// store the state change on the message queue for now
		trace('LeaderboardModel: toggleState(): Setting queued and sending a STATE_CHANGE event');
		setQueuing(true);
		messageQueue.push(new MessageBundle('toggleState',MessageCodes.STATE_CHANGE,getState()));
	}
	
	public function getState():String{
		trace('LeaderboardModel: getState()');
		return(currentState);
	}
	
	public function getCurrentSinglePlayer():Number{
		trace('LeaderboardModel: getCurrentSinglePlayer(): index is '+currentSinglePlayer);
		return(currentSinglePlayer);
	}
	
	public function setCurrentSinglePlayer(index:Number):Void{
		trace('LeaderboardModel: setCurrentSinglePlayer(): index will be set to '+index);
		// Check that we're within range or throw an error
		if ((index >= 0) && (index < getPlayerListLength())){
			currentSinglePlayer = index;
			// send an update
			var infoObj:Object = new MessageBundle('setCurrentSinglePlayer',MessageCodes.PLAYER_CHANGE,String(currentSinglePlayer));
			setChanged();
			notifyObservers(infoObj);
		} else if (index >= getPlayerListLength()){
			// Load in the next 20 players and reset the current single
			trace('LeaderboardModel: setCurrentSinglePlayer(): before changing to the next 20, rank is '+rank+' and current single is '+currentSinglePlayer);
			currentSinglePlayer = 0;
			trace('LeaderboardModel: setCurrentSinglePlayer(): all we did was change currentSingle. Rank is '+rank+' and current single is '+currentSinglePlayer);
			setRank(getRank() +20);
			trace('LeaderboardModel: setCurrentSinglePlayer(): this should be immediately after XML is got. Rank is '+rank+' and current single is '+currentSinglePlayer);
		} else if ((index < 0) && (rank > 20)) {
			// Load in previous players but only if we're not on the 1st page
			//currentSinglePlayer = getPlayerListLength() - 1;
			currentSinglePlayer = 19;
			setRank(getRank() -20);
		} 
	}
	
	
	/*******************\
	* Private functions	*
	\*******************/
	private function updatePlayerData(newXML:XML):Void{
		// Decides what to do with the newly loaded XML
		trace('LeaderboardModel: updatePlayerData()');
		// Send the XML to the PlayerList for parsing into PlayerData entries
		playerList.updateList(newXML);
		trace('LeaderboardModel: updatePlayerData(): This should display after PlayerList is complete');
		// Update any listeners
		var infoObj:Object = new MessageBundle('updatePlayerData',MessageCodes.NEW_PLAYERS);
		setChanged();
		notifyObservers(infoObj);
	}
	
	
	private function updateDownloadProgress(downloadProgress:Number):Void{
		trace('LeaderboardModel: updateDownloadProgress(): progress ='+downloadProgress);
		// Update listeners...
		var infoObj:Object = new MessageBundle('updateDownloadProgress',MessageCodes.DOWNLOAD_PROGRESS,String(downloadProgress));
		setChanged();
		notifyObservers(infoObj);
	}
	
	private function errorDetected(errorType:String, errorCode:String):Void{
		// If errorCode is not passed, it will be assigned undefined (Can't have default values in AS2)
		trace('LeaderboardModel: errorDetected(): '+errorType+' received with code '+errorCode);
		// Update any listners
		for (var i=0; i < this.observers.length; i++){
			trace('LeaderboardModel: errorDetected(): listener '+i+' name = '+observers[i].viewName);
		}
		var infoObj:Object = new MessageBundle('errorDetected',errorType,errorCode); // Have a more structured way of passing messages
		setChanged();
		notifyObservers(infoObj);
	}
	
	private function animationComplete(animationInfo:Object):Void{
		trace('LeaderboardModel: animationComplete');
		// Send the identity of the completed animation to the views
		
		// Temporarily turn off queuing but don't empty the queue
		var queuingState:Boolean = queuing;
		trace('LeaderboardModel: animationComplete(): before temporarily setting queuing to false, it is saved as '+queuingState);
		setQueuing(false);
		
		var infoObj:Object = new MessageBundle('animationComplete',MessageCodes.ANIMATION_COMPLETE,animationInfo.sprite);
		setChanged();
		notifyObservers(infoObj);
		
		//setQueuing(queuingState); // Turning this on always leaves the queuing turned on because the ANIMATION_COMPLETE eventually instructs queue to empty and turn off it was 
		//supposed to.
		//However, when all that is done it will return here and we revert back to the queued state. So the queue will be emptied but subsequent messaged go back on to the queue.
		
		//But without this switch, if the ANIMATION_COMPLETE is not from the animation that controls the queue then there will be no way of knowing that it was the wrong message 
		//and the queue will be turned off prematurely.
		
		//This could be got round by checking the identity of the message at this point...which is not very good separation of code. It's also inflexible - we don't know right now
		//what the animation controlling the queue is going to be in future.
		
		//This might be the solution. If when the function gets back to this point there are still messages in the queue, then the ANIMATION_COMPLETE can't have signalled the end of
		// the controlling animation - that would have resulted in the queue being emptied. There are only 2 ways to get to this part of the code:
			// 1 - A signal was sent. It was the signal that the animation has finished and we can proceed. Empty the queue and turn queuing off. 
			//     In that case, if queue is empty, can turn/leave queuing off
			// 2 - A signal was sent but it was not the controlling animation. Signal never got past the view so no call was made to empty the queue. 
		// But if the animation event was sent before anything got to the queue, we could accidentally turn off queuing before the messages to be queued even get there. In that case, 
		//  when we turn on queuing we should send a dummy message into the queue which will be iterated over when the queue is emptied but will be ignored by views.
		if (messageQueue.length > 0){
			setQueuing(true);
		} else {
			setQueuing(false);
		}
	}
	
} // Close LeaderboardModel class