import mvc.AbstractController;
import util.Observable;
import warhawk_v2.LeaderboardModel;

/***************************************************************************\
*																			*
*  The controller for the Lower Navigation Bar of Warhawk Widget Version 2	*
*																			*
*  Peter Hastie - 23rd February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Receives click events from left, right and menu controls				*
*  - Menu click will open or close menu										*
*  - Left/Right will advance player, page or menu tab depending on state	*
\***************************************************************************/

class warhawk_v2.controllers.NavigationController extends AbstractController{
	
	/***************\
	* Constructor	*
	\***************/
	public function NavigationController(model:Observable){
		super(model);
		trace('NavigationrController: Constructor');
	}
	
	
	/*******************\
	* Public functions	*
	\*******************/
	public function click(e:Object):Void{
		trace('NavigationController: click(): received event from '+e.target._name);
		var eventSource:MovieClip = e.target;
		/*
		if (eventSource._name == "left_button_mc"){
			trace('NavigationController: click(): Sending a left event');
			rightClick();
		} else if (eventSource._name == "right_button_mc"){
			trace('NavigationController: click(): Sending a right event');
		} else if (eventSource._name == "menu_button_mc"){
			trace('NavigationController: click(): Sending a menu event');
		} else {
			trace('NavigationController: click(): ERROR! RECEIVED EVENT FROM UNKNOWN BUTTON');
		}
		*/
		switch (eventSource._name){
			case 'left_button_mc'	:	leftClick();	break;
			case 'right_button_mc'	:	rightClick();	break;
			case 'menu_button_mc'	:	menuClick();	break;
		}
	}
	
	
	/*******************\
	* Private functions	*
	\*******************/
	private function rightClick():Void{
		trace('NavigationController: rightClick()');
		// If menu is not displayed and we're in the multi state, load the next 20 players
		if (LeaderboardModel(getModel()).getState() == 'multi'){
			var currentRank = LeaderboardModel(getModel()).getRank();
			currentRank += 20;
			LeaderboardModel(getModel()).setRank(currentRank);
		} else if (LeaderboardModel(getModel()).getState() == 'single'){
			// Advance the player
			var newIndex:Number = 1 + LeaderboardModel(getModel()).getCurrentSinglePlayer();
			trace('NavigationController: rightClick(): new index is ' + newIndex);
			LeaderboardModel(getModel()).setCurrentSinglePlayer(newIndex);
		}
	}
	
	
	private function leftClick():Void{
		trace('NavigationController: leftClick()');
		// If menu is not displayed and we're in the multi state, load the next 20 players
		if (LeaderboardModel(getModel()).getState() == 'multi'){
			var currentRank = LeaderboardModel(getModel()).getRank();
			currentRank -= 20;
			// Can't go back if we're already at 0
			if (currentRank > 1){
				LeaderboardModel(getModel()).setRank(currentRank);
			} else {
				LeaderboardModel(getModel()).setRank(1);
			}
		} else if (LeaderboardModel(getModel()).getState() == 'single'){
			// Previous player
			var newIndex:Number = LeaderboardModel(getModel()).getCurrentSinglePlayer() - 1;
			LeaderboardModel(getModel()).setCurrentSinglePlayer(newIndex);
		}
	}
	
	private function menuClick():Void{
		trace('NavigationController: menuClick()');
	}
}