package engine.templates.collections;
import engine.base.RueObject;
import engine.World;

/**
 * ...
 * @author Jakegr
 */

class RueCallback extends RueObject
{
	static var Head:RueCallback;
	var Next:RueCallback;
	var Self:RueCallback;
	
	public var _Function:Void->Void;
	
	private function new() 
	{
		World.Tracking++;
		super();
		Self = this;
	}
	
	public static function Create(aCallback:Void->Void):RueCallback
	{
		var Vessel:RueCallback;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueCallback(); }
		Vessel.InPool = false;
		Vessel._Function = aCallback;
		
		return Vessel;
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			trace("Recycle call back");
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		trace("Re added");
		Next = Head;
		Head = Self;
	}
		
	
}