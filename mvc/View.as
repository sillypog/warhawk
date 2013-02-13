import mvc.*; //Where Controller is
import util.*; //Where Observable is

interface mvc.View{
	//Set the model this view is observing
	public function setModel(m:Observable):Void;
	
	//Return the model this view is observing
	public function getModel():Observable;
	
	//Set the controller for this view
	public function setController(c:Controller):Void;
	
	//Return this view's controller
	public function getController():Controller;
	
	//Return default controller for this view
	public function defaultController (model:Observable):Controller;
}