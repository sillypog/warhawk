import util.*;

class ConcreteObserver implements Observer{
	
	public var name:String;
	
	public function ConcreteObserver(n:String){
		trace("::ConcreteObserver Instantiated - movieclasses::")
		name = n;
	}
	
	public function update(o:Observable, infoObj:Object):Void{
		trace('Concrete Observer: update(): update running');
		// This handy loop will change the state of the variables here and ignore any that don't match
		for (var prop in infoObj){
			trace('  > Prop: '+prop+': '+infoObj[prop]);
		}
	}
}