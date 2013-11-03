package engine.helpers;


/**
 * ...
 * @author Jakegr
 */

class RueRectangle 
{
	static var Head:RueRectangle;
	var Next:RueRectangle;
	var Self:RueRectangle;
	
	public var Width:Float;
	public var Height:Float;
	
	//public var HalfWidth:Float;
	//public var HalfHeight:Float;
	
	public var X:Float;
	public var Y:Float;
	
	public var OffsetX:Float;
	public var OffsetY:Float;
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create(X:Float, Y:Float, Width:Float, Height:Float, OffsetX:Float = 0, OffsetY:Float = 0):RueRectangle
	{
		var Vessel:RueRectangle;
		if(Head != null)
		{
			Vessel = Head;
			Head = Head.Next;
		}
		else 
		{
			Vessel = new RueRectangle();
		}
		
		Vessel.X = X + OffsetX;
		Vessel.Y = Y + OffsetY;
		Vessel.OffsetX = OffsetX;
		Vessel.OffsetY = OffsetY;
		Vessel.Width = Width;
		Vessel.Height = Height;
		//Vessel.HalfWidth = Width *0.5;
		//Vessel.HalfHeight = Height * 0.5;
		return Vessel;
	}

	
	public inline function AdjustBody(OwnerX:Float, OwnerY:Float):Void
	{
		X = OwnerX + OffsetX;
		Y = OwnerY + OffsetY;
	}
	
	public function CheckVsRec(Rec:RueRectangle):Bool
	{
		  return Rec.X < X + Width &&
                   X < Rec.X + Rec.Width &&
                   Rec.Y < Y + Height &&
                   Y < Rec.Y + Rec.Height;
	}
	
	public function ContainsRect(Rect:RueRectangle):Bool
	{
		if (ContainsFPoint(Rect.X, Rect.Y))
		{
			if (ContainsFPoint(Rect.X + Rect.Width, Rect.Y + Rect.Height))
			{
				return true;
			}
		}
		
		return false;
	}
	
	public inline function ContainsPoint(PosX:Int, PosY:Int):Bool
    {
        return ((((X <= PosX) && (PosX < X + Width)) && (Y <= PosY)) && (PosY < Y + Height));
    }
	
	public inline function ContainsFPoint(PosX:Float, PosY:Float):Bool
	{
		 return ((((X <= PosX) && (PosX < X + Width)) && (Y <= PosY)) && (PosY < Y + Height));
	}
	
	public function Recycle():Void
	{
		Next = Head;
		Head = Self;
	}
}