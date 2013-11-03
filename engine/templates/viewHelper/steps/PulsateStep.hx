package engine.templates.viewHelper.steps;

import engine.base.RueObject;
import engine.gameElements.interfaces.IMotionStep;
import engine.templates.RueView;
import engine.templates.viewHelper.steps.enums.Ease;

/**
 * ...
 * @author Jakegr
 */

class PulsateStep 
 extends RueObject implements IMotionStep
{
	static var Head:PulsateStep;
	var Next:PulsateStep;
	var Self:PulsateStep;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Target:RueView, PulsateToScale:Float, OverThisMuchTime:Float, EaseInType:Ease, EaseBackType:Ease):PulsateStep
	{
		var Vessel:PulsateStep;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new PulsateStep(); }
		Vessel.InPool = false;
		
		return Vessel;
	}
	
	public function Step():Bool 
	{
		return true;
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