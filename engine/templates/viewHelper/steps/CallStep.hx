package engine.templates.viewHelper.steps;
import engine.base.RueObject;
import engine.gameElements.interfaces.IMotionStep;

/**
 * ...
 * @author Jakegr
 */

class CallStep extends RueObject implements IMotionStep
{
	static var Head:CallStep;
	var Next:CallStep;
	var Self:CallStep;
	
	var _Call:Void->Void;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Call:Void->Void):CallStep
	{
		var Vessel:CallStep;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new CallStep(); }
		Vessel.InPool = false;
		
		Vessel._Call = Call;
		
		return Vessel;
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			_Call = null;
			super.Recycle();
		}
	}
	
	override public function OnRebirth():Void
	{
		Next = Head;
		Head = Self;
	}
	
	/* INTERFACE engine.gameElements.interfaces.IMotionStep */
	
	public function Step():Bool 
	{
		_Call();
		return true;
	}
		
	
}