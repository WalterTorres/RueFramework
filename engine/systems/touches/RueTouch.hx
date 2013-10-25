package engine.systems.touches;
import engine.helpers.RueMath;

/**
 * ...
 * @author Jakegr
 */
class RueTouch
{
	public var _InitialX:Float;
	public var _InitialY:Float;
	
	public var _IsActive:Bool;
	public var _X:Float;
	public var _Y:Float;
	public var _LastX:Float;
	public var _LastY:Float;
	
	public var _CamX:Float;
	public var _CamY:Float;
	public var _LastCamX:Float;
	public var _LastCamY:Float;
	
	public function new() 
	{
		_IsActive = false;
		_X = 0;
		_Y = 0;
		_LastX = 0;
		_LastY = 0;
		_InitialX = 0;
		_InitialY = 0;
	}
	
	public function Dragged():Bool
	{
		return (RueMath.Abs(_InitialX - _X) + RueMath.Abs(_InitialY - _Y)) > 150;
	}
	
	public function GetTickDeltaX():Float
	{
		if (_IsActive)
		{
			return _X - _LastX;
		}
		
		return 0.0;
	}
	
	public function GetTickDeltaY():Float
	{
		if (_IsActive)
		{
			return _Y - _LastY;
		}
		
		return 0.0;
	}
	
}