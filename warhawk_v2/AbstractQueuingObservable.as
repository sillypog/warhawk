import util.*;

/***************************************************************************\
* 																			*
* An extension to the Observable type that enables message queuing.			*
*																			*
* notifyObservers is overriden to check the queuing flag. If it's set,		*
*  messages are sent to the queue instead of to listeners					*
*																			*
\***************************************************************************/

class warhawk_v2.AbstractQueuingObservable extends AbstractObservable{
	
	private var queuing:Boolean;
	
	private var messageQueue:Array;
	
	
	/***************\
	* Constructor	*
	\***************/
	public function AbstractQueuingObservable(){
		
		// Pass everything to the superclass
		//super();
		
		trace('AbstractQueuingObservable: Constructor');
		messageQueue = new Array();
		queuing = false;
	}
	
	
	/******************\
	* Public functions *
	\******************/
	public function clearMessageQueue():Void{
		trace('AbstractQueuingObservable: clearMessageQueue(): messageQueue length is '+messageQueue.length);
		// No longer queuing
		setQueuing(false);
		
		/*
		while (messageQueue.length > 0){
			// Send the update out to everything
			trace('AbstractQueuingObservable: clearMessageQueue(): releasing message of type '+messageQueue[messageQueue.length-1].messageType);
			setChanged();
			notifyObservers(messageQueue.pop);
			trace('AbstractQueuingObservable: clearMessageQueue(): after popping, messageQueue length is '+messageQueue.length);
		}
		*/
		
		for (var i:Number = 0; i < messageQueue.length; i++){
			trace('AbstractQueuingObservable: clearMessageQueue(): releasing message of type '+messageQueue[messageQueue.length-1].messageType);
			setChanged();
			notifyObservers(messageQueue[i]);
		}
		
		// Now clear the array
		messageQueue.splice(0);
		trace('AbstractQueuingObservable: clearMessageQueue(): messageQueue length is '+messageQueue.length);
	}
	
	// Override old notifyObservers
	public function notifyObservers(infoObj:Object):Void{
		if (hasChanged()){
			trace('AbstractQueuingObservable: notifyObservers(): hasChanged true');
			if (!queuing){
				// Not queuing, update listeners
				trace('AbstractQueuingObservable: notifyObservers(): not queuing, send to listners');
				for (var i:Number=0; i<observers.length; i++){
					observers[i].update(this,infoObj);
				}
			} else {
				// Store on queue
				trace('AbstractQueuingObservable: notifyObservers(): message queued');
				messageQueue.push(infoObj);
			}
			clearChanged();
		} else {
			trace('AbstractObservable: notifyObservers(): hasChanged = false...did you remember to setChanged()?');
		}
	}
	
	
	/*******************\
	* Private methods	*
	\*******************/
	private function setQueuing(newState:Boolean){
		trace('AbstractQueuingObservable: setQueuing: changing from '+queuing+' to '+newState);
		queuing  = newState;
		if (newState == true){
			// Add a dummy entry to the queue so that checks for an empty queue that would turn off queuing will fail
			var dummyMessage:Object = new Object();
			messageQueue.push(dummyMessage);
		}
	}
}