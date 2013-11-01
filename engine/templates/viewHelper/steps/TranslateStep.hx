package engine.templates.viewHelper.steps;
import engine.base.RueObject;
import engine.gameElements.interfaces.IMotionStep;
import engine.helpers.Profiler;
import engine.helpers.RueMath;
import engine.templates.RueView;

/**
 * ...
 * @author Jakegr
 */

class TranslateStep extends RueObject implements IMotionStep
{
	static var Head:TranslateStep;
	var Next:TranslateStep;
	var Self:TranslateStep;
	
	var _AmountX:Float;
	var _AmountY:Float;
	var _SpeedX:Float;
	var _SpeedY:Float;
	var _Target:RueView;
	
	private function new() 
	{
		super();
		Self = this;
	}
	
	/**
	 * This step will interpolate the view from wherever it is by the ammount specified, at the speed specified.
	 * 
	 * @param	AmountX		The amount the view will translate in the X axis.
	 * @param	AmountY		The amount the view will translate in the Y axis.
	 * @param	SpeedX		The speed the view will travel the desired ammount X (Speed pixels a second).
	 * @param	SpeedY		The speed the view will travel the desired ammount Y (Speed pixels a second).
	 * @param	Target		The target view for the translation.
	 * @return
	 */
	public static function Create(AmountX:Float, AmountY:Float, SpeedX:Float, SpeedY:Float, Target:RueView):TranslateStep
	{
		var Vessel:TranslateStep;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new TranslateStep(); }
		Vessel.InPool = false;
		Vessel._AmountX = AmountX;
		Vessel._AmountY = AmountY;
		Vessel._SpeedX = SpeedX;
		Vessel._SpeedY = SpeedY;
		Vessel._Target = Target;
		
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
		var XDone:Bool = false;
		var ToAddX:Float = 0;
		if (_AmountX != 0){
			var XDirection:Int = RueMath.AbsoluteDirection(_AmountX);
			ToAddX = _SpeedX * Profiler.ElapsedTime * XDirection;
			var LeftX:Float = _AmountX - ToAddX;
			if (LeftX != 0){
				var NewDirectionX:Int = RueMath.AbsoluteDirection(LeftX);
				if (NewDirectionX != XDirection){
					XDone = true;
					ToAddX += (LeftX * -1);
				}
			}
			_AmountX -= ToAddX;
		}
		else{
			XDone = true;
		}
		
		
		var YDone:Bool = false;
		var ToAddY:Float = 0;
		if (_AmountY != 0){
			var YDirection:Int = RueMath.AbsoluteDirection(_AmountY);
			ToAddY = _SpeedY * Profiler.ElapsedTime * YDirection;
			var LeftY:Float = _AmountY - ToAddY;
			if (LeftY != 0){
				var NewDirectionY:Int = RueMath.AbsoluteDirection(LeftY);
				if (NewDirectionY != YDirection){
					YDone = true;
					ToAddY += (LeftY * -1);
				}
			}
			_AmountY -= ToAddY;
		}
		else{
			YDone = true;
		}
		
		_Target._Position.AddXY(ToAddX, ToAddY);
		
		if (XDone && YDone)
		{
			return true;
		}
		
		return false;
	}
		
	
}