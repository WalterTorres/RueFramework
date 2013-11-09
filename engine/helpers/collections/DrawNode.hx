package engine.helpers.collections;

import engine.systems.TileRenderSystem;

/**
 * ...
 * @author Jakegr
 */

class DrawNode 
{
	static var Head:DrawNode;
	var Next:DrawNode;
	var Self:DrawNode;
	
	public var NextNode:DrawNode;
	
	public var PositionX:Float;
	public var PositionY:Float;
	public var Frame:Float;
	public var Rotation:Float;
	public var Alpha:Float;
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create(X:Float, Y:Float, Frame:Float, Rotation:Float, Alpha:Float):DrawNode
	{
		var Vessel:DrawNode;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new DrawNode();
		}
		
		Vessel.PositionX = X;// Std.int(X);
		Vessel.PositionY = Y;// Std.int(Y);
		Vessel.Frame = Frame;

		Vessel.Rotation = Rotation;
		Vessel.Alpha = Alpha;
		Vessel.NextNode = null;
		
		return Vessel;
	}
	
	public function RecycleInChain():Void
	{
		Recycle();
		if (NextNode != null)
		{
			NextNode.RecycleInChain();
		}
		
	}
	
	public inline function Recycle():Void
	{
		Next = Head;
		Head = Self;
	}
		
	
}