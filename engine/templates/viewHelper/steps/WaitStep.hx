package engine.templates.viewHelper.steps;
import engine.base.RueObject;
import engine.gameElements.interfaces.IMotionStep;
import engine.helpers.Profiler;

/**
 * ...
 * @author Jakegr
 */

class WaitStep extends RueObject implements IMotionStep
{
	static var Head:WaitStep;
	var Next:WaitStep;
	var Self:WaitStep;
	
	var _WaitAmount:Float;
	
	private function new() 
	{
		
		super();
		Self = this;
	}
	
	public static function Create(Wait:Float = 0):WaitStep
	{
		var Vessel:WaitStep;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new WaitStep(); }
		Vessel.InPool = false;
		Vessel._WaitAmount = Wait;
		
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
	
	/* INTERFACE engine.helpers.interfaces.IMotionStep */
	
	public function Step():Bool 
	{
		_WaitAmount -= Profiler.ElapsedTime;
		if (_WaitAmount <= 0)
		{
			return true;
		}
		return false;
	}
		
	
}