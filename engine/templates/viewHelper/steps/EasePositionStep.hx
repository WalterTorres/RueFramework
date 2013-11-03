package engine.templates.viewHelper.steps;

import engine.base.RueObject;
import engine.gameElements.interfaces.IMotionStep;
import engine.helpers.Profiler;
import engine.helpers.RueMath;
import engine.templates.RueView;
import engine.templates.viewHelper.steps.enums.Ease;

/**
 * ...
 * @author Jakegr
 */

class EasePositionStep 
 extends RueObject implements IMotionStep
{
	static var Head:EasePositionStep;
	var Next:EasePositionStep;
	var Self:EasePositionStep;
	
	var _Target:RueView;
	var _FromX:Float;
	var _FromY:Float;
	var _ToX:Float;
	var _ToY:Float;
	var _OverThisMuchTime:Float;
	var _Elapsed:Float;
	var _Ease:Ease;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Target:RueView, FromX:Float, FromY:Float, ToX:Float, ToY:Float, OverThisMuchTime:Float, EaseType:Ease):EasePositionStep
	{
		var Vessel:EasePositionStep;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new EasePositionStep(); }
		Vessel.InPool = false;
		
		Vessel._Target = Target;
		Vessel._FromX = FromX;
		Vessel._FromY = FromY;
		Vessel._ToX = ToX;
		Vessel._ToY = ToY;
		Vessel._OverThisMuchTime = OverThisMuchTime;
		Vessel._Ease = EaseType;
		Vessel._Elapsed = 0.0;
		
		return Vessel;
	}
	
	public function Step():Bool 
	{
		
		_Elapsed += Profiler.ElapsedTime / _OverThisMuchTime;
		var CurrentX:Float = 0;
		var CurrentY:Float = 0;
		switch(_Ease)
		{
			case EASE_IN:
			{
				CurrentX = RueMath.Lerp3(_FromX, _ToX, _Elapsed);
				CurrentY = RueMath.Lerp3(_FromY, _ToY, _Elapsed);
			}
			
			case BOUNCE_IN:
			{
				CurrentX = RueMath.Lerp3Inverted(_FromX, _ToX, _Elapsed);
				CurrentY = RueMath.Lerp3Inverted(_FromY, _ToY, _Elapsed);
			}
			
			default:
			{
				CurrentX = RueMath.Lerp(_FromX, _ToX, _Elapsed);
				CurrentY = RueMath.Lerp(_FromY, _ToY, _Elapsed);
			}
			
		}
		
		_Target._Position._X = CurrentX;
		_Target._Position._Y = CurrentY;
		
		if (_Elapsed >= 1.0)
		{
			return true;
		}
		return false;
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