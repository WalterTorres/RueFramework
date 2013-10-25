package engine.templates.collections;
import engine.base.RueObject;

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
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		Next = Head;
		Head = Self;
	}
		
	
}