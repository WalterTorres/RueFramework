package engine.components;
import engine.base.RueObject;
import engine.World;

/**
 * ...
 * @author Walter
 */

class PositionComponent extends RueObject
{
	static var Head:PositionComponent;
	var Next:PositionComponent;
	var Self:PositionComponent;

	public var _X:Float; 
	public var _Y:Float;
	

	private function new() 
	{
					
		super();
		Self = this;
	}
	
	public static function Create(X:Float = 0, Y:Float = 0):PositionComponent
	{
		var Vessel:PositionComponent;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new PositionComponent(); }
		Vessel.InPool = false;
		Vessel.Adjust(X, Y);
		
		return Vessel;
	}
	
	public inline function AddXY(X:Float, Y:Float):Void
	{
		_X += X;
		_Y += Y;
	}
	
	public inline function Adjust(X:Float, Y:Float):Void //call adjust in the pre update phase.
	{
		_X = X;
		_Y = Y;
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