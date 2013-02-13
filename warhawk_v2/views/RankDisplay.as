import util.Observable;
import mvc.Controller;
import warhawk_v2.MessageBundle;
import warhawk_v2.MessageCodes;
import warhawk_v2.LeaderboardModel;
import warhawk_v2.views.AbstractWarhawkView;

/***************************************************************************\
*																			*
*  The Rank Display view for Warhawk Widget Version 2						*
*																			*
*  Peter Hastie - 23rd February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Shows the current rank of the players on screen						*
*  - Shows the field that the data is sorted by								*
*  - Allows user to specify which rank to show								*
*  - Only visible in multi mode
*																			*
\***************************************************************************/


class warhawk_v2.views.RankDisplay extends AbstractWarhawkView{
	
	private var containerClip:MovieClip;						// The clip that holds all of the text box buttons
	private var containerDepth:Number;							// The current depth of the container on the stage
	
	private var barClip:MovieClip;								// The actual clip containing the bar sprites
	
	/***************\
	* Constructor	*
	\***************/
	public function RankDisplay(m:Observable, c:Controller, target:MovieClip, depth:Number){
		
		// Set up model and abstract using inherited methods
		super(m,c);
		trace('RankDisplay: Constructor');
		
		// Name this view
		viewName = 'RankDisplay View';
		
		drawAssets(target,depth);
	}
	
	
	
	/*******************\
	* Public functions	*
	\*******************/
	public function update(o:Observable, infoObj:Object):Void{
		trace('RankDisplay: update():');
		// If this message is for us...
		var bundle:MessageBundle = MessageBundle(infoObj);
		if (bundle.messageType == MessageCodes.NEW_PLAYERS){
			// Update the player rank
			var lowerRank:Number = LeaderboardModel(getModel()).getRank();
			barClip.rank_txt.text = String(lowerRank) + ' - ' + String((lowerRank + LeaderboardModel(getModel()).getPlayerListLength() -1));
			// Update the sort field? Maybe this would be a separate opperation
			var sortField:String = LeaderboardModel(getModel()).getSortField();
			barClip.sort_txt.text = 'by '+sortField;
		} else if (bundle.messageType == MessageCodes.STATE_CHANGE){
			if (bundle.messageInfo == 'multi'){
				showAssets();
			} else if (bundle.messageInfo == 'single'){
				hideAssets();
			}
		}
	}
	
	
	
	/*******************\
	* Private functions	*
	\*******************/
	private function drawAssets(target:MovieClip, depth:Number){
		trace('RankDisplay: drawAssets()');
		containerClip = target;
		containerDepth = depth;
		
		// Add the sprite to the stage
		barClip = containerClip.attachMovie("RankBar","rank_bar_mc",containerDepth);
		barClip._y = 393;
		barClip._x = 15;
	}
	
	private function showAssets():Void{
		trace('RankDisplay: showAssets()');
		barClip._visible = true;
	}
	
	private function hideAssets():Void{
		trace('RankDisplay: hideAssets()');
		barClip._visible = false;
	}
}