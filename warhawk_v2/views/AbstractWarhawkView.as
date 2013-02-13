import mvc.*;
import util.Observable;
import warhawk_v2.AnimationCentre;

/***************************************************************************\
*																			*
*  Abstract view for Warhawk Widget Version 2								*
*																			*
*  Peter Hastie - 23rd February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Adds viewName variable													*
*  - Adds communication with AnimationCentre								*
*  - Automatically sets up the controller with this as the view				*
*																			*
\***************************************************************************/

class warhawk_v2.views.AbstractWarhawkView extends AbstractView{
	
	private var viewName:String;								// The unique name for this view
	private var animationCentre:AnimationCentre;				// Reference to object that controls all animations for application
	
	/***************\
	* Constructor	*
	\***************/
	public function AbstractWarhawkView(m:Observable, c:Controller, ac:AnimationCentre){
		
		// Set up model and controller using inherited methods
		super(m,c);
		
		// Controller is generated automatically when first requested
		// Do that now so we can set the view as this
		getController().setView(this);
		
		// Also set up a reference to the application animation centre
		animationCentre = ac;
		
		// Register for updates from model
		getModel().addSubscriber(this);
	}
}