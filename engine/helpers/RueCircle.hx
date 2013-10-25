package engine.helpers;

/**
 * ...
 * @author Jakegr
 */

class RueCircle
{
	static var Head:RueCircle;
	var Next:RueCircle;
	var Self:RueCircle;
	
	public var _Radius:Float;
	public var _X:Float; //reffers to the top left
	public var _Y:Float;
	
	private function new() 
	{
		Self = this;
	}
	
	public static function Create(Radius:Float, X:Float, Y:Float):RueCircle
	{
		var Vessel:RueCircle;
		if(Head != null) { Vessel = Head; Head = Head.Next; }
		else { Vessel = new RueCircle(); }
		Vessel._Radius = Radius;
		Vessel._X = X;
		Vessel._Y = Y;
		
		return Vessel;
	}
	
	public function ContainsXY(X:Float, Y:Float):Bool
	{
		var CenterX:Float = _X + _Radius;
		var CenterY:Float = _Y + _Radius;
		
		var DistanceSQR:Float = RueMath.SquareMagnitude(CenterX - X, CenterY - Y);
		return DistanceSQR <= RueMath.Square(_Radius);
	}
	
	public function Intersects(ThisCircle:RueCircle):Bool
	{
			var CenterX:Float = _X + _Radius;
			var CenterY:Float = _Y + _Radius;
			var RadiusSquare:Float = RueMath.Square(_Radius);
			var CenterX2:Float = ThisCircle._X + ThisCircle._Radius;
			var CenterY2:Float = ThisCircle._Y + ThisCircle._Radius;
			var RadiusSquare2:Float = RueMath.Square(ThisCircle._Radius);
			var RadiusTogether:Float = RadiusSquare + RadiusSquare2;
			var Distance:Float = RueMath.LenSquared(CenterX - CenterX2, CenterY - CenterY2);
			return RadiusTogether >= Distance;
	}
	
	
	public function CheckVsRec(Rec:RueRectangle):Bool
	{
		var RecCenterX:Float = Rec.X + Rec.HalfWidth;
		var RecCenterY:Float = Rec.Y + Rec.HalfHeight;
		
		var circleDistanceX:Float = _X - RecCenterX;
		var circleDistanceY:Float = _Y - RecCenterY;
		
		if (circleDistanceX < 0)
		{
			circleDistanceX = -circleDistanceX;
		}
		if (circleDistanceY < 0)
		{
			circleDistanceY = -circleDistanceY;
		}
		
		if (circleDistanceX > (Rec.HalfWidth + _Radius))
		{
			return false;
		}
		if (circleDistanceY > (Rec.HalfHeight + _Radius))
		{
			return false;
		}
		if (circleDistanceX <= (Rec.HalfWidth))
		{
			return true;
		}
		if (circleDistanceY <= (Rec.HalfHeight))
		{
			return true;
		}
		
		var FirstExpo:Float = circleDistanceX - Rec.HalfWidth;
		var SecondExpo:Float = circleDistanceY - Rec.HalfHeight;
		FirstExpo *= FirstExpo;
		SecondExpo *= SecondExpo;
		
		return FirstExpo + SecondExpo <= RueMath.Square(_Radius);
	}
	
	public function CheckAgainstLine(Line:RueLine):Bool
	{
		return Line.CheckVSCircle(Self);
	}

	public function Recycle():Void
	{
		Next = Head;
		Head = Self;
	}

}