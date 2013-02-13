﻿import mvc.Controller;import util.Observable;import warhawk_v2.MessageCodes;import warhawk_v2.MessageBundle;import warhawk_v2.LeaderboardModel;import warhawk_v2.PlayerData;import display.DispatchMovie2;import display.DispatchMovie3;import mx.utils.Delegate;import warhawk_v2.controllers.ValuesTextController;import warhawk_v2.views.AbstractWarhawkView;/***************************************************************************\*																			**  The ValuesText view for Warhawk Widget Version 2							**																			**  Peter Hastie - 23rd February 2009										**																			**  AS2.0																	**																			**  - Displays player names and stats as text								**  - Sends click events to controller when these buttons are clicked		**																			*\***************************************************************************/class warhawk_v2.views.ValuesText extends AbstractWarhawkView{		private var containerClip:MovieClip;						// The clip that holds all of the text box buttons	private var containerDepth:Number;							// The current depth of the container on the stage	private var internalDepth:Number;							// The depth of clips within the container		private var clipsList:Array;								// The clips contained in the list			/***************\	* Constructor	*	\***************/	public function ValuesText(m:Observable, c:Controller, target:MovieClip, depth:Number){				// Set up model and abstract using inherited methods		super(m,c);		trace('ValuesText: Constructor');				// Name this view		viewName = 'ValuesText View';		clipsList = new Array();					drawAssets(target,depth);	}				/*******************\	* Public functions	*	\*******************/	public function update(o:Observable, infoObj:Object):Void{		trace('ValuesText: update():');		// If it's a new player data event, fill in the values		var bundle:MessageBundle = MessageBundle(infoObj);		if (bundle.messageType == MessageCodes.NEW_PLAYERS){			trace('ValuesText: update(): got a NEW_PLAYERS event');			clearValues();			if (LeaderboardModel(getModel()).getState() == 'multi'){				enterPlayers();			} else if (LeaderboardModel(getModel()).getState() == 'single'){				enterSingle();			}		} else if (bundle.messageType == MessageCodes.TEXT_FIELD_CHANGE){			// Change the data in the value boxes to the new field			trace('ValuesText: update(): got a TEXT_FIELD_CHANGE event');			updateTextValues(bundle.messageInfo);		} else if (bundle.messageType == MessageCodes.STATE_CHANGE){			trace('ValuesText: update(): got a STATE_CHANGE event');			clearValues();			if (bundle.messageInfo == 'multi'){				enterPlayers();			}		} else if (bundle.messageType == MessageCodes.PLAYER_CHANGE){			clearValues();			enterSingle();		}	}			// Define our own default controller for this, don't want null	public function defaultController (model:Observable):Controller{		trace('ValuesText: defaultController(): returning a ValuesTextController');		return new ValuesTextController(model);	}				/*******************\	* Private functions	*	\*******************/	private function drawAssets(target:MovieClip, depth:Number):Void{		trace('ValuesText: drawAssets()');		containerDepth = depth;		containerClip = target.createEmptyMovieClip("text_values.mc",containerDepth);		containerClip._x = 10;		containerClip._y = 95;		internalDepth = 1;	}		private function enterPlayers():Void{		trace('ValuesText: enterValues()');		// Find out the length of the player list		var listLength:Number = LeaderboardModel(getModel()).getPlayerListLength();		for (var i:Number=0; i < listLength; i++){			trace('ValuesText: enterValues(): entering value '+i);						/*// Go through the player list and add the values			//clipsList.push(DispatchButton(containerClip.attachMovie("PlayerText","player_text"+i+"_mc",internalDepth++)));			//clipsList[i]._y = i*10; // This doesn't work for some reason			var playerData:PlayerData = PlayerData(LeaderboardModel(getModel()).getPlayerData(i));			trace('ValuesText: enterValues(): player name = '+playerData.playerName);			var currentBox:DispatchMovie2 = DispatchMovie2(containerClip.attachMovie("PlayerText","player_text"+i+"_mc",internalDepth++));			containerClip["player_text"+i+"_mc"]._y = i*15; // Sets the spacing between text boxes			containerClip["player_text"+i+"_mc"].player_txt.text = playerData.playerName;			trace('ValuesText: enterValues(): currentBox name is '+currentBox._name);			*/						// Get the data to add			var playerData:PlayerData = PlayerData(LeaderboardModel(getModel()).getPlayerData(i));						// Make a new box and add to the list of clips			clipsList[i] = DispatchMovie3(containerClip.attachMovie("PlayerText",String(i),internalDepth++));			clipsList[i]._y = i*(286/listLength); // Sets spacing between boxes						// Add the information to the clip			clipsList[i].player_txt.text = playerData.playerName;			clipsList[i].value_txt.text = playerData[LeaderboardModel(getModel()).getTextDisplayField()]; // Ask the model what the current text display field is						// Connect click events to the controller			clipsList[i].addListener("click", getController()); // Rollover/out events are also processed		}	}		private function enterSingle():Void{		trace('ValuesText: enterSingle()');		// Get the current player index		var currentIndex = LeaderboardModel(getModel()).getCurrentSinglePlayer();		// Get the data to add		var playerData:PlayerData = PlayerData(LeaderboardModel(getModel()).getPlayerData(currentIndex));		// Get the fields and their values		var fields:Array = new Array();		var values:Array = new Array();		for (var prop in playerData){			fields.push(prop);			values.push(playerData[prop]);		}		// They come in in reverse order this way so reverse the arrays		fields.reverse();		values.reverse();				// Ignore name and rank fields but add the rest to the screen		for (var i:Number = 2; i < fields.length; i++){			clipsList[i] = MovieClip(containerClip.attachMovie("PlayerText",String(i), internalDepth++));			clipsList[i]._y = (i-2)*(286/(fields.length -2)); // Sets spacing between bars						// Add the info			clipsList[i].player_txt.text = fields[i];			clipsList[i].value_txt.text = values[i];		}	}		private function clearValues():Void{		trace('ValuesText: clearValues');		// Remove any clips that are already contained		for (var i:Number =0; i < clipsList.length; i++){			clipsList[i].removeMovieClip();		}		clipsList.splice(0, clipsList.length); // This will also wipe the array		// Also reset the internal depth		internalDepth = 1;	}		private function updateTextValues(field:String):Void{		trace('ValuesText: updateTextValues()');		var listLength:Number = LeaderboardModel(getModel()).getPlayerListLength();		for (var i:Number=0; i < listLength; i++){			// Get the data to add			var playerData:PlayerData = PlayerData(LeaderboardModel(getModel()).getPlayerData(i));			clipsList[i].value_txt.text = playerData[field]; // Ask the model what the current text display field is		} 	}}