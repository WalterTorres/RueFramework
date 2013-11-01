package engine.templates.viewHelper;
import engine.base.RueObject;
import engine.gameElements.interfaces.IMotionStep;

/**
 * ...
 * @author Jakegr
 */

class MotionStep extends RueObject implements IMotionStep
{
	static var Head:MotionStep;
	var Next:MotionStep;
	var Self:MotionStep;
	
	var _Operator:IMotionStep;
	var _NextStep:MotionStep;
	var _Owner:ViewManipulator;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Step:IMotionStep, Owner:ViewManipulator):MotionStep
	{
		var Vessel:MotionStep;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new MotionStep(); }
		Vessel.InPool = false;
		Vessel._Operator = Step;
		Vessel._Owner = Owner;
		Vessel._NextStep = null;
		
		return Vessel;
	}
	
	public function Step():Bool
	{
		if (_Operator.Step())
		{
			_Owner._CurrentlyDoing = _NextStep;
			Recycle();
			return true;
		}
		return false;
	}
	
	public function AddStep(AnotherStep:MotionStep):Void
	{
		if (_NextStep != null)
		{
			_NextStep.AddStep(AnotherStep);
		}
		else
		{
			_NextStep = AnotherStep;
		}
	}
	
	override public function Recycle():Void
	{
		if(!InPool)
		{
			_Operator.Recycle();
			super.Recycle();
		}
	}
	
	public function KillButton():Void
	{
		Recycle();
		if (_NextStep != null)
		{
			_NextStep.KillButton();
		}
	}
	
	override public function OnRebirth():Void
	{
		Next = Head;
		Head = Self;
	}
		
	
}