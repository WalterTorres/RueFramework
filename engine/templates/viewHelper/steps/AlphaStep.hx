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

class AlphaStep extends RueObject implements IMotionStep
{
	static var Head:AlphaStep;
	var Next:AlphaStep;
	var Self:AlphaStep;
	
	var _StartAlpha:Float;
	var _EndAlpha:Float;
	var _OverThisMuhcTime:Float;
	var _Elapsed:Float;
	var _Target:RueView;
	var _Ease:Ease;
	

	private function new() 
	{
		super();
		Self = this;
	}
	
	public static function Create(Target:RueView, StartAlpha:Float, EndAlpha:Float, OverThisMuhcTime:Float, EaseOption:Ease):AlphaStep
	{
		var Vessel:AlphaStep;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new AlphaStep(); }
		Vessel.InPool = false;
		
		Vessel._Target = Target;
		Vessel._StartAlpha = StartAlpha;
		Vessel._EndAlpha = EndAlpha;
		Vessel._OverThisMuhcTime = OverThisMuhcTime;
		Vessel._Elapsed = 0.0;
		Vessel._Ease = EaseOption;
		
		return Vessel;
	}
	
	public function Step():Bool 
	{
		_Elapsed += Profiler.ElapsedTime / _OverThisMuhcTime;
		
		var CurrentAlpha:Float = 0;
		switch(_Ease)
		{
			case EASE_IN:
			{
				CurrentAlpha = RueMath.Lerp3(_StartAlpha, _EndAlpha, _Elapsed);
			}
			
			case BOUNCE_IN:
			{
				CurrentAlpha = RueMath.Lerp3Inverted(_StartAlpha, _EndAlpha, _Elapsed);
			}
			
			default:
			{
				CurrentAlpha = RueMath.Lerp(_StartAlpha, _EndAlpha, _Elapsed);
			}
		}
		
		_Target._Graphics.ChangeAlphaOfAllTo(CurrentAlpha);
		if (CurrentAlpha == _EndAlpha)
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
	
	/* INTERFACE engine.gameElements.interfaces.IMotionStep */
	

		
	
}