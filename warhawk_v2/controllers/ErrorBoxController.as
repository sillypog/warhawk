import mvc.AbstractController;
import util.Observable;
import warhawk_v2.views.ErrorBox;

/***************************************************************************\
*																			*
*  Controller for Error boxes in Warhawk Widget Version 2					*
*																			*
*  Peter Hastie - 20th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Listens for the click event in the close button						*
*  - Removes the Box containing the clicked button from the View container	*
\***************************************************************************/

class warhawk_v2.controllers.ErrorBoxController extends AbstractController{
	
	public var name:String;
	
	/***************\
	* Controller	*
	\***************/
	public function ErrorBoxController(model:Observable){
		super(model);
		trace('ErrorBoxController: Constructor');
		name = 'ErrorBoxController';
	}
	
	
	/***********************************************\
	* Public methods								*
	*												*
	* Note that anything calling specific methods 	*
	*  in the model will have to cast it correctly.	*
	*												*
	\***********************************************/
	public function click(e:Object){
		trace('ErrorBoxController: click(): event from '+e.target._name);
		// Have received signal to close box. Remove it from stage.
		// This doesn't involve the model, no data is changing. 
		//var initialisingObject:MovieClip = e.target;
		//trace('ErrorBoxController: click(): parent name = '+initialisingObject._parent._name);
		//trace('ErrorBoxController: click(): my view is '+ErrorBox(getView()).viewName);
		ErrorBox(getView()).removeError(e.target._parent); // Instructs the view for this controller to remove the parent of the clicked button, ie the error box
		
	}
	
}