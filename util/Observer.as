import util.*;

interface util.Observer{
	// Recieve information from the Observable/Subject we're subscribed to
	function update(o:Observable, infoObj:Object):Void;
}