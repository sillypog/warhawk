import mvc.AbstractController;
import util.Observable;
import warhawk_v2.AbstractQueuingObservable;

/***************************************************************************\
*																			*
*  The controller for the TVGlow of Warhawk Widget Version 2				*
*																			*
*  Peter Hastie - 23rd February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Releases messageQueue when animations complete							*
\***************************************************************************/

class warhawk_v2.controllers.TVGlowController extends AbstractController {
	
	/***************\
	* Constructor	*
	\***************/
	public function TVGlowController(model:Observable){
		super(model);
		trace('TVGlowController: Constructor');
	}
	
	
	/*******************\
	* Public methods	*
	\*******************/
	public function click(e:Object):Void{
		// Probably nothing passed in as this is called internally. Pass null
		// Release messageQueue
		AbstractQueuingObservable(getModel()).clearMessageQueue();
	}
}