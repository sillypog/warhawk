import mvc.AbstractController;
import util.Observable;
import warhawk_v2.views.Logo;

/***************************************************************************\
*																			*
*  Controller for Logo cycler in Warhawk Widget Version 2					*
*																			*
*  Peter Hastie - 20th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Listens for the click event over the movie								*
*  - Opens a new browser window linking to the warhawk site					*
\***************************************************************************/

class warhawk_v2.controllers.LogoController extends AbstractController{
	
	public var name:String;
	
	/***************\
	* Constructor	*
	\***************/
	public function LogoController(model:Observable){
		super(model);
		trace('LogoController: Constructor');
		name = 'LogoController';
	}
	
	
	/***********************************************\
	* Public methods								*
	*												*
	* Note that anything calling specific methods 	*
	*  in the model will have to cast it correctly.	*
	*												*
	\***********************************************/
	public function click(e:Object){
		trace('LogoController: click(): event from '+e.target._name);
		// Have received signal to link out. Do so.
		// This doesn't involve the model, no data is changing. 
		getURL("http://qa.stats.us.playstation.com/Warhawk/","_blank");
		
	}
	
}