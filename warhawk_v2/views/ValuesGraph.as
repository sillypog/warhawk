import util.Observable;
import mvc.Controller;
import warhawk_v2.PlayerData;
import warhawk_v2.LeaderboardModel;
import warhawk_v2.MessageBundle;
import warhawk_v2.MessageCodes;
import warhawk_v2.AnimationCentre;
import warhawk_v2.views.AbstractWarhawkView;

/***************************************************************************\
*																			*
*  The ValuesGraph view for Warhawk Widget Version 2						*
*																			*
*  Peter Hastie - 23rd February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Displays player stats as bar chart underlays							*
*  - Only visible in multi state											*
*																			*
\***************************************************************************/

class warhawk_v2.views.ValuesGraph extends AbstractWarhawkView{
	
	private var containerClip:MovieClip;						// The clip that holds all of the parts of this view
	private var containerDepth:Number;							// The current depth of the container on the stage
	private var internalDepth:Number;							// The depth of clips within the container
	
	private var gradientLayer:MovieClip;						// The masked blue gradient
	private var maskLayer:MovieClip;							// The layer that contains the bars. These reveal the gradient behind
	private var maskDepth:Number;								// Current depth in mask layer
	private var clipsList:Array;								// The clips contained in the mask layer
	
	private var ORIGINAL_CLIP_WIDTH:Number;					// The width of the linked bar sprite
	
	
	/***************\
	* Constructor	*
	\***************/
	public function ValuesGraph(m:Observable, c:Controller, target:MovieClip, depth:Number, ac:AnimationCentre){
		
		// Set up model and abstract using inherited methods
		super(m,c,ac);
		trace('ValuesGraph: Constructor');
		
		// Name this view
		viewName = 'ValuesGraph View';
		clipsList = new Array();
				
		drawAssets(target,depth);
	}
	
	
	/*******************\
	* Public functions	*
	\*******************/
	public function update(o:Observable, infoObj:Object):Void{
		trace('ValuesGraph: update():');
		// If it's a new player data event, fill in the values
		var bundle:MessageBundle = MessageBundle(infoObj);
		if ((bundle.messageType == MessageCodes.NEW_PLAYERS) && (LeaderboardModel(getModel()).getState() == 'multi')){
			trace('ValuesGraph: update(): got a NEW_PLAYERS event');
			clearBars();
			drawBars();
		} else if (bundle.messageType == MessageCodes.STATE_CHANGE){
			// Don't want bars in single state but do for multi
			if (bundle.messageInfo == 'single'){
				// Animate out
				clearBars();
			} else if (bundle.messageInfo == 'multi'){
				// Animate in
				drawBars();
			}
		}
		
	}
	
	
	
	/*******************\
	* Private methods	*
	\*******************/
	private function drawAssets(target:MovieClip, depth:Number){
		trace('ValuesGraph: drawAssets()');
		// Set up a container for this view
		containerDepth = depth;
		containerClip = target.createEmptyMovieClip("values_graph_mc",containerDepth);
		internalDepth = 1;
		// Match x and y to that of visible gradient
		containerClip._x = 2;
		containerClip._y = 74.5;
		
		// Copy the blue gradient on to this. Areas will be made visible by filling the mask
		gradientLayer = containerClip.attachMovie("GradientBack","masked_gradient_mc",internalDepth++);
		
		// Add mask layer on top
		maskLayer = containerClip.createEmptyMovieClip("mask_layer_mc",internalDepth++);
		gradientLayer.setMask(maskLayer);
		maskDepth = 1;
		maskLayer._x+=5;
		
		// Bars don't get added until data is loaded
		ORIGINAL_CLIP_WIDTH = 180;
	}
	
	private function drawBars():Void{
		trace('ValuesGraph: drawBars()');
		// Get all the values for this field
		var values:Array = new Array();
		var listLength:Number = LeaderboardModel(getModel()).getPlayerListLength();
		for (var i:Number=0; i < listLength; i++){
			// Get the data to add
			var playerData:PlayerData = PlayerData(LeaderboardModel(getModel()).getPlayerData(i));
			values.push(playerData[LeaderboardModel(getModel()).getGraphDisplayField()]);
		}
		trace('ValuesGraph: drawBars(): values array is now length = '+values.length+' with values: '+values.toString());
		// Now find the minimum and maximum values in the array - can do this by sorting numerically
		var sortedValues:Array = values.slice();
		sortedValues.sort(compareNumbers); // Now have the sorted values as well as the originals
		trace('ValuesGraph: drawBars(): sortedValues are '+sortedValues.toString());
		// Lowest in position 0, highest at last index
		var divisor:Number = (sortedValues[sortedValues.length-1] - sortedValues[0]) / ORIGINAL_CLIP_WIDTH; // Will let us stretch the bars across the whole screen
		trace('ValuesGraph: drawBars(): divisor is '+divisor);

		// Go back through the array and add a bar for each value
		for (var i:Number = 0; i < values.length; i++){
			clipsList.push(maskLayer.attachMovie("ChartBar","bar_"+i+"_mc",maskDepth++));
			clipsList[i]._y = 25+(i*286/listLength);
			trace('ValuesGraph: drawBars(): currentValue: '+values[i]+', lowestValues: '+sortedValues[0]);
			//clipsList[i]._xscale = (((values[i] - sortedValues[0])/divisor)/ORIGINAL_CLIP_WIDTH)*100;
			//trace('ValuesGraph: drawBars(): '+clipsList[i]._name+'._xscale is now '+clipsList[i]._xscale);
			// Animate the bar to the correct size
			var endScale:Number = (((values[i] - sortedValues[0])/divisor)/ORIGINAL_CLIP_WIDTH)*100;
			clipsList[i]._xscale = 0;
			animationCentre.addSubscriber(clipsList[i],"_xscale",endScale);
		}
		
	}
	
	private function clearBars():Void{
		trace('ValuesGraph: clearBars()');
		// Remove any clips that are already contained
		for (var i:Number =0; i < clipsList.length; i++){
			clipsList[i].removeMovieClip();
		}
		clipsList.splice(0, clipsList.length); // This will also wipe the array
		// Also reset the internal depth
		maskDepth = 1;
	}

	
	private function compareNumbers(n1:Number,n2:Number):Number{
		trace('ValuesGraph: compareNumbers()');
		if (n1 < n2){
			return (-1);
		} else if (n1 > n2){
			return (1);
		} else {
			return (0);
		}
	}
}