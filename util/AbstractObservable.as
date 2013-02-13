import util.*;

class util.AbstractObservable implements Observable{
	
	//Store the list of observers
	var observers:Array;
	var changed:Boolean;
	
	public function AbstractObservable(){
		observers=new Array();
		changed=false;
	}
	
	public function addSubscriber(o:Observer):Void{
		trace("AbstractObservable: addSubscriber()");
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
		if (hasChanged()){
			trace('AbstractObservable: notifyObservers(): hasChanged true');
			for (var i:Number=0; i<observers.length; i++){
				observers[i].update(this,infoObj);
			}
			clearChanged();
		} else {
			trace('AbstractObservable: notifyObservers(): hasChanged = false...did you remember to setChanged()?');
		}
	}
	
	private function setChanged():Void{
		changed=true;
	}
	
	private function clearChanged():Void{
		changed=false;
	}
	
	private function hasChanged():Boolean{
		return(changed);
	}
}
	
	