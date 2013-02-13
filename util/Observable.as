import util.*;

interface util.Observable{
	//We'll want it to be able to take subscriptions
	function addSubscriber(o:Observer):Void;
	//And remove them when done
	function removeSubscriber(o:Observer):Void;
	//And tell the subscribers about events
	function notifyObservers(infoObj:Object):Void;
}