import mvc.AbstractController;
import util.Observable;
import warhawk_v2.LeaderboardModel;

/***************************************************************************\
*																			*
*  The Controllers for the Header Bar for Warhawk Widget Version 2			*
*																			*
*  Peter Hastie - 18th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Handles clicks on the target											*																			
*  - Requests mode change to next mode										*
\***************************************************************************/


class warhawk_v2.controllers.HeaderBarController extends AbstractController{
	
	
	/***************\
	* Constructor	*
	\***************/
	public function HeaderBarController(model:Observable){
		super(model);
		trace('HeaderBarController: Constructor');
	}
	
	
	/*******************\
	* Public functions	*
	\*******************/
	public function click():Void{
		trace('HeaderBarController: click()');
		LeaderboardModel(getModel()).setMode(); // Pass no parameter, will cycle to next
	}
}
		