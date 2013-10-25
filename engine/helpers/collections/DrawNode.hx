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
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create(X:Float, Y:Float, Frame:Float, Rotation:Float):DrawNode
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
		
		Vessel.PositionX = Std.int(X);
		Vessel.PositionY = Std.int(Y);
		Vessel.Frame = Frame;
		Vessel.Rotation = Rotation;
		Vessel.NextNode = null;
		
		return Vessel;
	}
	
	public inline function Recycle():Void
	{
		Next = Head;
		Head = Self;
	}
		
	
}