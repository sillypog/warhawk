import mvc.Controller;
import util.Observable;
import warhawk_v2.MessageBundle;
import warhawk_v2.MessageCodes;
import warhawk_v2.views.AbstractWarhawkView;
import warhawk_v2.AnimationCentre;
import warhawk_v2.controllers.TVGlowController;

/***************************************************************************\
*																			*
*  The TVGlow effect for Warhawk Widget Version 2							*
*																			*
*  Peter Hastie - 18th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Unmasks predrawn regions upon initialisation							*
*  - Also draws a wipe effect when mode changes								*
*																			*
\***************************************************************************/

class warhawk_v2.views.TVGlowEffect extends AbstractWarhawkView{
	
	private var glowClip:MovieClip;			// A reference to the glow/mask sprite
	private var animateInterval:Number;		// The interval that is called to animate the sprite
	private var initialised:Boolean;		// A flag which will be set after the first wipe has run
	
	/***************\
	* Constructor	*
	\***************/
	public function TVGlowEffect(m:Observable, c:Controller, target:MovieClip, depth:Number, ac:AnimationCentre){
		// Set up model and abstract using inherited methods
		super(m,c,ac);
		
		trace('TVGlowEffect: Constructor');
		
		viewName = 'TVGlow view';
		
		initialised = false;
		
		// Add the effect to the stage
		glowClip = target.attachMovie("TVGlow","tv_glow_mc",depth);
		glowClip._y = 74.5;
		glowClip.gotoAndStop(1);
		
		// Start animating it to reveal content underneath
		//animateInterval = setInterval(this,"shrink",10);
		animationCentre.addSubscriber(glowClip,"_currentFrame",glowClip._totalFrames);
	}
	
	
	/*******************\
	* Public functions	*
	\*******************/
	public function update(o:Observable, infoObj:Object):Void{
		trace('TVGlowEffect: update()');
		var bundle:MessageBundle = MessageBundle(infoObj);
		//if (initialised && ((bundle.messageType == MessageCodes.MODE_CHANGE) || (bundle.messageType == MessageCodes.STATE_CHANGE))){
		if (initialised && (bundle.messageType == MessageCodes.WIPE_SCREEN)){
			//animateInterval = setInterval(this,"grow",10);
			animationCentre.addSubscriber(glowClip,"_currentFrame",1);
		} else if ((bundle.messageType == MessageCodes.ANIMATION_COMPLETE) && (Object(bundle.messageInfo) == glowClip)){
			trace('TVGlowEffect: update(): glowClip has finished animating');
			// Set initialised here
			initialised = true;
			/*
			// If the glowClip is covering the screen, make it shrink
			if (glowClip._currentFrame < glowClip._totalFrames){
				animationCentre.addSubscriber(glowClip,"_currentFrame",glowClip._totalFrames);
			}
			*/
			// Tell the controller that the animation is complete and it can release anything in the model's messageQueue
			TVGlowController(getController()).click();
		} else if (bundle.messageType == MessageCodes.STATE_CHANGE){
			// Reveal the redrawn contents
			animationCentre.addSubscriber(glowClip,"_currentFrame",glowClip._totalFrames);
		}
	}
	
	
	// Define our own default controller for this, don't want null
	public function defaultController (model:Observable):Controller{
		trace('TVGlowEffect: defaultController(): returning a TVGlowController');
		return new TVGlowController(model);
	}
	
	
	/*******************\
	* Private functions	*
	\*******************/
	/*
	private function shrink(){
		trace('TVGlowEffect: shrink(): currentFrame ='+glowClip._currentframe+', totalFrames = '+glowClip._totalframes);
		if (glowClip._currentframe < glowClip._totalframes){
			trace('TVGlowEffect: shrink(): shrinking glow clip');
			glowClip.nextFrame();
		} else {
			trace('TVGlowEffect: shrink(): removing animation inteval');
			initialised = true;
			clearInterval(animateInterval);
		}
	}
	
	private function grow(){
		trace('TVGlowEffect: grow()');
		if (glowClip._currentframe > 1){
			trace('TVGlowEffect: grow(): _currentframe = '+glowClip._currentframe+' so growing');
			glowClip.prevFrame();
		} else {
			trace('TVGlowEffect: grow(): _currentframe = '+glowClip._currentframe+' so clearing interval and calling shrink');
			clearInterval(animateInterval);
			animateInterval = setInterval(this,"shrink",10);
		}
	}
	*/
}
		
		