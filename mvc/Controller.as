import util.*;
import mvc.*;

interface mvc.Controller{
	public function setModel(m:Observable):Void;
	public function getModel():Observable;
	public function setView(v:View):Void;
	public function getView():View;
}