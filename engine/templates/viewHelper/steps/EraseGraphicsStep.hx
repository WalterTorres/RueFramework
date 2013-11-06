package engine.templates.viewHelper.steps;

import engine.base.RueObject;
import engine.gameElements.interfaces.IMotionStep;
import engine.templates.RueView;

/**
 * ...
 * @author Jakegr
 */

class EraseGraphicsStep 
 extends RueObject implements IMotionStep
{
	static var EraseGraphicsStepHead:EraseGraphicsStep;
	var EraseGraphicsStepNext:EraseGraphicsStep;
	var EraseGraphicsStepSelf:EraseGraphicsStep;
	
	var _Target:RueView;
	
	private function new() 
	{
		super();
		EraseGraphicsStepSelf = this;
	}
	
	public static function Create(Target:RueView):EraseGraphicsStep
	{
		var Vessel:EraseGraphicsStep;
		if(EraseGraphicsStepHead != null) { Vessel = EraseGraphicsStepHead; EraseGraphicsStepHead = EraseGraphicsStepHead.EraseGraphicsStepNext; }
		else { Vessel = new EraseGraphicsStep(); }
		Vessel.InPool = false;
		
		Vessel._Target = Target;
		
		return Vessel;
	}
	
	public function Step():Bool 
	{
		_Target._Graphics.RecycleElements();
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
		EraseGraphicsStepNext = EraseGraphicsStepHead;
		EraseGraphicsStepHead = EraseGraphicsStepSelf;
	}
		
	
}