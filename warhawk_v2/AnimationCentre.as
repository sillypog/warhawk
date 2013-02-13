import util.Observable;
import warhawk_v2.MessageCodes;
import warhawk_v2.LeaderboardModel;

/***************************************************************************\
*																			*
*  AnimationCentre for Warhawk Widget Version 2								*
*																			*
*  Peter Hastie - 23rd February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Controls animation for all subscribed sprites							*
*  - Sprites subscribe with a property to change and an endpoint			*
*  - On a set interval, the class increments all the properties				*
*  - When animation reaches end point, subscriber is removed				*
*  - If no subscribers, interval is not set									*
*  - For a sprite to have two properties change, subscribe twice			*
*																			*
\***************************************************************************/

class warhawk_v2.AnimationCentre {
	
	private var interval:Number;			// stores the id of the interval for executing animate
	private var executeTime:Number;			// number of milliseconds to wait between intervals
	private var subscribers:Array;			// stores references to subscribers, properties and endpoints
	
	private var model:Observable;			// A reference to the model
	
	/***************\
	* Constructor	*
	\***************/
	public function AnimationCentre(m:Observable){
		trace('AnimationCentre: Constructor');
		
		subscribers = new Array();
		executeTime = 10;					// execute every 10 msec
		
		model = m;
	}
	
	
	/*******************\
	* Public methods	*
	\*******************/
	public function addSubscriber(s:MovieClip, p:String, v:Number):Void{
		trace("AnimationCentre: addSubscriber()");
		// bundle up the parameters into an object
		var bundle:Object = new Object({sprite:s,prop:p,endValue:v});
		// Also store the initial value of the property
		bundle.init = s[p];
		//Don't add duplicates
		for (var i:Number=0; i<subscribers.length; i++){
			if (subscribers[i]==bundle){
				trace("AnimationCentre: addSubscriber(): Won't add duplicate");
				return;
			}
		}
		//If this is the first thing added, set the interval
		if (subscribers.length < 1){
			trace("AnimationCentre: addSubscriber(): creating new intervalID");
			interval = setInterval(this,"animate",executeTime);
		}
		//Add the subscriber to the list
		subscribers.push(bundle);
	}
								 
	
	/*******************\
	* Private methods	*
	\*******************/
	private function animationComplete(index:Number):Void{
		//Tell the model that this animation completed
		LeaderboardModel(model).processMessage(MessageCodes.ANIMATION_COMPLETE,subscribers[index]);
		//Remove this entry from the array
		trace('AnimationCentre: animationComplete(): removing one');
		subscribers.splice(index,1);
		// If that was the last one, remove the interval
		if (subscribers.length < 1){
			trace('AnimationCentre: animationComplete(): no subscribers left, clearing interval');
			clearInterval(interval);
		}
	}
	
	
	private function animate():Void{
		trace('AnimationCentre: animate()');
		for (var i:Number =0; i < subscribers.length; i++){
			// Unbundle the entry
			var sprite = subscribers[i].sprite;
			var prop = subscribers[i].prop;
			// step each thing closer to end point
			// ... sometimes this will mean increasing value, sometimes decreasing
			// Check the initial value and decide if it should go up or down
			if (subscribers[i].init < subscribers[i].endValue){
				trace('AnimationCentre: animate(): for ' + sprite._name + ' init is ' + subscribers[i].init + ' and endValue is ' + subscribers[i].endValue + ' so increasing');
				// Do something different for frames
				if (prop == '_currentFrame'){
					increaseFrame(sprite,prop,i);
				} else {
					// We should increase the value
					increaseValue(sprite, prop, i);
				}
			} else if (subscribers[i].init > subscribers[i].endValue) {
				// Do something different for frames
				if (prop == '_currentFrame'){
					decreaseFrame(sprite,prop,i);
				} else {
					// We should decrease the value
					decreaseValue(sprite, prop, i);
				}
			} else {
				// No animation to do so remove
				animationComplete(i);
			}
		}
		// Update the stage
		updateAfterEvent();
	}
	
	private function increaseValue(sprite:MovieClip, prop:String, index:Number):Void{
		trace('AnimationCentre: increaseValue()');
		// Do something different for frames
		//if (prop == '_currentFrame'){
		//	increaseFrame(sprite,prop,index);
		//	return;
		//} else {
			if (sprite[prop] < subscribers[index].endValue){
				sprite[prop] += 5;
			} else {
				// Set explicity incase we overshot
				sprite[prop] = subscribers[index].endValue;
				// Remove from list
				animationComplete(index);
			}
		//}
	}
	
	private function decreaseValue(sprite:MovieClip, prop:String, index:Number):Void{
		trace('AnimationCentre: decreaseValue()');
		// Do something different for frames
		//if (prop == '_currentFrame'){
		//	decreaseFrame(sprite,prop,index);
		//	return;
		//} else {
			if (sprite[prop] > subscribers[index].endValue){
				sprite[prop] -= 5;
			} else {
				// Set explicity incase we overshot
				sprite[prop] = subscribers[index].endValue;
				// Remove from list
				animationComplete(index);
			}
		//}
	}
	
	private function increaseFrame(sprite:MovieClip, prop:String, index:Number):Void{
		trace('AnimationCentre: increaseFrame(): setting '+sprite._name+ ' to frame '+(sprite._currentFrame+1));
		if (sprite._currentFrame < subscribers[index].endValue){
			sprite.nextFrame();
		} else {
			// Set explicitly incase we overshot
			sprite.gotoAndStop(subscribers[index].endValue);
			// Remove from list
			animationComplete(index);
		}
	}
	
	private function decreaseFrame(sprite:MovieClip, prop:String, index:Number):Void{
		trace('AnimationCentre: decreaseFrame(): setting '+sprite._name+ ' to frame '+(sprite._currentFrame-1));
		if (sprite._currentFrame > subscribers[index].endValue){
			sprite.prevFrame();
		} else {
			// Set explicitly incase we overshot
			sprite.gotoAndStop(subscribers[index].endValue);
			// Remove from list
			animationComplete(index);
		}
	}
			
}