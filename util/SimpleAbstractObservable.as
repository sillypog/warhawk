import util.*;

class util.SimpleAbstractObservable implements Observable{
	
	//Store the list of observers
	var observers:Array;
	
	
	public function SimpleAbstractObservable(){
		trace('SimpleAbstractObservable: Constructed');
		observers=new Array();
	}
	
	public function addSubscriber(o:Observer):Void{
		trace("SimpleAbstractObservable: addSubscriber: Adding Subscriber");
		//Don't add duplicates
		for (var i:Number=0; i<observers.length; i++){
			if (observers[i]==o){
				//trace("Won't add duplicate");
				return;
			}
		}
		observers.push(o);
	}
								 
	
	public function removeSubscriber(o:Observer):Void{
		//Remove this entry from the array
		for (var i:Number=0; i<observers.length; i++){
			if (observers[i]==o){
				observers.splice(i,1);
				break;
			}
		}
	}
	
	public function notifyObservers(infoObj:Object):Void{
		trace('AbstractObservable: notifyObservers(): Running notifyObservers. infoObj contains:');
		for (var prop in infoObj){
			trace(' > '+prop+': '+infoObj[prop]);
		}
		for (var i:Number=0; i<observers.length; i++){
			observers[i].update(this,infoObj);
		}
	}
	
}
	
	