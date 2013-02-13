import util.*;
import mvc.*;

class mvc.AbstractView implements Observer, View{
	private var model:Observable;
	private var controller:Controller;
	
	public function AbstractView(m:Observable, c:Controller){
		setModel(m);
		//Use controller if supplied. If not, create default when needed
		if (c !==undefined){
			setController(c);
		}
		//If it were up to me, I'd register with the model now
		//getModel().addSubscriber(this);
	}
	
	public function defaultController(model:Observable):Controller{
		//Should override this in concrete class
		//Have to return null here because it is not a Void function
		return null;
	}
	
	public function setModel(m:Observable):Void{
		model=m;
	}
	
	public function getModel():Observable{
		return model;
	}
	
	public function setController(c:Controller):Void{
		controller=c;
		//Tell the controller who its view is
		getController().setView(this);
	}
	
	public function getController():Controller{
		//If there's no controller, we need to make default one
		if (controller === undefined){
			setController(defaultController(getModel()));
		}
		return controller;
	}
	
	//update() in Observer interface. Fill in with concrete
	public function update(o:Observable, infoObj:Object):Void{}
}
		
		
