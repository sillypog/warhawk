import mvc.AbstractController;
import util.Observable;
import warhawk_v2.LeaderboardModel;

/***************************************************************************\
*																			*
*  Controller for Field Selector bar in Warhawk Widget Version 2			*
*																			*
*  Peter Hastie - 26th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Listens for the click events in the control bar						*
*  - Changes selected fields being viewed as text or bars					*
\***************************************************************************/

class warhawk_v2.controllers.FieldSelectController extends AbstractController{
	
	public var name:String;
	
	/***************\
	* Controller	*
	\***************/
	public function FieldSelectController(model:Observable){
		super(model);
		trace('FieldSelectController: Constructor');
		name = 'FieldSelectController';
	}
	
	
	/***********************************************\
	* Public methods								*
	*												*
	* Note that anything calling specific methods 	*
	*  in the model will have to cast it correctly.	*
	*												*
	\***********************************************/
	public function click(e:Object){
		trace('FieldController: click(): event from '+e.target._name);
		// Clicks can come from left cycle, right cycle or bar/text buttons for specific fields
		if (LeaderboardModel(getModel()).getState() == 'multi'){
			switch(e.target._name){
				case 'left_btn'	: previousField(); 			break;
				case 'right_btn': nextField(); 				break;
				case 'field_btn': openMenu();				break;
				default			: trace('FieldSelectController: click(): ERROR! CLICK INPUT FROM UNKNOWN OBJECT'); break;
			}
		} else {
			switch(e.target._name){
				case 'left_btn'	: trace('FieldSelectController: click(): ERROR! Click from left_btn in single state');	break;
				case 'right_btn': trace('FieldSelectController: click(): ERROR! Click from left_btn in single state'); 				break;
				case 'field_btn': triggerStateChange();				break;
				default			: trace('FieldSelectController: click(): ERROR! CLICK INPUT FROM UNKNOWN OBJECT'); break;
			}
		}
	}
	
	
	/*******************\
	* Private methods	*
	\*******************/
	private function previousField(){
		trace('FieldSelectController: previousField()');
		LeaderboardModel(getModel()).setTextDisplayField('previous');
	}
	
	private function nextField(){
		trace('FieldSelectController: nextField()');
		LeaderboardModel(getModel()).setTextDisplayField('next');
	}
	
	private function openMenu(){
		trace('FieldSelectController: openMenu()');
	}
	
	private function triggerStateChange(){
		trace('FieldSelectController: triggerStateChange()');
		LeaderboardModel(getModel()).toggleState();
	}
	
}