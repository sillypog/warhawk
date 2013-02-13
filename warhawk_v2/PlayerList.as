import warhawk_v2.PlayerData;

/***************************************************************************\
*																			*
*  Provides root of composite pattern for holding player data for Warhawk 	*
*   Widget Version 2														*
*																			*
*  Peter Hastie - 18th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*																			*
\***************************************************************************/

class warhawk_v2.PlayerList{
	
	private var playerList:Array;
	
	/***************\
	* Constructor	*
	\***************/	
	public function PlayerList(){
		trace('PlayerList: Constructor: new PlayerList instantiated');
		playerList = new Array();
	} // Close Constructor
	
	
	/*******************\
	* Public functions	*
	\*******************/
	public function updateList(newXML:XML):Void{
		trace('PlayerList: updateList(): got new XML');
		trace('PlayerList: updateList(): playerList.length='+playerList.length);
		
		// Remove existing data in the array
		clearArray();

		// Walk through the XML document and everytime you see a new <Player> tag, generate a new PlayerData document
		var playersNode=newXML.childNodes[0].childNodes[0].childNodes[0];

		/* XML Layout
			myXML.childNodes[0] is the XML response tag
			myXML.childNodes[0].childNodes[0] is the Leaderboard tag
			myXML.childNodes[0].childNodes[0].childNodes[0] is the Players tag
			myXML.childNodes[0].childNodes[0].childNodes[0].childNodes[i] is whichever Player tag you want
			
			trace('PlayerList:updateList(): length of playersNode = '+playersNode.childNodes.length);
			trace('PlayerList:updateList(): player1 name = '+playersNode.childNodes[0].attributes["handle"]);
			trace('PlayerList:updateList(): number of stats = '+playersNode.childNodes[0].childNodes.length);
			trace('PlayerList:updateList(): first stat name = '+playersNode.childNodes[0].childNodes[0].nodeName.toUpperCase());
			trace('PlayerList:updateList(): first stat value = '+playersNode.childNodes[0].childNodes[0].childNodes[0].nodeValue);
		*/		
		
		for (var player:Number=0; player < playersNode.childNodes.length; player++){			
			// Build the object to pass to the new PlayerData object
			var playerBundle:Object = new Object();
			playerBundle._Name = playersNode.childNodes[player].attributes["handle"];
			playerBundle._Rank = playersNode.childNodes[player].attributes["rank"];
			// Loop through all the values for this player and add them to the object
			for (var stats:Number=0; stats < playersNode.childNodes[player].childNodes.length; stats++){
				var field:String = playersNode.childNodes[player].childNodes[stats].nodeName.toUpperCase();
				var fieldValue:String = playersNode.childNodes[player].childNodes[stats].childNodes[0].nodeValue;
				// Add this pair to the playerBundle
				playerBundle[field] = fieldValue;
			}//end stats loop
			// Push a new PlayerData into the playersList 
			playerList.push(new PlayerData(playerBundle));
			
		}//end player loop
		trace('PlayerList:updateList(): updating complete, playerList.length='+playerList.length);
	}//end updateList()
	
	
	public function getLength():Number{
		trace('PlayerList: getLength()');
		return(playerList.length);
	}
	
	public function getPlayerData(index:Number):PlayerData{
		trace('PlayerList: getPlayerData');
		// Bundle the player data together
		return (playerList[index]);
	}
	
	/*******************\
	* Private functions	*
	\*******************/
	private function clearArray(){
		trace('PlayerList: clearArray()');
		playerList.splice(0,playerList.length);
	}
} // Close class